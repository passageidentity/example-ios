//
//  CheckEmailViewController.swift
//  example-ios
//

import Passage
import UIKit

final class CheckEmailViewController: UIViewController {
    
    var email: String? = nil
    var isShowingRegister = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func onPressResendEmail(_ sender: Any) {
        guard let email else { return }
        Task {
            if isShowingRegister {
                let _ = try? await PassageAuth.newRegisterMagicLink(identifier: email)
            } else {
                let _ = try? await PassageAuth.loginWithMagicLink(identifier: email)
            }
            let alert = UIAlertController(title: "Email resent", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = email ?? ""
        titleLabel.text = "Check email to \(isShowingRegister ? "register" : "login")"
        introLabel.text = "\(isShowingRegister ? "" : "We didn't recognize this device. ")We've sent an email to"
    }
    
    func handleMagicLink(_ magicLink: String) {
        Task {
            guard
                let email,
                let token = try? await PassageAuth.magicLinkActivate(userMagicLink: magicLink).auth_token else {
                    return
            }
            let user = User(email: email, token: token)
            let welcomeViewController = storyboard?
                .instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            welcomeViewController.user = user
            if !isShowingRegister, #available(iOS 16.0, *) {
                // If existing user logs in for first time on this device using Magic Link, allow to add Passkey
                welcomeViewController.showAddDeviceButton = true
            }
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
}
