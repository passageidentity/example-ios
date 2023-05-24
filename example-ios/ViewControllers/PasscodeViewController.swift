//
//  PasscodeViewController.swift
//  example-ios
//

import Passage
import UIKit

final class PasscodeViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func onPressButton(_ sender: Any) {
        guard let oneTimePasscodeId, let otp = textField.text else { return }
        Task {
            let result = try? await PassageAuth.oneTimePasscodeActivate(otp: otp, otpId: oneTimePasscodeId)
            if let token = result?.authToken {
                let ac = UIAlertController(title: "Passcode verified 😎", message: "Token: \(token)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
                present(ac, animated: true)
            }
        }
    }
    
    var oneTimePasscodeId: String? = nil
    
}
