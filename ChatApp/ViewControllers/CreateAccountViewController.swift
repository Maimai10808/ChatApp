//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField?
    
    
    override func viewWillAppear(_ animated: Bool) {
                  super.viewWillAppear(animated)
        registerKeyboardNotifications()
       }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField   .delegate = self
        passwordTextField.delegate = self
        
        drawcontainerView()
        drawcreateAccountTextView()
        
        tapRecognizerDismissKeyBoard()
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
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func drawcreateAccountTextView() {
        let attributedString = NSMutableAttributedString(
            string    : "Alreay have an account? Sign in here.",
            attributes: [NSAttributedString.Key.font : Font.linkLabel])
        
        attributedString.addAttribute(
            .link,
            value: "chatsignin://signinAccount",
            range: (attributedString.string as NSString).range(of: "Sign in here"))
        
        signinAccountTextView.attributedText     = attributedString
        signinAccountTextView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
        signinAccountTextView.delegate           = self
        signinAccountTextView.isScrollEnabled    = false
        signinAccountTextView.textAlignment      = .center
        signinAccountTextView.isEditable         = false
    }

    
    
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text else {
            presentErrorAlert(title  : "Username Required",
                              message: "Please enter a username to continue.")
            return
        }
        
        guard username.count >= 1 && username.count <= 15 else {
            presentErrorAlert(title: "Invalid Username", message: "Username must be 1–15 characters long.")
            return
        }
        
        guard let email    = emailTextField   .text else{
            presentErrorAlert(title  : "Email Required",
                              message: "Please enter a Email to continue.")
            return
        }
        
        guard let password = passwordTextField.text else {
            presentErrorAlert(title  : "Password Required",
                              message: "Please enter a Password to continue.")
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
                self.presentErrorAlert(title  : "Create Account Failed",
                                       message: "Something went wrong. Please try again later.")
                return
            }
            
            guard let result = result else {
                self.presentErrorAlert(title  : "Create Account Failed",
                                       message: "Something went wrong. Please try again later.")
                return
            }
            
            let userId = result.user.uid
            let userData: [String: Any] = [
                "id": userId,
                "username": username
            ]
            
            Database.database().reference().child("users").child(userId).setValue(userData)
            
            // child(userId) make sure every users is unique the following users can't cover the later users
            
        }
        
        
        
        
    }
}

extension CreateAccountViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "chatsignin" {
            performSegue(withIdentifier: "SignInSegue", sender: nil)
        }
        
        return false
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing  (_ textField: UITextField) {
        activeTextField = nil
    }
    
}


