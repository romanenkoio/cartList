//
//  NotificationManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UserNotifications
import CoreLocation

final class NotificationManager {
    enum NotificationID: String {
        case byTime
        case location
    }
    
    static private let notificationCenter = UNUserNotificationCenter.current()
    
    class func requestAuthorisation() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { success, error in
            if success {
                DispatchQueue.main.async {
                    scheduleTimeNotifications()
                    scheduleLocationNotifications()
                    getNotifications()
                }
            } else {
                DefaultsManager.timeNotification = false
                DefaultsManager.notificationByLocation = false
            }
        }
    }
    
    private class func scheduleNotification(title: String, subtitle: String, trigger: UNNotificationTrigger, type: NotificationID) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        
        let notification = UNNotificationRequest(identifier: "\(Int.random(in: 0...10000))", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notification)
    }
    
    class func scheduleTimeNotifications() {
        if !DefaultsManager.timeNotification {
            removeNotifications(type: .byTime)
            return
        }
        
        removeNotifications(type: .byTime)
        let componetns = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, hour: DefaultsManager.hours, minute: DefaultsManager.minutes)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componetns, repeats: true)
        scheduleNotification(title: "Время проверить ваши списки!", subtitle: "Вы купили всё нужное?", trigger: trigger, type: .byTime)
        getNotifications()
    }
    
    class func scheduleLocationNotifications() {
        if !DefaultsManager.notificationByLocation {
            removeNotifications(type: .location)
            return
        }
        
        let coordinates = RealmManager.read(type: SLRealmCoordinate.self)
        removeNotifications(type: .location)
        for item in coordinates {
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: Double(item.lat)!,
                                                                         longitude: Double(item.lon)!),
                                          radius: Double(DefaultsManager.baseRadius),
                                          identifier: UUID().uuidString)
            region.notifyOnEntry = true
            let trigger = UNLocationNotificationTrigger(region: region,
                                                        repeats: true)
            scheduleNotification(title: "Вы рядом с \(item.marketName)", subtitle: "Не хотите проверить списки?", trigger: trigger, type: .location)
        }
    }
    
    private class func removeNotifications(type: NotificationID) {
        var ids = [String]()
        notificationCenter.getPendingNotificationRequests { (notifications) in
            for item in notifications {
                switch type {
                case .byTime:
                    if (item.trigger as? UNCalendarNotificationTrigger) != nil {
                        ids.append(item.identifier)
                    }
                case .location:
                    if (item.trigger as? UNLocationNotificationTrigger) != nil {
                        ids.append(item.identifier)
                    }
                }
            }
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
            print("\(type.rawValue) notification was removed")
        }
    }
    
    private class func getNotifications() {
        notificationCenter.getPendingNotificationRequests { (notifications) in
            print("Set notification: \(notifications.count)")
            for item in notifications {
                print("Message: \(item.content.title). In \(item.trigger!)" )
            }
        }
    }
}
