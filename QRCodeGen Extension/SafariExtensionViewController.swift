// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import SafariServices
import SwiftUI
import Combine

class SafariExtensionViewController: SFSafariExtensionViewController {
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        return shared
    }()

    var url: URL? {
        didSet {
            viewModel.setURL(url)
        }
    }
    var pageTitle: String? {
        didSet {
            self.viewModel.pageTitle = pageTitle ?? ""
        }
    }

    private lazy var viewModel = SafariExtensionViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        self.view = NSHostingView(rootView: SafariExtensionView(viewModel: viewModel))
    }
}
