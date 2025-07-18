//
//  Extension+UIViewController.swift
//  ChatApp
//
//  Created by mac on 7/18/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loadingView.tag   = 20250719
    }
    
    func removeLoadingView() {
        if let loadingView = view.viewWithTag(20250719) {
            loadingView.removeFromSuperview()
        }
    }
    
}

