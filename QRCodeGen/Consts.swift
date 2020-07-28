// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation

enum Consts {
    static let gitHubUserID = "mshibanami"
    static let gitHubRepositoryID = "QRCodeGen"
    static let supportPageURL = URL(string: "https://github.com/\(gitHubUserID)/\(gitHubRepositoryID)")!
    static let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let bundleShortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let appAppleID = "id1510250324"
    static let extensionBundleIdentifier = "io.github.mshibanami.QRCodeGen.SafariExtension"
    
    static let isDownloadedFromAppStore: Bool = {
        let url = Bundle.main.bundleURL.appendingPathComponent("Contents/_MASReceipt/receipt")
        return FileManager.default.fileExists(atPath: url.path)
    }()
}
