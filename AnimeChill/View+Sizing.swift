//
//  View+Sizing.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 22/09/24.
//

import SwiftUI

extension View {
    public func sheetLargeSize() -> some View {
        self.modifier(LargeSizeModifier())
    }
}

fileprivate struct LargeSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 18, macOS 15, *) {
            content.presentationSizing(.fitted)
        } else {
            content.presentationDetents([.large])
        }
    }
}
