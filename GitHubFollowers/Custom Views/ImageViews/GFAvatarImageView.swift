//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 15/10/2021.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }
    
    func downloadImage(fromUrl url: String) {
        Task {
            image = await NetworkManager.shared.downloadImage(from: url) ?? placeholderImage
        }
    }
}
