//
//  UsersListViewController.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import UIKit

final class UserListViewController: UITableViewController {
    private var viewModel: UserListViewModelProtocol

    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.statusChangedHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.reactToViewModelChanges()
            }
        }
        viewModel.viewStateUpdated(.didLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewStateUpdated(.willAppear)
    }
    
    private func configureTableView() {
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }

    private func reactToViewModelChanges() {
        switch viewModel.viewModelState {
            case .loading:
                break
            case .loaded:
                presentUserDataSource()
            case .error(let error):
                presentErrorView(with: ErrorViewModel.create(for: error, delegate: self))
        }
    }

    private func presentUserDataSource() {
        tableView.reloadData()
        tableView.backgroundView = nil
    }

    private func presentErrorView(with viewModel: ErrorViewModel) {
        let view: ErrorView = ErrorView(parentView: self.view, viewModel: viewModel)
        view.backgroundColor = .red
        tableView.reloadData()
        tableView.backgroundView = view
    }
}

// MARK: - UITableViewDataSource Delegate

extension UserListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.viewModelState {
            case .loading, .error:
                return 0
            case .loaded:
                guard let numberOfUsers = viewModel.userDataSource?.count else {
                    assertionFailure("Expected valid data source but found nil instead.")
                    return 0
                }
                return numberOfUsers
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserTableViewCell {
        return UserTableViewCell.dequeue(
            from: tableView, viewModel: viewModel.userListCellViewModel(for: indexPath.row), cellDelegate: self)
    }
}

// MARK: - Error view delegate
extension UserListViewController: ErrorViewModelDelegate {
    func retry() {
        viewModel.viewStateUpdated(.errored)
    }
}

// MARK: - User cell delegate
extension UserListViewController: UserTableViewCellDelegate {
    func updateCell(_ cell: UITableViewCell) {
        guard tableView.indexPath(for: cell) != nil else {
            return
        }
        tableView.beginUpdates() // Tried more efficient ways like reloadRows(at:)
        tableView.endUpdates()  // but the cell doesn't get redrawn so constraints don't update.
    }
}
