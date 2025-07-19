//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by mac on 7/20/25.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var usernameLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avtarImageView.image = UIImage(systemName: "person.fill")
        avtarImageView.tintColor = UIColor.black
        avtarImageView.backgroundColor = UIColor.lightGray
        
        presentAvtarOptionsTapGestureRecognizer()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.layer.cornerRadius = 8
        avtarImageView.layer.cornerRadius = avtarImageView.frame.width / 2
        
       
    }
    
    func presentAvtarOptionsTapGestureRecognizer() {
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(presentAvtarOptions))
        avtarImageView.isUserInteractionEnabled = true
        avtarImageView.addGestureRecognizer(avatarTap)
    }
    
    func logout() {
        do {
            
            try Auth.auth().signOut()
            
            let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let signinVC = authStoryboard.instantiateViewController(withIdentifier: "SignInViewController")
            
            let window = UIApplication.shared.connectedScenes
                .flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
            
            window?.rootViewController = signinVC
    
        } catch {
            
            presentErrorAlert(title: "Logout Failed",
                              message: "Something went wrong with logout. Please try again later.")
            
        }
    }
    
    @objc func presentAvtarOptions() {
        
        let avtarOptionsSheet = UIAlertController(title: "Change Avatar",
                                                  message: "Select an option.",
                                                  preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
        }
        
        let photoAction  = UIAlertAction(title: "Photo",  style: .default) { _ in
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        avtarOptionsSheet.addAction(cameraAction)
        avtarOptionsSheet.addAction(photoAction)
        avtarOptionsSheet.addAction(deleteAction)
        avtarOptionsSheet.addAction(cancelAction)
        
        present(avtarOptionsSheet, animated: true)
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
      let logoutAlert = UIAlertController(title: "Are you sure?",
                                          message: "You’ll be logged out.",
                                          preferredStyle: .alert)
      
      let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
          self.logout()
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      logoutAlert.addAction(logoutAction)
      logoutAlert.addAction(cancelAction)
      
      present(logoutAlert, animated: true)
  
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
