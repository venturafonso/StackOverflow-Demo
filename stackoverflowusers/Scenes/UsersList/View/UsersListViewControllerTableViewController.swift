//
//  UsersListViewController.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import UIKit

class UserListViewController: UITableViewController {
    private var viewModel: UserListViewModelProtocol
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
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
        viewModel.viewStateUpdated(.loaded)
    }
    
    private func reactToViewModelChanges() {
        switch viewModel.state {
            case .loading:
                break
            case .loaded:
                tableView.reloadData()
            case .error:
                //show error
                break
        }
    }
    
    // MARK: - TableView data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userDataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UserTableViewCell.dequeue(
            from: tableView, viewModel: viewModel.userListCellViewModel(for: indexPath.row))
        
    }
}
