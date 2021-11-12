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
    
    static func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavourite))
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
    
    static func update(favourite: Follower, withPersistenceAction actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completion(.alreadyFavourited)
                        return
                    }
                    
                    favourites.append(favourite)
                case .remove:
                    favourites.removeAll { $0.login == favourite.login}
                }
                
                completion(save(favourites: favourites))
            case .failure(let error):
                completion(error)
            }
        }
    }
}
