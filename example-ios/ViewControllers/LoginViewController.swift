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
        if let token = authResult.auth_token {
            DispatchQueue.main.async {
                self.pushWelcomeViewController(token: token)
            }
        }
    }
    
    func onLoginError(error: Error) {
        DispatchQueue.main.async {
            self.displayError(message: "Error logging in with autofill")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 16.0, *) {
            guard let window = self.view.window else { fatalError("The view was not in the app's view hierarchy!") }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Task {
                    try await PassageAuth.beginAutoFill(anchor: window, onSuccess: self.onLoginSuccess, onError: self.onLoginError, onCancel: nil)
                }
            }
        }
        super.viewDidAppear(animated)
        isShowingRegister = false
        errorLabel.isHidden = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private func handleLogin() {
        Task {
            do {
                let result = try await PassageAuth.login(identifier: email)
                if let token = result.authResult?.auth_token {
                    pushWelcomeViewController(token: token)
                } else if let _ = result.magicLink {
                    pushCheckEmailViewController()
                } else {
                    displayError(message: "Error logging in")
                }
            } catch PassageError.userDoesNotExist {
                displayError(message: "Account not recognized")
            } catch PassageASAuthorizationError.canceled {
                // User cancelled, do nothing.
            } catch {
                displayError(message: "Error logging in")
            }
        }
    }
    
    private func handleRegister() {
        
        Task {
            do {
                let result = try await PassageAuth.register(identifier: email)
                if let token = result.authResult?.auth_token {
                    pushWelcomeViewController(token: token)
                } else if let _ = result.magicLink {
                    pushCheckEmailViewController()
                } else {
                    displayError(message: "Error registering your account")
                }
            } catch PassageError.userAlreadyExists {
                displayError(message: "Account already exists")
            } catch PassageASAuthorizationError.canceled {
                // User cancelled, do nothing.
            } catch {
                displayError(message: "Error registering your account")
            }
        }
    }
    
    private func displayError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func pushCheckEmailViewController() {
        let checkEmailViewController = storyboard?
            .instantiateViewController(withIdentifier: "CheckEmailViewController") as! CheckEmailViewController
        checkEmailViewController.email = email
        checkEmailViewController.isShowingRegister = isShowingRegister
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    private func pushWelcomeViewController(token: String) {
        let welcomeViewController = storyboard?
            .instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        welcomeViewController.token = token
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}
