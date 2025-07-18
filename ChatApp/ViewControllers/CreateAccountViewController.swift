//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
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
