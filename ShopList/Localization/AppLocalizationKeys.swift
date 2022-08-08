//
//  AppLocalizationKeys.swift
//  ShopList
//
//  Created by Alina Karpovich on 13.06.22.
//

import Foundation

class AppLocalizationKeys {
    
    //Premium Points
    static let premiumAdvantages = "premium.advantages"
    static let premiumInfo = "premium.info"
    static let premiumMonthSub = "premium.monthSub"
    static let premiumyYearSub = "premium.yearSub"
    static let premiumForeverSub = "premium.foreverSub"
    static let restorePurchases = "premium.restorePurchases"
    static let premiumTerms = "premium.terms"
    static let premiumPrivacy = "premium.privacy"
    
    //Profile Points
    static let profileHeader = "profile.Header"
    static let accountType = "profile.accountType"
    static let listsCount = "profile.listsCount"
    static let editProfile = "profile.edit"
    static let deleteProfile = "profile.deleteProfile"
    static let logOut = "profile.logOut"
    static let saveChanges = "profile.save"
    static let cancelChanges = "profile.cancel"

    //Avatar Points
    static let selectActionHeader = "avatar.selectActionHeader"
    static let selectPhoto = "avatar.selectPhoto"
    static let deletePhoto = "avatar.deletePhoto"
    static let photoDeleteHeader = "avatar.photoDeleteHeader"
    static let photoDeleteText = "avatar.photoDeleteText"
    static let cancelPhotoDelete = "avatar.cancelPhotoDelete"
    static let confirmPhotoDelete = "avatar.confirmPhotoDelete"
    
    //ProfileDelete Points
    static let profileDeleteHeader = "profileDelete.profileDeleteHeader"
    static let profileDeleteText = "profileDelete.profileDeleteText"
    static let cancelProfileDelete = "profileDelete.cancelProfileDelete"
    static let confirmProfileDelete = "profileDelete.confirmProfileDelete"
    
    //Logout Points
    static let logoutHeader = "logout.logoutHeader"
    static let logoutText = "logout.logoutText"
    static let cancelLogout = "logout.cancelLogout"
    static let confirmLogout = "logout.confirmLogout"
    
    //Settings Point
    static let authHeader = "settings.authHeader"
//    static let signIn = "settings.signIn"
//    static let registration = "settings.registration"
    static let premium = "settings.premium"
    static let profileName = "settings.profileName"
    static let listHeader = "settings.listHeader"
    static let separateList = "settings.separateList"
    static let autoDelete = "settings.autoDelete"
    static let notificationHeader = "settings.notificationHeader"
    static let useLocationPush = "settings.useLocationPush"
    static let raduis = "settings.raduis"
    static let mapPoint = "settings.mapPoint"
    static let useTimePush = "settings.useTimePush"
    static let morningTime = "settings.morningTime"
    static let infoHeader = "settings.infoHeader"
    static let language = "settings.language"
    static let version = "settings.version"
    static let versionInfo = "settings.versionInfo"
    static let radiusUnit = "settings.radiusUnit"
    static let settings = "settingVC.settings"
    static let deleteCompletedList = "settingsVC.deleteCompletedList"
    static let chooseLanguage = "settingsVC.chooseLanguage"
    static let setLanguage = "settingsVC.setLanguage"
    static let back = "settingsVC.back"
    static let feedback = "settingsVC.feedback"
    
    static let list = "addType.list"
    static let product = "addType.product"
    
    static let yourStores = "shopListVC.yourStores"
    static let add = "shopListVC.add"
    static let choose = "shopListVC.choose"
    static let selectOnTheMap = "shopListVC.selectOnTheMap"
    static let addLocation = "shopListVC.addLocation"
    static let savedPoint = "shopListVC.savedPoint"
    static let nameShop = "shopListVC.nameShop"
    
    static let refreshTitle = "alerts.refreshTitle"
    static let shareTitle = "alerts.shareTitle"
    static let refresh = "alerts.refresh"
    static let mapType = "alerts.mapType"
    static let saveCoordinate = "alerts.saveCoordinate"
    static let share = "alerts.share"
    
    static let pieces = "package.pieces"
    static let kilograms = "package.kilograms"
    static let litres = "package.litres"
    static let package = "package.package"
    static let jar = "package.jar"
    static let piecesAbb = "package.piecesAbb"
    static let kilogramsAbb = "package.kilogramsAbb"
    static let litresAbb = "package.litresAbb"
    static let packageAbb = "package.packageAbb"
    static let jarAbb = "package.jarAbb"

    static let tipView = "mapVC.tipView"
    static let mapActionTitle = "mapVC.mapActionTitle"
    static let locationActionTitle = "mapVC.locationActionTitle"
    
    static let addProductsFromClipboards = "productList.addProductsFromClipboards"
    static let preferredStore = "productList.preferredStore"
    static let clearProgress = "productList.clearProgress"
    static let needToBuy = "productList.needToBuy"
    static let bought = "productList.bought"
    static let deleteList = "productList.deleteList"
    static let confirm = "productList.confirm"
    static let deleteEntry = "productList.deleteEntry"
    static let emptyLabel = "productList.emptyLabel"
    static let addProduct = "productList.addProduct"

    static let unit = "allVC.unit"
    static let delete = "allVC.delete"
    static let cancel = "allVC.cancel"
    static let save = "allVC.save"
    static let unsubscribeFromList = "allVC.unsubscribe"
    
    static let myLists = "tabBarVC.myLists"
    static let shops = "tabBarVC.shops"
    
    static let pinchList = "mainListVC.pinchList"
    static let text = "mainListVC.text"
    static let seeMyList = "mainListVC.seeMyList"
    static let file = "mainListVC.file"
    static let pin = "mainListVC.pin"
    static let unpin = "mainListVC.unpin"
    static let addUser = "mainListVC.addUser"
    static let alertShare = "mainListVC.share"
    static let specifyStore = "mainListVC.specifyStore"
    static let untieStore = "mainListVC.untieStore"
    static let emptyLists = "mainListVC.emptyLists"
    static let createList = "mainListVC.createList"
    static let manageUsers = "mainListVC.manageUsers"

    static let importLists = "importManager.importLists"
    static let yes = "importManager.yes"
    
    static let timeToCheck = "notification.timeToCheck"
    static let youBought = "notification.youBought"
    static let youNear = "notification.youNear"
    static let checkTheLists = "notification.checkTheLists"

    static let listPlaceholders = [NSLocalizedString("lasagna", comment: ""),
                                   NSLocalizedString("tortilla", comment: ""),
                                   NSLocalizedString("braisedCabbage", comment: ""),
                                   NSLocalizedString("bakedBeans", comment: ""),
                                   NSLocalizedString("pizza", comment: ""),
                                   NSLocalizedString("ragout", comment: ""),
                                   NSLocalizedString("vegetableSalad", comment: ""),
                                   NSLocalizedString("greekSalad", comment: ""),
                                   NSLocalizedString("caesarSalad", comment: ""),
                                   NSLocalizedString("mashedPotatoes", comment: "")]
    
    static let productPlaceholders = [NSLocalizedString("tomatoes", comment: ""),
                                      NSLocalizedString("peppers", comment: ""),
                                      NSLocalizedString("potatoes", comment: ""),
                                      NSLocalizedString("fishFillet", comment: ""),
                                      NSLocalizedString("beans", comment: ""),
                                      NSLocalizedString("onion", comment: ""),
                                      NSLocalizedString("chickenFillet", comment: ""),
                                      NSLocalizedString("bread", comment: ""),
                                      NSLocalizedString("pork", comment: ""),
                                      NSLocalizedString("rice", comment: ""),
                                      NSLocalizedString("buckwheat", comment: ""),
                                      NSLocalizedString("bulgur", comment: "")]
}

