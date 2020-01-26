//
//  UserTableViewCell.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//
import UIKit

public class UserTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    lazy var iconImageView = UIImageView(frame: CGRect.init(x: 50, y: 10, width: 50, height: 50))
    lazy var reputationLabel = UILabel(frame: CGRect.init(x: 10, y: 10, width: 50, height: 20))
    lazy var nameLabel = UILabel(frame: CGRect.init(x: 50, y: 30, width: 200, height: 20))
    static let identifier = "user.cell"
    private var viewModel: UserTableViewCellViewModelProtocol?
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: UserTableViewCell.identifier)
        
        setupInitialLayout()
    }
    
    func setup(with viewModel: UserTableViewCellViewModelProtocol) {
        self.viewModel = viewModel
        reputationLabel.text = viewModel.reputation
        nameLabel.text = viewModel.name
        loadImageFromData()
    }
    private func setupImage(with data: Data) {
        print("SETUP IMAGE")
        DispatchQueue.main.async {
            self.iconImageView.image = UIImage(data: data)


        }
    }
    
    private func loadImageFromData() {
        viewModel?.loadImage { [weak self] result in
            switch result {
                case .success(let imageData):
                    self?.setupImage(with: imageData)
                case .failure(let error):
                    print("failed to download image with \(error), set a dummy view!")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        addSubview(iconImageView)
        addSubview(reputationLabel)
        addSubview(nameLabel)
    }
    
//    override public func prepareForReuse() {
//        self.iconImageView.image = nil
//        self.nameLabel.text = nil
//        self.reputationLabel.text = nil
//    }
}

extension UserTableViewCell {
    static func dequeue(from tableView: UITableView, viewModel: UserTableViewCellViewModelProtocol) -> UserTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UserTableViewCell else {
            assertionFailure("failed to dequeue reusable cell for table view")
            return UserTableViewCell()
        }
        
        cell.setup(with: viewModel)
        return cell
    }
}

//private extension UserTableViewCell {
//    struct Constants {
//        struct Separator {
//            static let height: CGFloat = 1
//        }
//
//        struct ImageView {
//            static let cornerRadius: CGFloat = 2
//        }
//
//        struct DisclosureIndicator {
//            static let trailingMargin: CGFloat = 17
//            static let leadingMargin: CGFloat = 10
//        }
//    }
//}
