//
//  SavePasskeyViewController.swift
//  example-ios
//

import Passage
import UIKit

final class SavePasskeyViewController: UIViewController {
    
    var token: String? = nil
    var passageUser: PassageUserInfo? = nil
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func onPressSave(_ sender: Any) {
        Task {
            guard let token, #available(iOS 16.0, *) else { return }
            try await PassageAuth.addDevice(token: token)
            dismiss(animated: true)
        }
    }
    
    @IBAction func onPressSkip(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = passageUser?.email
    }
    
}
