//
//  GFProfileItemCell.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 28/10/2021.
//

import UIKit

class GFProfileItemCell: GFItemInfoCell {
    static var reuseIdentifier = "gfProfileItemCell"
    weak var delegate: GFRepoItemViewControllerDelegate?
    
    func set(for user: User, delegate: GFRepoItemViewControllerDelegate?) {
        itemInfoViewOne.set(itemInfoType: .repos, with: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, with: user.publicGists)
        actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person.circle.fill")
        
        self.delegate = delegate
    }
    
    override func didTapActionButton() {
        delegate?.didTapGitHubProfile()
    }
}
