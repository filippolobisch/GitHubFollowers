//
//  UserInfoViewControllerDelegate.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 01/11/2021.
//

import Foundation

protocol UserInfoViewControllerDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}
