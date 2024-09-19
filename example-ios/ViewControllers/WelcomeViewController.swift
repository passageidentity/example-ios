//
//  WelcomeViewController.swift
//  example-ios
//

import Passage
import UIKit

final class WelcomeViewController: UIViewController {
    
    var token: String? = nil
    var passageUser: CurrentUser?
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var userDevicesStackView: UIStackView!
    
    @IBAction func onPressAddDevice(_ sender: Any) {
        presentSavePasskeyViewController()
    }
    
    @IBAction func onPressLogout(_ sender: Any) {
        Task {
            do {
                try await passage.currentUser.logOut()
            } catch {
                print(error)
            }
            
            let _ = navigationController?.popToRootViewController(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        emailLabel.text = ""
        showUserDetails()
    }
    
    private func showUserDetails() {
        Task {
            guard let passageUserDetails = try? await passage.currentUser.userInfo() else { return }
            passageUser = passageUserDetails
            if let passageUserEmail = passageUser?.email {
                emailLabel.text = passageUserEmail
            }
            guard let userPasskeys = try? await passage.currentUser.passkeys() else { return }
            showPasskeyNames(userPasskeys: userPasskeys)
        }
    }
    
    private func showPasskeyNames(userPasskeys: [Passkey]) {
        for passkey in userPasskeys {
            let label = UILabel()
            label.text = passkey.friendlyName
            label.textAlignment = .center
            label.font = label.font.withSize(14)
            userDevicesStackView.addArrangedSubview(label)
        }
    }
    
    private func presentSavePasskeyViewController() {
        guard let passageUser else { return }
        guard let token else { return }
        let savePasskeyViewController = storyboard?
            .instantiateViewController(withIdentifier: "SavePasskeyViewController") as! SavePasskeyViewController
        savePasskeyViewController.modalPresentationStyle = .popover
        savePasskeyViewController.token = token
        savePasskeyViewController.passageUser = passageUser
        present(savePasskeyViewController, animated: true)
    }
    
}
