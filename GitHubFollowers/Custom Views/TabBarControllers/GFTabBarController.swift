//
//  GFTabBarController.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 10/11/2021.
//

import UIKit

class GFTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(), createFavouritesNavigationController()]
    }
    
    func createSearchNavigationController() -> UINavigationController {
        let searchViewController = SearchViewController()
        searchViewController.title = "Search"
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        return UINavigationController(rootViewController: searchViewController)
    }
    
    func createFavouritesNavigationController() -> UINavigationController {
        let favouritesViewController = FavouritesViewController()
        favouritesViewController.title = "Favourites"
        favouritesViewController.tabBarItem.image = UIImage(systemName: "heart.circle.fill")
        
        return UINavigationController(rootViewController: favouritesViewController)
    }
}
