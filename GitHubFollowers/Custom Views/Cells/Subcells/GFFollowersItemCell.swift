//
//  GFFollowersItemCell.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 28/10/2021.
//

import UIKit

class GFFollowersItemCell: GFItemInfoCell {
    static var reuseIdentifier = "gfFollowersItemCell"
    weak var delegate: GFFollowerItemViewControllerDelegate?
    
    func set(for user: User, delegate: GFFollowerItemViewControllerDelegate?) {
        itemInfoViewOne.set(itemInfoType: .followers, with: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, with: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3.fill")
        
        self.delegate = delegate
    }
    
    override func didTapActionButton() {
        delegate?.didTapGetFollowers()
    }
}
