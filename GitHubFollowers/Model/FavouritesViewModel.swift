//
//  FavouritesViewModel.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 19.07.23.
//

import Foundation
import Observation
import SwiftUI

@Observable
class FavouritesViewModel {
    var favourites: [Follower] = [.init(login: "filippolobisch", avatarUrl: "")]
    
    private let key = "favourites"
    private let defaults = UserDefaults.standard

    func retrieveFavourites() throws {
        guard let favouritesData = defaults.object(forKey: key) as? Data else {
            self.favourites = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            self.favourites = favourites
        } catch {
            throw GFError.unableToFavourite
        }
    }
    
    private func save() -> Bool {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: key)
            return true
        } catch {
            return false
        }
    }
    
    func add(favourite: Follower) -> Bool {
        guard !favourites.contains(favourite) else {
            return false
        }
        
        favourites.append(favourite)
        guard save() else {
            return false
        }
        
        return true
    }
    
    func remove(favourite: Follower) -> Bool {
        favourites.removeAll { $0.login == favourite.login }
        guard save() else {
            return false
        }
        return true
    }
}
