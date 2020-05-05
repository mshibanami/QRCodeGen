// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation
import Combine

class SafariExtensionViewModel: ObservableObject {
    @Published var pageTitle = ""
    @Published var urlString = ""
    @Published var isValidTab = false

    private var cancellables: Set<AnyCancellable> = []

    init() {
        self.$urlString
            .sink(receiveValue: { [weak self] in
                self?.isValidTab = !$0.isEmpty
            })
            .store(in: &cancellables)
    }

    func setURL(_ url: URL?) {
        urlString = url?.absoluteString ?? ""
    }
}
