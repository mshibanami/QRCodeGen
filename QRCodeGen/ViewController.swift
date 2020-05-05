// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa
import SafariServices.SFSafariApplication

class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }

    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "io.github.mshibanami.QRCodeGen.SafariExtension") { _ in }
    }

    @IBAction func didTapAboutThisApp(_ sender: AnyObject?) {
        NSWorkspace.shared.open(
            URL(string: "https://github.com/mshibanami/QRCodeGen")!)
    }
}
