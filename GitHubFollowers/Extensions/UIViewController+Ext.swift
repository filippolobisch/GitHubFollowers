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
        
        DispatchQueue.main.async {
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func presentUIAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
