import Passage
import UIKit

final class PasscodeViewController: UIViewController {
    
    var oneTimePasscodeId: String? = nil
    var email: String? = nil
    var isShowingRegister = false
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func onPressButton(_ sender: Any) {
        guard let oneTimePasscodeId, let otp = textField.text else { return }
        Task {
            let result = try? await PassageAuth.oneTimePasscodeActivate(otp: otp, otpId: oneTimePasscodeId)
            guard let token = result?.authToken else {
                let alert = UIAlertController(title: "Invalid passcode", message: "Please try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            pushWelcomeViewController(token: token)
        }
    }
    
    @IBAction func onPressResendButton(_ sender: Any) {
        guard let email else { return }
        Task {
            if isShowingRegister {
                oneTimePasscodeId = try? await PassageAuth.newRegisterOneTimePasscode(identifier: email).id
            } else {
                oneTimePasscodeId = try? await PassageAuth.newLoginOneTimePasscode(identifier: email).id
            }
            let alert = UIAlertController(title: "Passcode resent", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func pushWelcomeViewController(token: String) {
        let welcomeViewController = storyboard?
            .instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        welcomeViewController.token = token
        if !isShowingRegister, #available(iOS 16.0, *) {
            // If existing user logs in for first time on this device using OTP, allow to add Passkey
            welcomeViewController.showAddDeviceButton = true
        }
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}
