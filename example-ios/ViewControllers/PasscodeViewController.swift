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
            let result = try? await passage.oneTimePasscodeActivate(otp: otp, otpId: oneTimePasscodeId)
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
                oneTimePasscodeId = try? await passage.newRegisterOneTimePasscode(identifier: email).id
            } else {
                oneTimePasscodeId = try? await passage.newLoginOneTimePasscode(identifier: email).id
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
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}
