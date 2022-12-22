//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Filippo Lobisch on 20/10/2021.
//

import UIKit

class UserInfoViewController: UIViewController {
    enum UserInfoItemType {
        case header
        case profile
        case followers
    }
    
    class UserInfoTableViewDiffableDataSource: UITableViewDiffableDataSource<Int, UserInfoItemType> {
        var title: String?
        
        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            guard section == 0 else { return nil }
            return title
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UserInfoTableViewDiffableDataSource!
    
    let username: String
    var user: User! {
        didSet {
            dataSource.title = "GitHub user since \(user.createdAt.convertToMonthYearFormat())"
        }
    }
    
    weak var delegate: UserInfoViewControllerDelegate?
    
    init(username: String, delegate: UserInfoViewControllerDelegate?) {
        self.username = username
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureDataSource()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = username
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                self.user = user
                applySnapshot()
            } catch {
                if let error = error as? GFError {
                    presentUIAlert(title: "Something wrong happened", message: error.rawValue, buttonTitle: "OK")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    @objc private func actionButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func configureTableView() {
        tableView.frame = view.bounds
        tableView.backgroundColor = .systemBackground
        tableView.alwaysBounceVertical = true
        tableView.register(UserInfoHeaderCell.self, forCellReuseIdentifier: UserInfoHeaderCell.reuseIdentifier)
        tableView.register(GFProfileItemCell.self, forCellReuseIdentifier: GFProfileItemCell.reuseIdentifier)
        tableView.register(GFFollowersItemCell.self, forCellReuseIdentifier: GFFollowersItemCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserInfoViewController {
    func configureDataSource() {
        dataSource = UserInfoTableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, cellType in
            guard let self = self else { fatalError("Unable to unwrap self.") }
            
            switch cellType {
            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoHeaderCell.reuseIdentifier, for: indexPath) as? UserInfoHeaderCell else {
                    fatalError("Unable to dequeue cell of type \(UserInfoHeaderCell.self) at \(indexPath)")
                }
                cell.set(for: self.user)
                return cell
            case .profile:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GFProfileItemCell.reuseIdentifier, for: indexPath) as? GFProfileItemCell else {
                    fatalError("Unable to dequeue cell of type \(GFProfileItemCell.self) at \(indexPath)")
                }
                cell.set(for: self.user, delegate: self)
                cell.delegate = self
                return cell
            case .followers:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: GFFollowersItemCell.reuseIdentifier, for: indexPath) as? GFFollowersItemCell else {
                    fatalError("Unable to dequeue cell of type \(GFFollowersItemCell.self) at \(indexPath)")
                }
                cell.set(for: self.user, delegate: self)
                return cell
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserInfoItemType>()
        snapshot.appendSections([0, 1, 2])
        snapshot.appendItems([.header], toSection: 0)
        snapshot.appendItems([.profile], toSection: 1)
        snapshot.appendItems([.followers], toSection: 2)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension UserInfoViewController: GFRepoItemViewControllerDelegate {
    func didTapGitHubProfile() {
        guard let url = URL(string: user.htmlUrl) else {
            presentUIAlert(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        
        presentSafariViewController(withUrl: url)
    }
}

extension UserInfoViewController: GFFollowerItemViewControllerDelegate {
    func didTapGetFollowers() {
        guard user.followers != 0 else {
            presentUIAlert(title: "No Followers", message: "This user has no followers.", buttonTitle: "OK")
            return
        }
        
        delegate?.didRequestFollowers(for: user.login)
        dismiss(animated: true, completion: nil)
    }
}
