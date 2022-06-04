//
//  URL+Ext.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 04/06/2022.
//

import UIKit

extension URL {
    
    var qrImage: UIImage? {
        let data = absoluteString.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        let transformScale = CGAffineTransform(scaleX: 5, y: 5)
        
        guard let ciImageOutput = filter.outputImage?.transformed(by: transformScale) else { return nil }
        return UIImage(ciImage: ciImageOutput)
    }
}
