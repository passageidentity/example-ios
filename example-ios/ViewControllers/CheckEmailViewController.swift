//
//  CheckEmailViewController.swift
//  example-ios
//

import Passage
import UIKit

final class CheckEmailViewController: UIViewController {
    
    var email: String? = nil
    var isShowingRegister = false
    var magicLinkId: String? = nil
    var pollingTimer: Timer? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func onPressResendEmail(_ sender: Any) {
        guard let email else { return }
        Task {
            if isShowingRegister {
                let _ = try? await passage.newRegisterMagicLink(identifier: email)
            } else {
                let _ = try? await passage.loginWithMagicLink(identifier: email)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.checkMagicLinkStatus()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pollingTimer?.invalidate()
    }
    
    func handleMagicLink(_ magicLink: String) {
        Task {
            guard let token = try? await passage.magicLinkActivate(userMagicLink: magicLink).authToken else {
                return
            }
            pushWelcomeViewController(token: token)
        }
    }
    
    private func checkMagicLinkStatus() {
        guard let magicLinkId else { return }
        Task {
            guard let token = try? await passage.getMagicLinkStatus(id: magicLinkId).authToken else {
                return
            }
            pushWelcomeViewController(token: token)
        }
    }
    
    private func pushWelcomeViewController(token: String) {
        let welcomeViewController = storyboard?
            .instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        welcomeViewController.token = token
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}
