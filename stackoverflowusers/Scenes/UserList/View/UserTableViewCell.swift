//
//  UserTableViewCell.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//
import UIKit

protocol Expandable {
    var expanded: Bool { get set }
    func expand()
    func collapse()
}

protocol UserTableViewCellDelegate: class {
    func updateCell(_ cell: UITableViewCell)
}

final class UserTableViewCell: UITableViewCell {

    // MARK: - Views & Stored Properties

    lazy var socialFeatureStackViewBottomConstraint: NSLayoutConstraint = {
        socialFeatureStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    }()

    lazy var cellTapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(didTapCell))
    }()
    // MARK: - Collapsed view elements

    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var followIndicatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .green
        label.text = "Following"
        return label
    }()

    lazy var reputationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var collapsedConstraint: NSLayoutConstraint = {
        avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    }() //activate and deactivate this

    lazy var expandedConstraint: NSLayoutConstraint = {
        avatarImageView.bottomAnchor.constraint(equalTo: socialFeatureStackView.topAnchor)
    }()

    // MARK: - Expanded view elements

    lazy var dummySizingView: UIView = { // Separator between the collapsible section and the non collapsible. If we don't want items to scale with
        let dummyView = UIView(frame: .zero) //the cell expansion we constrain them to this view.
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        return dummyView
    }()

    lazy var socialFeatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var blockButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = blockButtonConfiguration.backgroundColor
        button.setTitle(blockButtonConfiguration.buttonTitleText.localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    static let cellIdentifier = "user.cell"
    weak var delegate: UserTableViewCellDelegate?
    var expanded: Bool = false
    private var viewModel: UserTableViewCellViewModelProtocol!

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: UserTableViewCell.cellIdentifier)
        addSubviews()
        addGestureRecognizer(cellTapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    func setup(with viewModel: UserTableViewCellViewModelProtocol, delegate: UserTableViewCellDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.clipsToBounds = true
        reputationLabel.text = viewModel.reputation
        nameLabel.text = viewModel.name
        setupBlockUI(with: viewModel.blocked)
        setupFollowUI(with: viewModel.followed)
        loadImageFromData()
    }

    private func setupImage(with data: Data) {
        DispatchQueue.main.async {
            self.avatarImageView.image = UIImage(data: data)
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
    
    // MARK: - Dequeuing / Initialization
    
    override public func prepareForReuse() {
        self.avatarImageView.image = nil
        self.nameLabel.text = nil
        self.reputationLabel.text = nil
        setupFollowUI(with: viewModel.followed)
        setupBlockUI(with: viewModel.blocked)
        collapse()
    }
    
    static func dequeue(from tableView: UITableView, viewModel: UserTableViewCellViewModelProtocol, cellDelegate: UserTableViewCellDelegate) -> UserTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserTableViewCell else {
            assertionFailure("failed to dequeue reusable cell for table view")
            return UserTableViewCell()
        }
        cell.setup(with: viewModel, delegate: cellDelegate)
        return cell
    }
    
    //MARK: Button Selectors
    
    @objc private func didTapCell() {
        guard !viewModel.blocked else {
            return
        }
        expanded ? collapse() : expand()
    }
    
    @objc private func followButtonTapped() {
        viewModel.didTapButton(action: .follow)
        updateViewState(for: .follow)
    }
    
    @objc private func blockButtonTapped() {
        viewModel.didTapButton(action: .block)
        updateViewState(for: .block)
    }
    
    // MARK: Follow / Block state managament
    
    private func updateViewState(for action: UserTableViewCellAction) {
        switch action {
            case .follow:
                updateFollowUI(with: viewModel.followed)
            case .block:
                setupBlockUI(with: viewModel.blocked)
        }
    }
    
    private func updateFollowUI(with followingState: Bool) {
        setupFollowUI(with: followingState)              // If we had a follow button sub class for reusability, this method would go in there
        if followingState {                              // along with its configuration, like FollowButton().setStyle(.unfollow)
            followButton.backgroundColor = followButtonConfiguration.unfollow.backgroundColor
            followButton.setTitle(followButtonConfiguration.unfollow.buttonTitleText, for: .normal)
        } else {
            followButton.backgroundColor = followButtonConfiguration.follow.backgroundColor
            followButton.setTitle(followButtonConfiguration.follow.buttonTitleText, for: .normal)
        }
    }
}

// MARK: Constraint setup boilerplate

extension UserTableViewCell {
    private func addSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(reputationLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dummySizingView)
        setupAvatarImageView()
        setupReputationLabel()
        setupNameLabel()
        setupStackView()
    }

    private func setupBlockUI(with blockedState: Bool) {
        blockedState ? enableBlockedState() : disableBlockedState()
    }

    private func enableBlockedState() {
        setupFollowUI(with: false)
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = .gray // No need for weak self, we want to keep the reference alive for the duration of the animation.
        }
        contentView.isUserInteractionEnabled = false
        collapse()
    }

    private func disableBlockedState() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.backgroundColor = .white // No need for weak self, we want to keep the reference alive for the duration of the animation.
        }
        contentView.isUserInteractionEnabled = true
    }

    private func setupFollowUI(with followingState: Bool) {
        if followingState {
            contentView.addSubview(followIndicatorLabel)
            setupFollowIndicatorLabel()
            followButton.backgroundColor = followButtonConfiguration.unfollow.backgroundColor
            followButton.setTitle(followButtonConfiguration.unfollow.buttonTitleText, for: .normal)
        } else {
            followIndicatorLabel.removeFromSuperview()
            followButton.backgroundColor = followButtonConfiguration.follow.backgroundColor
            followButton.setTitle(followButtonConfiguration.follow.buttonTitleText, for: .normal)
        }
    }

    private func setupAvatarImageView() {
        avatarImageView.bottomAnchor.constraint(equalTo: dummySizingView.topAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: ConstraintValues.avatarImageView.collapsedHeightConstraintValue).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                               multiplier: ConstraintValues.avatarImageView.widthMultiplierValue).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        dummySizingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dummySizingView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor).isActive = true
        dummySizingView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        dummySizingView.rightAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true    // Avoid layout ambiguity warning
    }

    private func setupReputationLabel() {
        reputationLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor,
                                                constant: ConstraintValues.reputationLabel.bottomConstraintValue).isActive = true
        reputationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                               constant: ConstraintValues.reputationLabel.trailingConstraintValue).isActive = true
        reputationLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor,
                                              constant: ConstraintValues.reputationLabel.leadingConstraintValue).isActive = true
    }

    private func setupNameLabel() {
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: ConstraintValues.nameLabel.topConstraintValue).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                         constant: ConstraintValues.nameLabel.trailingConstraintValue).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor,
                                        constant: ConstraintValues.nameLabel.leadingConstraintValue).isActive = true
    }

    private func setupStackView() {
        socialFeatureStackView.addArrangedSubview(followButton)
        socialFeatureStackView.addArrangedSubview(blockButton)
        contentView.addSubview(socialFeatureStackView)

        socialFeatureStackView.topAnchor.constraint(equalTo:  dummySizingView.topAnchor,
                                                    constant: ConstraintValues.socialFeatureStackView.topAnchorConstant).isActive = true
        socialFeatureStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    private func setupFollowIndicatorLabel() {
        followIndicatorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        followIndicatorLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        followIndicatorLabel.bottomAnchor.constraint(equalTo: dummySizingView.topAnchor).isActive = true
    }
}

// MARK: - Expandable Implementation

extension UserTableViewCell: Expandable {
    func expand() {
        socialFeatureStackViewBottomConstraint.isActive = true
        expanded = true
        delegate?.updateCell(self)
    }

    func collapse() {
        socialFeatureStackViewBottomConstraint.isActive = false
        expanded = false
        delegate?.updateCell(self)
    }
}

// MARK: - Constants

extension UserTableViewCell {
    private struct ConstraintValues {
        struct avatarImageView {
            static let collapsedHeightConstraintValue: CGFloat = 55
            static let expandedHeightConstraintValue: CGFloat = 85
            static let widthMultiplierValue: CGFloat = 0.2
        }
        struct reputationLabel {
            static let leadingConstraintValue: CGFloat = 10
            static let trailingConstraintValue: CGFloat = 3
            static let bottomConstraintValue: CGFloat = -3
        }
        struct nameLabel {
            static let leadingConstraintValue: CGFloat = 10
            static let trailingConstraintValue: CGFloat = 3
            static let topConstraintValue: CGFloat = 3
        }
        struct socialFeatureStackView {
            static let topAnchorConstant: CGFloat = 0.5
        }
    }

    private struct ViewStringKeys {
        static let followButtonText = "button_following_false".localized
        static let unfollowButtonText = "button_following_true".localized
        static let blockButtonText = "button_blocked".localized
    }

    private struct blockButtonConfiguration {
        static let backgroundColor: UIColor = .red
        static let buttonTitleText: String = ViewStringKeys.blockButtonText
    }
    private struct followButtonConfiguration {
        struct follow {
            static let backgroundColor: UIColor = .green
            static let buttonTitleText: String = ViewStringKeys.followButtonText
        }
        struct unfollow {
            static let backgroundColor: UIColor = .gray
            static let buttonTitleText: String = ViewStringKeys.unfollowButtonText
        }

    }
}
