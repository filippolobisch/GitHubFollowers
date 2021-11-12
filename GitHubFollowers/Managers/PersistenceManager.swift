//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 01/11/2021.
//

import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    enum PersistenceActionType {
        case add
        case remove
    }
    
    static func retrieveFavourites() async throws -> [Follower] {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Follower].self, from: favouritesData)
        } catch {
            throw GFError.unableToFavourite
        }
    }
    
    static func save(favourites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
    
    static func update(favourite: Follower, withPersistenceAction actionType: PersistenceActionType) async -> GFError? {
        do {
            var favourites = try await retrieveFavourites()
            switch actionType {
            case .add:
                guard !favourites.contains(favourite) else { return GFError.alreadyFavourited }
                favourites.append(favourite)
            case .remove:
                favourites.removeAll { $0.login == favourite.login }
            }
            
            return save(favourites: favourites)
        } catch {
            return error as? GFError
        }
    }
}
