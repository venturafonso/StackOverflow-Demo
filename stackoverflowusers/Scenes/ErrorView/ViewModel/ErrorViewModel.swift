//
//  ErrorViewModel.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

protocol ErrorViewModelDelegate: class { // What methods the delegates of this viewModel have to implement, Output.
    func retry()
}
protocol ErrorViewModelProtocol {
    var title: String { get }
    var body: String { get }
    var buttonTitle: String { get } // What outsiders can call on this protocol, Input.
    func didTapRetry()
}

final class ErrorViewModel: ErrorViewModelProtocol {
    let title: String
    let body: String
    let buttonTitle: String
    weak var delegate: ErrorViewModelDelegate?

    private init(title: String, body: String, actionTitle: String, delegate: ErrorViewModelDelegate) {
        self.title = title
        self.body = body
        self.buttonTitle = actionTitle
        self.delegate = delegate
    }

    func didTapRetry() {
        delegate?.retry()
    }
}

extension ErrorViewModel {
    static func create(for error: Error, delegate: ErrorViewModelDelegate) -> ErrorViewModel {
        let backendServiceError = error as? RequestError
        switch backendServiceError {
            case .offline?:
                return ErrorViewModel(
                    title: "error_offline_title".localized,
                    body: "error_offline_body".localized,
                    actionTitle: "error_offline_action".localized,
                    delegate: delegate)
            default:
                return ErrorViewModel(
                    title: "error_generic_title".localized,
                    body: "error_generic_body".localized,
                    actionTitle: "error_generic_action".localized,
                    delegate: delegate)
        }
    }
}
