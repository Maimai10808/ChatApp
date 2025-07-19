//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Gwinyai Nyatsoka on 21/7/2023.
//

import UIKit
import FirebaseAuth
import Foundation

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
}
