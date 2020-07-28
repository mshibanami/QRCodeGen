// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Cocoa
import SafariServices.SFSafariApplication

class MainViewController: NSViewController {
    private let feedbackMenuPresenter = FeedbackMenuPresenter(onFinishSelectingMenuItem: {})
    
    private let appIconImageView: NSImageView = {
        let image = NSImage(named: "AppIcon")!
        let view = NSImageView(image: image)
        view.imageScaling = .scaleProportionallyUpOrDown
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: image.size.height / image.size.width)
        ])
        return view
    }()
    
    private let appTitleLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.appShortName)
        label.font = NSFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let forSafariLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.forSafari)
        label.font = NSFont.systemFont(ofSize: 18)
        label.textColor = Colors.subtitleColor
        return label
    }()
    
    private let versionLabel: NSTextField = {
        let label = NSTextField(labelWithString: L10n.appVersion(
            version: Consts.bundleShortVersion,
            buildVersion: Consts.bundleVersion))
        label.font = NSFont.systemFont(ofSize: 13)
        label.isSelectable = true
        label.textColor = Colors.subtitleColor
        return label
    }()
    
    private lazy var openSafariPreferencesButton: NSButton = {
        let button = NSButton(
            title: L10n.openSafariPreferences,
            target: self,
            action: #selector(didSelectOpenSafariPreferences(_:)))
        button.isHighlighted = true
        return button
    }()
    
    private lazy var sendFeedbackButton: NSButton = {
        let button = NSButton(title: L10n.sendFeedback, target: self, action: #selector(didSelectSendFeedback(_:)))
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var aboutThisExtensionButton: NSButton = {
        let button = NSButton(title: L10n.aboutThisExtension, target: self, action: #selector(didSelectAboutThisApp(_:)))
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var bottomButtonsView: NSStackView = {
        let view = NSStackView(views: [
            sendFeedbackButton,
            aboutThisExtensionButton,
        ])
        return view
    }()
    
    private lazy var extensionDisabledView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.85).cgColor
        let stackView = NSStackView(
            views:[
                {
                    let textField = NSTextField(labelWithString: L10n.extensionIsDisabled)
                    textField.font = NSFont.boldSystemFont(ofSize: 20)
                    textField.alignment = .center
                    textField.lineBreakMode = .byWordWrapping
                    textField.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
                    return textField
                }(),
                openSafariPreferencesButton
        ])
        stackView.spacing = 18
        stackView.orientation = .vertical
        view.addAutoLayoutSubview(stackView)
        stackView.fillToSuperview()
        return view
    }()
    
    private var extensionStateRefreshTimer: Timer?
    
    private var isExtensionEnabled: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    override func loadView() {
        let titleStackView = NSStackView(views: [
            appTitleLabel,
            forSafariLabel,
        ])
        titleStackView.spacing = 6
        titleStackView.orientation = .horizontal
        titleStackView.alignment = .firstBaseline
        titleStackView.distribution = .fill
        
        let headerTrailingStackView = NSStackView(views: [
            titleStackView,
            versionLabel
        ])
        headerTrailingStackView.spacing = 0
        headerTrailingStackView.orientation = .vertical
        headerTrailingStackView.alignment = .leading
        headerTrailingStackView.distribution = .fill
        
        let headerStackView = NSStackView(views: [
            appIconImageView,
            headerTrailingStackView
        ])
        headerStackView.spacing = 20
        headerStackView.orientation = .vertical
        headerStackView.alignment = .centerY
        headerStackView.distribution = .fill
        
        let contentStackView = NSStackView(views: [
            headerStackView,
            extensionDisabledView,
            bottomButtonsView
        ])
        contentStackView.orientation = .vertical
        contentStackView.distribution = .fill
        contentStackView.setCustomSpacing(20, after: headerStackView)
        contentStackView.setCustomSpacing(50, after: extensionDisabledView)
        
        let contentEdgeView = NSView()
        contentEdgeView.addAutoLayoutSubview(contentStackView)
        contentStackView.fillToSuperview(edgeInsets: .init(top: 10, left: 30, bottom: 30, right: 30))
        
        let stackView = NSStackView(views: [
            contentEdgeView
        ])
        stackView.orientation = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        let view = NSView()
        view.addAutoLayoutSubview(stackView)
        stackView.fillToSuperview()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extensionStateRefreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.refreshExtensionState()
        }
        
        refreshExtensionState()
        updateUI()
    }
    
    private func refreshExtensionState() {
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: Consts.extensionBundleIdentifier) { state, error in
            guard let state = state else {
                return
            }
            DispatchQueue.main.async {
                self.isExtensionEnabled = state.isEnabled
            }
        }
    }
    
    private func updateUI() {
        extensionDisabledView.alphaValue = isExtensionEnabled ? 0 : 1
    }
        
    // MARK: Actions
    
    @objc private func didSelectSendFeedback(_ sender: NSView) {
        feedbackMenuPresenter.showMenu(with: nil, for: sender)
    }

    @objc private func didSelectOpenSafariPreferences(_ sender: NSView) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: Consts.extensionBundleIdentifier)
    }
    
    @objc private func didSelectAboutThisApp(_ sender: AnyObject?) {
        NSWorkspace.shared.open(Consts.supportPageURL)
    }
}

private extension NSTextField {
    convenience init(settingLabelWithString string: String) {
        self.init(labelWithString: string + ":")
    }
    
    convenience init(noteLabelWithString string: String) {
        self.init(labelWithString: string)
        font = NSFont.systemFont(ofSize: 11)
        lineBreakMode = .byWordWrapping
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
