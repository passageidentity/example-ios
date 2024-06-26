//
//  LoginViewController.swift
//  example-ios
//

import Passage
import UIKit

final class LoginViewController: UIViewController {

    private var email = ""
    private var isShowingRegister = false {
        didSet {
            titleLabel.text = isShowingRegister ? "Register" : "Login"
            questionLabel.text = isShowingRegister ? "Already have an account?" : "Don't have an account?"
            switchButton.setTitle(isShowingRegister ? "Login" : "Register", for: .normal)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!

    @IBAction func onPressContinue(_ sender: Any) {
        view.endEditing(true)
        if isShowingRegister {
            handleRegister()
        } else {
            handleLogin()
        }
    }
    
    @IBAction func onChangeTextField(_ sender: UITextField) {
        email = sender.text ?? ""
        let isValidEmail = email.range(
            of: #"^\S+@\S+\.\S+$"#,
            options: .regularExpression
        ) != nil
        continueButton.isEnabled = isValidEmail
        errorLabel.isHidden = true
    }
    
    @IBAction func onPressSwitch(_ sender: Any) {
        isShowingRegister = !isShowingRegister
    }
    
    
    func onLoginSuccess(authResult: AuthResult) {
        DispatchQueue.main.async {
            self.pushWelcomeViewController(token: authResult.authToken)
        }
    }
    
    func onLoginError(error: Error) {
        DispatchQueue.main.async {
            self.displayError(message: "Error logging in with autofill")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If user has a valid token on device, skip login screen.
        Task {
            if let token = try? await passage.getAuthToken() {
                pushWelcomeViewController(token: token)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isShowingRegister = false
        errorLabel.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Task {
                try await passage.beginAutoFill(anchor: window ,onSuccess: self.onLoginSuccess, onError: self.onLoginError, onCancel: nil)
            }
        }
    }

    private func handleLogin() {
        Task {
            do {
                // Try logging in with passkey.
                let authResult = try await passage.loginWithPasskey(identifier: email)
                pushWelcomeViewController(token: authResult.authToken)
            } catch LoginWithPasskeyError.canceled {
                // User canceled passkey UX, do nothing.
            } catch LoginWithPasskeyError.userDoesNotExist {
                displayError(message: "Account not recognized")
            } catch {
                // If something goes wrong with passkey login, try One-Time Passcode login instead.
                if let otp = try? await passage.newLoginOneTimePasscode(identifier: email) {
                    pushPasscodeViewController(oneTimePasscodeId: otp.id)
                } else {
                    print(error)
                    // If OTP login fails too, show generic error message.
                    displayError(message: "Error logging in")
                }
            }
        }
    }
    
    private func handleRegister() {
        Task {
            do {
                let authResult = try await passage.registerWithPasskey(identifier: email)
                pushWelcomeViewController(token: authResult.authToken)
            } catch RegisterWithPasskeyError.canceled {
                // User cancelled, do nothing.
            } catch RegisterWithPasskeyError.userAlreadyExists {
                displayError(message: "Account already exists")
            } catch {
                // If something goes wrong with passkey registration, try One-Time Passcode registration instead.
                if let otp = try? await passage.newRegisterOneTimePasscode(identifier: email) {
                    pushPasscodeViewController(oneTimePasscodeId: otp.id)
                } else {
                    displayError(message: "Error registering your account")
                }
            }
        }
    }
    
    private func displayError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func pushCheckEmailViewController(magicLinkId: String) {
        let checkEmailViewController = storyboard?
            .instantiateViewController(withIdentifier: "CheckEmailViewController") as! CheckEmailViewController
        checkEmailViewController.email = email
        checkEmailViewController.isShowingRegister = isShowingRegister
        checkEmailViewController.magicLinkId = magicLinkId
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    private func pushPasscodeViewController(oneTimePasscodeId: String) {
        let passcodeViewController = storyboard?
            .instantiateViewController(withIdentifier: "PasscodeViewController") as! PasscodeViewController
        passcodeViewController.oneTimePasscodeId = oneTimePasscodeId
        passcodeViewController.email = email
        passcodeViewController.isShowingRegister = isShowingRegister
        navigationController?.pushViewController(passcodeViewController, animated: true)
    }
    
    private func pushWelcomeViewController(token: String) {
        let welcomeViewController = storyboard?
            .instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        welcomeViewController.token = token
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}
