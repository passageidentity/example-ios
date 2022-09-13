//
//  WelcomeViewController.swift
//  example-ios
//

import Passage
import UIKit

final class WelcomeViewController: UIViewController {
    
    var user: User? = nil
    var showAddDeviceButton = false
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var userDevicesStackView: UIStackView!
    
    @IBAction func onPressAddDevice(_ sender: Any) {
        presentSavePasskeyViewController()
    }
    
    @IBAction func onPressLogout(_ sender: Any) {
        Task {
            try? await PassageAuth.signOut()
            let _ = navigationController?.popToRootViewController(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        emailLabel.text = ""
        addDeviceButton.isHidden = !showAddDeviceButton
        showUserDetails()
    }
    
    private func showUserDetails() {
        Task {
            guard let user else { return }
            emailLabel.text = user.email
            guard let userDevices = try? await PassageAuth.listDevices(token: user.token) else { return }
            showDeviceNames(userDevices: userDevices)
        }
    }
    
    private func showDeviceNames(userDevices: [DeviceInfo]) {
        for device in userDevices {
            let label = UILabel()
            label.text = device.friendly_name
            label.textAlignment = .center
            label.font = label.font.withSize(14)
            userDevicesStackView.addArrangedSubview(label)
        }
    }
    
    private func presentSavePasskeyViewController() {
        guard let user else { return }
        let savePasskeyViewController = storyboard?
            .instantiateViewController(withIdentifier: "SavePasskeyViewController") as! SavePasskeyViewController
        savePasskeyViewController.modalPresentationStyle = .popover
        savePasskeyViewController.user = user
        present(savePasskeyViewController, animated: true)
    }
    
}
