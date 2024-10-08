//
//  SavePasskeyViewController.swift
//  example-ios
//

import Passage
import UIKit

final class SavePasskeyViewController: UIViewController {
    
    var token: String? = nil
    var passageUser: CurrentUser? = nil
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func onPressSave(_ sender: Any) {
        Task {
            try await passage.currentUser.addPasskey()
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
