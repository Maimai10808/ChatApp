//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds       = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
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
