// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        let shared = SafariExtensionViewController.shared
        shared.preferredContentSize = NSSize(width: 320, height: 240)
        window.getToolbarItem { $0?.showPopover() }
    }

    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getActiveTab { activeTab in
            activeTab?.getActivePage { activePage in
                activePage?.getPropertiesWithCompletionHandler({ (properties) in
                    SafariExtensionViewController.shared.pageTitle = properties?.title
                    SafariExtensionViewController.shared.url = properties?.url
                })
            }
        }
        validationHandler(true, "")
    }

    override func popoverViewController() -> SFSafariExtensionViewController {
        SafariExtensionViewController.shared
    }
}
