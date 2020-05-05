// Copyright (c) 2020 Manabu Nakazawa. Licensed under the MIT license. See LICENSE in the project root for license information.

import Foundation
import SwiftUI

struct SafariExtensionView: View {
    @ObservedObject var viewModel: SafariExtensionViewModel

    var body: some View {
        let v: AnyView
        if viewModel.isValidTab {
            v = AnyView(makeContentView())
        } else {
            v = AnyView(makeEmptyView())
        }
        return v
            .frame(width: 400, height: 500)
            .padding(EdgeInsets(top: 6, leading: 6, bottom: 10, trailing: 6))
    }

    func makeContentView() -> some View {
        return VStack(alignment: .center) {
            Spacer()
            Image(nsImage: { () -> NSImage in
                guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
                    NSLog("Failed initializing the filter with CIQRCodeGenerator.")
                    return NSImage()
                }
                filter.setValue(viewModel.urlString.data(using: .utf8), forKey: "inputMessage")
                guard let ciImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)) else {
                    NSLog("Failed setting 'inputMessage' for the filter.")
                    return NSImage()
                }
                return NSImage(ciImage: ciImage)
            }())
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(viewModel.pageTitle)
                .truncationMode(.tail)
                .layoutPriority(1)
                .lineLimit(1)
                .padding(EdgeInsets(top: 3, leading: 5, bottom: 0, trailing: 5))
            MacEditorTextView(text: $viewModel.urlString, font: .systemFont(ofSize: 14), isEditable: true)
                .frame(height: 60)
            Spacer()
        }
    }
    
    func makeEmptyView() -> some View {
        return VStack(alignment: .center, spacing: 20) {
            Spacer()
            Image("empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            Text(L10n.qrCodeNotFound)
                .font(Font.subheadline)
                .padding(.init(top: 0, leading: 0, bottom: 20, trailing: 0))
            Spacer()
        }
    }
}

private extension NSImage {
    convenience init(ciImage: CIImage) {
        let imageRep = NSCIImageRep(ciImage: ciImage)
        self.init(size: .zero)
        addRepresentation(imageRep)
    }
}
