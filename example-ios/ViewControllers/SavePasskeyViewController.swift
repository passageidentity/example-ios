//
//  SavePasskeyViewController.swift
//  example-ios
//

import Passage
import UIKit

final class SavePasskeyViewController: UIViewController {
    
    var user: User? = nil
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func onPressSave(_ sender: Any) {
        Task {
            guard let user, #available(iOS 16.0, *) else { return }
            let _ = try? await PassageAuth.addDevice(token: user.token)
            dismiss(animated: true)
        }
    }
    
    @IBAction func onPressSkip(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = user?.email
    }
    
}
