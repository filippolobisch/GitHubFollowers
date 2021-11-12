//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 06/10/2021.
//

import UIKit
import SafariServices

extension UIViewController {
    func presentSafariViewController(withUrl url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true, completion: nil)
    }
    
    func presentUIAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentUIAlert(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func presentDefaultError() {
        let alertController = UIAlertController(title: "Something wrong happened", message: "We were unable to complete your request at this time. Please try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
