//
//  L10n.swift
//  QRCodeGen Extension
//
//  Created by Manabu Nakazawa on 27/4/20.
//  Copyright © 2020 Manabu Nakazawa. All rights reserved.
//

import Foundation

class L10n {
    static let appName = "QR Code Gen for Safari"
    static let appShortName = "QR Code Gen"
    static let forSafari = "for Safari"
    static func appVersion(version: String, buildVersion: String) -> String {
         return String(
            format: NSLocalizedString("Version %@ (%@)", comment: ""),
            version,
            buildVersion)
    }
    static let qrCodeNotFound = NSLocalizedString("QR code for the current tab will be displayed here.", comment: "")
    static let menuItemHideApp = String(format: NSLocalizedString("Hide %@", comment: ""), appShortName)
    static let menuItemHideOthers = NSLocalizedString("Hide Others", comment: "")
    static let menuItemShowAll = NSLocalizedString("Show All", comment: "")
    static let menuItemQuitApp = String(format: NSLocalizedString("Quit %@", comment: ""), appShortName)
    static let menuItemWindow = NSLocalizedString("Window", comment: "")
    static let menuItemClose = NSLocalizedString("Close", comment: "")
    static let extensionIsDisabled = NSLocalizedString("Please enable the extension in Safari Preferences.", comment: "")
    static let openSafariPreferences = NSLocalizedString("Open Safari Preferences…", comment: "")
    static let sendFeedback = NSLocalizedString("Send Feedback…", comment: "")
    static let aboutThisExtension = NSLocalizedString("About this extension", comment: "")
    
    static let copyThisImage = NSLocalizedString("Copy this image", comment: "")
}
