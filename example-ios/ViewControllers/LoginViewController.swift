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
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If user has a valid token on device, skip login screen.
        Task {
            if let token = try? await passage.tokenStore.getValidAuthToken() {
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
    }

    @IBAction func onPressPasskeyButton(_ sender: Any) {
        view.endEditing(true)
        Task {
            do {
                let authResult = isShowingRegister ?
                    try await passage.passkey.register(identifier: email) :
                    try await passage.passkey.login(identifier: email)
                pushWelcomeViewController(token: authResult.authToken)
            } catch PassagePasskeyError.canceled {
                // User cancelled passkey creation UX, do nothing.
            } catch PassagePasskeyError.userAlreadyExists {
                displayError(message: "Account already exists")
            } catch PassagePasskeyError.userDoesNotExist {
                displayError(message: "Account not recognized")
            } catch {
                displayError(message: "Error authenticating with passkey.")
            }
        }
    }
    
    @IBAction func onPressOTPButton(_ sender: Any) {
        view.endEditing(true)
        Task {
            do {
                let oneTimePasscode = isShowingRegister ?
                    try await passage.oneTimePasscode.register(identifier: email) :
                    try await passage.oneTimePasscode.login(identifier: email)
                pushPasscodeViewController(oneTimePasscodeId: oneTimePasscode.otpId)
            } catch {
                displayError(message: "Error authenticating with One-Time Passcode")
            }
        }
    }
    
    @IBAction func onPressMagicLinkButton(_ sender: Any) {
        view.endEditing(true)
        Task {
            do {
                let magicLink = isShowingRegister ?
                    try await passage.magicLink.register(identifier: email) :
                    try await passage.magicLink.login(identifier: email)
                pushCheckEmailViewController(magicLinkId: magicLink.id)
            } catch {
                displayError(message: "Error authenticating with Magic Link")
            }
        }
    }
    
    @IBAction func onChangeTextField(_ sender: UITextField) {
        email = sender.text ?? ""
        errorLabel.isHidden = true
    }
    
    @IBAction func onPressSwitch(_ sender: Any) {
        isShowingRegister = !isShowingRegister
    }
    
    
    func onLoginSuccess(authResult: AuthResult) {
        DispatchQueue.main.async { [weak self] in
            self?.pushWelcomeViewController(token: authResult.authToken)
        }
    }
    
    func onLoginError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.displayError(message: "Error logging in with autofill")
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
