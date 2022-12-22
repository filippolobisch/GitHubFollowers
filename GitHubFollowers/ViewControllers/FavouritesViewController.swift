//
//  FavouritesViewController.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 30/09/2021.
//

import UIKit

class FavouritesViewController: GFDataLoadingViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    var dataSource: UITableViewDiffableDataSource<Int, Follower>!
    
    var favourites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureDataSource()
        getFavourites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFavourites() {
        Task {
            do {
                let favourites = try await PersistenceManager.retrieveFavourites()
                updateUI(for: favourites)
            } catch {
                if let error = error as? GFError {
                    presentUIAlert(title: "Something wrong happened", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func configureTableView() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let favourite = dataSource.itemIdentifier(for: indexPath) else { return }
        let destinationViewController = FollowersViewController(username: favourite.login)
        show(destinationViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] contextAction, view, completion in
            guard let self else { return }
            guard let favourite = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            Task {
                let error = await PersistenceManager.update(favourite: favourite, withPersistenceAction: .remove)
                guard let error else {
                    self.favourites.removeAll { $0.login == favourite.login }
                    self.updateUI(for: self.favourites)
                    return
                }
                
                self.presentUIAlert(title: "Unable to delete User.", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavouritesViewController {
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Follower>(tableView: tableView) { tableView, indexPath, favourite in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseIdentifier, for: indexPath) as? FavouriteCell else {
                fatalError("Unable to dequeue cell of type \(FavouriteCell.self) at \(indexPath)")
            }
            cell.set(favourite: favourite)
            return cell
        }
    }
    
    func updateUI(for favourites: [Follower]) {
        self.favourites = favourites
        
        if favourites.isEmpty {
            showEmptyStateView(with: "No Favourites.")
        } else {
            DispatchQueue.main.async {
                repeat {
                    guard let view = self.view.subviews.last as? GFEmptyStateView else { return }
                    view.removeFromSuperview()
                } while self.view.subviews.last is GFEmptyStateView
            }
        }
        
        applySnapshot(for: favourites)
    }
    
    func applySnapshot(for favourites: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Follower>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(favourites)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
