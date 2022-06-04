//
//  UIAlertController+Ext.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 04/06/2022.
//

import UIKit

extension UIAlertController {
    /// Method to create an UIAlertController with an image. Inpired by Christian Selig's implementation in Amplosion.
    static func createAlertControllerWithImage(_ image: UIImage, title: String, message: String? = nil) -> UIAlertController {
        let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        let qrCodeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        qrCodeImageView.image = image
        let measuringAttributedStringHeight = NSAttributedString(string: "Penguin", attributes: [.font: titleFont]).boundingRect(with: .zero, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).height
        let desiredOffset = 15.0 + qrCodeImageView.bounds.height
        let totalNewlinePrefixes = Int((desiredOffset / measuringAttributedStringHeight).rounded())
        
        let newlinePrefixes = [String](repeating: "\n", count: totalNewlinePrefixes).joined()
        let alertTitle = "\(newlinePrefixes) \(title)"
        
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        
        let yOffset = 20.0
        qrCodeImageView.frame.origin = CGPoint(x: (alertController.view.bounds.width - qrCodeImageView.bounds.width) / 2.0, y: yOffset)
        qrCodeImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        qrCodeImageView.tintColor = .secondaryLabel
        alertController.view.addSubview(qrCodeImageView)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
}
