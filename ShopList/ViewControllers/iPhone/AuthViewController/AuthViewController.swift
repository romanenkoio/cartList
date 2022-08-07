//
//  AuthViewController.swift
//  ShopList
//
//  Created by Andrew Moroz on 25.07.22.
//

import UIKit
import Firebase
import CryptoKit
import AuthenticationServices
import Lottie

class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playAnimation()
    }
    
    private func playAnimation() {
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.animation = Animation.named("login")
        animationView.play()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        handleAuthorizationAppleID { uid, name, error in
            
        }
    }
    
    func handleAuthorizationAppleID(closer: @escaping (String?, String?, Error?)->()) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else { return }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                return
            }
            
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    return
                }
                
                guard let user = Auth.auth().currentUser else { return }
                SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue).child(user.uid).updateChildValues(["email": user.email!])
                SLFirManager.userByEmail(user.email!, isSearch: false) { currentUser in
                    if currentUser.name == nil {
                        SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue).child(currentUser.uid!).updateChildValues(["username": "User#\(Int.random(in: 1...5000))"])
                    }
                }

                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.setTabBarScreen()
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension AuthViewController {
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

