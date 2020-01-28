//
//  ErrorView.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import UIKit

class ErrorView: UIView {

    // MARK: - Views

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Properties

    private var viewModel: ErrorViewModelProtocol?

    public convenience init(parentView: UIView, viewModel: ErrorViewModel) {
        let receivedFrame = parentView.bounds
        self.init(frame: receivedFrame)
        self.viewModel = viewModel
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
//        setupTitleLabel()
//        setupBodyLabel()
//        setupRetryButton()
        setupStackView()
    }

    private func setupStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(retryButton)
        addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func setup() {
        titleLabel.text = viewModel?.title
        bodyLabel.text = viewModel?.body
        retryButton.setTitle(viewModel?.buttonTitle, for: .normal)
    }

    @objc private func retryButtonTapped() {
        viewModel?.didTapRetry()
    }

//    private func setupTitleLabel() {
//        addSubview(titleLabel)
//        UILayoutGuide()
//        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
//                                            constant: ConstraintValues.titleLabel.centerYMultiplier).isActive = true
//    }
//
//    private func setupBodyLabel() {
//        addSubview(bodyLabel)
//        bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        bodyLabel.centerYAnchor.constraint(equalTo: centerYAnchor,
//                                           constant: ConstraintValues.bodyLabel.centerYMultiplier).isActive = true
//    }
//
//    private func setupRetryButton() {
//        addSubview(retryButton)
//        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        retryButton.centerYAnchor.constraint(equalTo: centerYAnchor,
//                                             constant: ConstraintValues.retryButton.centerYMultiplier).isActive = true
//    }
}
extension ErrorView {
    struct ConstraintValues {
        struct titleLabel {
            static let centerYMultiplier: CGFloat = 0.8
        }
        struct bodyLabel {
            static let centerYMultiplier: CGFloat = 0.5
        }
        struct retryButton {
            static let centerYMultiplier: CGFloat = 0.2
        }
    }
}
