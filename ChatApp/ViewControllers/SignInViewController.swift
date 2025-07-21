//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView  : UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField   .delegate = self
        passwordTextField.delegate = self
        
        drawcontainerView()
        drawcreateAccountTextView()
        
        tapRecognizerDismissKeyBoard()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
                  super.viewWillAppear(animated)
                   registerKeyboardNotifications()
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                 super.viewWillDisappear(animated)
                   removeKeyboardNotifications()
       }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name    : UIResponder.keyboardWillShowNotification,
                                               object  : nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name    : UIResponder.keyboardWillHideNotification,
                                               object  : nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name  : UIResponder.keyboardWillShowNotification ,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name  : UIResponder.keyboardWillHideNotification ,
                                                  object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height

        let totalOffset = keyboardHeight + (activeTextField?.frame.height ?? 0)

        scrollView.contentInset.bottom = totalOffset
    }
    
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    func tapRecognizerDismissKeyBoard() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func drawcontainerView() {
        containerView.clipsToBounds       = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func drawcreateAccountTextView() {
        let attributedString = NSMutableAttributedString(
            string    : "Don't have an account? Create an acount here",
            attributes: [NSAttributedString.Key.font : Font.linkLabel])
        
        attributedString.addAttribute(
            .link,
            value: "chatappcreate://createAccount",
            range: (attributedString.string as NSString).range(of: "Create an acount here"))
        
        createAccountTextView.attributedText     = attributedString
        createAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
        createAccountTextView.delegate           = self
        createAccountTextView.isScrollEnabled    = false
        createAccountTextView.textAlignment      = .center
        createAccountTextView.isEditable         = false
    }
    
    

    @IBAction func signinButtonTapped(_ sender: Any) {
        
        guard let password = passwordTextField.text else {
            presentErrorAlert(title  : "Password Required",
                              message: "Please enter a Password to continue.")
            return
        }
        
        guard let email = emailTextField.text else {
            presentErrorAlert(title  : "Email Required",
                              message: "Please enter a Email to continue.")
            return
        }
        
        showLoadingView()
        
        signinUser(email: email, password: password) { [weak self] success, error in
            guard let strongself = self else { return }
            
            strongself.removeLoadingView()
            
            if let error = error {
                print(error)
                strongself.presentErrorAlert(title: "SignIn Error", message: error)
                return
            }
            
            print("键盘关闭前")
            strongself.view.endEditing(true)
            print("键盘关闭后，准备切换视图")
            //strongself.view.endEditing(true) // Dismiss keyboard safely before transition
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                let navVC = UINavigationController(rootViewController: homeVC)
                
                // Get the foreground active window scene
                guard let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                      let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }
                
                // Add transition animation
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    window.rootViewController = navVC
                })
            }
            
        }
        
        
        
        func signinUser(email: String, password: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                    var errorMessage = "Something went wrong. Please try again later."
                    
                    let errorCode = (error as NSError).code
                    
                    if let authError = AuthErrorCode(rawValue: errorCode) {
                        switch authError {
                        case .invalidEmail:
                            errorMessage = "Invalid email."
                        case .userNotFound:
                            errorMessage = "Email/password does not match any record."
                        default:
                            break
                        }
                    }
                    completion(false, errorMessage)
                    return
                }
               completion(true, nil)
               
             }
          }
    }
    
    
    
    
}


extension SignInViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "chatappcreate" {
            performSegue(withIdentifier: "CreateAccountSegue", sender: nil)
        }
        
        return false
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing  (_ textField: UITextField) {
        activeTextField = nil
    }
    
}
