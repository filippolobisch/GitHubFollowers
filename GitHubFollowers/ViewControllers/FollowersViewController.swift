//
//  FollowersViewController.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 03/10/2021.
//

import UIKit

class FollowersViewController: GFDataLoadingViewController {
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Follower>!
    
    var username: String
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isLoadingMoreFollowers = false
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = username
    }
    
    func configureNavigationBar() {
        let profileAction = UIAction(title: "View Profile", image: SFSymbols.personCircleFill) { [weak self] action in
            guard let self = self else { return }
            self.didSelectProfileOption()
        }
        
        let addAction = UIAction(title: "Favourite User", image: SFSymbols.personFillBadgePlus) { [weak self] action in
            guard let self = self else { return }
            self.didSelectFavouriteOption()
        }
        
        let menu = UIMenu(title: "", image: nil, options: .displayInline, children: [addAction, profileAction])
        let barButton = UIBarButtonItem(title: nil, image: SFSymbols.ellipsisCircleFill, menu: menu)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                dismissLoadingView()
                updateUI(with: followers)
            } catch {
                dismissLoadingView()
                if let error = error as? GFError {
                    presentUIAlert(title: "Something wrong happened", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
            }
        }
        
        isLoadingMoreFollowers = false
    }
    
    func didSelectProfileOption() {
        let userInfoViewController = UserInfoViewController(username: username, delegate: self)
        let destinationNavigationController = UINavigationController(rootViewController: userInfoViewController)
        present(destinationNavigationController, animated: true, completion: nil)
    }
    
    func didSelectFavouriteOption() {
        showLoadingView()
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                dismissLoadingView()
                addUserToFavourites(user: user)
            } catch {
                dismissLoadingView()
                if let error = error as? GFError {
                    presentUIAlert(title: "Something wrong happened", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func addUserToFavourites(user: User) {
        let favourite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        Task {
            let error = await PersistenceManager.update(favourite: favourite, withPersistenceAction: .add)
            guard let error = error else {
                presentUIAlert(title: "Success", message: "You have successfully favourites this user.", buttonTitle: "OK")
                return
            }
            
            presentUIAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
        }
    }
}

extension FollowersViewController: UISearchResultsUpdating {
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let textWithoutLeadingWhitespaces = text.trimmingCharacters(in: .whitespaces)
        guard !textWithoutLeadingWhitespaces.isEmpty else {
            applySnapshot(for: followers)
            return
        }
        
        let filteredFollowers = followers.filter { $0.login.lowercased().contains(textWithoutLeadingWhitespaces.lowercased()) }
        applySnapshot(for: filteredFollowers)
    }
}

extension FollowersViewController: UICollectionViewDelegate {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        let userInfoViewController = UserInfoViewController(username: follower.login, delegate: self)
        let destinationNavigationController = UINavigationController(rootViewController: userInfoViewController)
        present(destinationNavigationController, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowersViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Follower>(collectionView: collectionView) { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as? FollowerCell else {
                fatalError("Could not dequeue cell of type \(FollowerCell.self) at \(indexPath).")
            }
            cell.set(follower: follower)
            return cell
        }
    }
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 {
            self.hasMoreFollowers = false
        }
        
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "This user doesn't have any followers. Go follow them.")
            }
        } else {
            DispatchQueue.main.async {
                repeat {
                    guard let view = self.view.subviews.last as? GFEmptyStateView else { return }
                    view.removeFromSuperview()
                } while self.view.subviews.last is GFEmptyStateView
            }
        }
        
        self.applySnapshot(for: self.followers)
    }
    
    func applySnapshot(for followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Follower>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FollowersViewController: UserInfoViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
