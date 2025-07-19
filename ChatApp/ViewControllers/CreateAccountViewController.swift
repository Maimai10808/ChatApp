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
    
    @IBOutlet weak var usernameTextField    : UITextField!
    @IBOutlet weak var emailTextField       : UITextField!
    @IBOutlet weak var passwordTextField    : UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView        : UIView!
    @IBOutlet weak var contentView          : UIView!
    @IBOutlet weak var scrollView           : UIScrollView!
    
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
        
        Database.database().reference().child("username").child(username)
            .observeSingleEvent(of: .value) { snapshot in
                guard !snapshot.exists() else {
                    self.presentErrorAlert(title  : "Usename In Use",
                                            message: "Please enter a different name to continue.")
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
                    
                    Database.database().reference()
                        .child("users")
                        .child(userId)
                        .setValue(userData)
                    
                    Database.database().reference()
                        .child("usernames")
                        .child(username)
                        .setValue(userData)
                    
                    // child(userId) make sure every users is unique the following users can't cover the later users
                
        }
        
        
        
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
            let navVC = UINavigationController(rootViewController: homeVC)
            /*
             
             ❓ Why use UINavigationController(rootViewController: homeVC)?

             To give homeVC a navigation bar, enable a navigation stack (push/pop), and support more complex page transitions.

             ⸻

             ❓ What happens if you don’t use a navigation controller?

             The page will still display correctly, but there will be no navigation bar, and you won’t be able to push new view controllers — only present them modally.

             ⸻

             ❓ Why is the page shown still homeVC?

             Because it is the root view controller of the navigation controller — the first screen in the navigation stack.
             
             
             为什么用 UINavigationController(rootViewController: homeVC)？
             
             为了让 homeVC 拥有导航栏，支持页面堆栈结构（push/pop），实现更复杂的页面跳转。
             
             如果不加导航控制器，会怎么样？
             
             页面显示正常，但没有导航栏，无法用 push 跳转，只能模态弹出（present）。
             
             实际显示的页面为什么还是 homeVC？
             
             因为它是导航控制器的“第一个页面”，就是 rootViewController。
             
             */
            
            
            let window = UIApplication.shared.connectedScenes
                .flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            
            /*
             
             •    Retrieve all scenes from UIApplication.shared.connectedScenes (iOS multi-window architecture);
             •    Use flatMap to extract all windows from each scene;
             •    Use .first { $0.isKeyWindow } to get the currently active (visible) window.
             
             1. .flatMap { ... }
                 •    A higher-order function in Swift used to flatten nested collections;
                 •    You can think of it as map + flatten;
                 •    In this context, its purpose is:
             To extract all UIWindow instances from multiple scenes and flatten them into a single [UIWindow] array.

             ⸻

             2. $0 as? UIWindowScene
                 •    $0 refers to each UIScene passed into the closure;
                 •    Since connectedScenes is a collection of [UIScene], and we’re only interested in UIWindowScene,
                 •    We use optional casting as? to attempt converting it to UIWindowScene;
                 •    If it’s not a UIWindowScene, the result is nil.

             ⸻

             3. ?.windows ?? []
                 •    .windows is a property provided by UIWindowScene, returning [UIWindow];
                 •    If the previous optional casting fails (i.e., not a UIWindowScene), it results in nil, and we use ?? [] to default to an empty array to prevent crashing;
                 •    Therefore, the final return value is always of type [UIWindow].
             
             
             •    从 UIApplication.shared.connectedScenes 获取所有 Scene（iOS 多窗口机制）；
             •    用 flatMap 提取所有窗口（window）；
             •    再 .first { $0.isKeyWindow } 拿到当前正在显示的活跃窗口。
             
             1. .flatMap { ... }
                 •    是 Swift 的高阶函数，用于展开（flatten）嵌套的集合；
                 •    你可以把它看作 map + flatten；
                 •    这里它的作用是：
             从多个 scene 中“提取出”所有的 UIWindow，组成一个扁平化的一维数组 [UIWindow]。

             ⸻

             2. $0 as? UIWindowScene
                 •    $0 是闭包中传入的每一个 UIScene；
                 •    因为 connectedScenes 是 [UIScene]，而我们只对 UIWindowScene 感兴趣；
                 •    所以这里用可选类型 as? 来尝试转换为 UIWindowScene；
                 •    如果不是 UIWindowScene，就返回 nil。

             ⸻

             3. ?.windows ?? []
                 •    .windows 是 UIWindowScene 提供的属性，返回 [UIWindow]；
                 •    如果上一步类型转换失败（不是 UIWindowScene），就取 nil，然后返回 [] 空数组，避免崩溃；
                 •    所以最终的返回值永远是 [UIWindow] 类型。
             */
            
            window?.rootViewController = navVC
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


