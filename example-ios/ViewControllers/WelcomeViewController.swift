//
//  WelcomeViewController.swift
//  example-ios
//

import Passage
import UIKit

final class WelcomeViewController: UIViewController {
    
    var token: String? = nil
    var passageUser: PassageUserInfo? = nil
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var userDevicesStackView: UIStackView!
    
    @IBAction func onPressAddDevice(_ sender: Any) {
        presentSavePasskeyViewController()
    }
    
    @IBAction func onPressLogout(_ sender: Any) {
        Task {
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
            guard let passageUserDetails = try? await passage.getCurrentUser() else { return }
            passageUser = passageUserDetails
            if let passageUserEmail = passageUser?.email {
                emailLabel.text = passageUserEmail
            }
            guard let userDevices = try? await passage.listDevices() else { return }
            showDeviceNames(userDevices: userDevices)
        }
    }
    
    private func showDeviceNames(userDevices: [DeviceInfo]) {
        for device in userDevices {
            let label = UILabel()
            label.text = device.friendlyName
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
