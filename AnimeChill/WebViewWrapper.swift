//
//  WebViewWrapper.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 01/10/24.
//

import SwiftUI
import WebKit

#if !os(macOS)
struct WebViewWrapper: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        let url = URL(string: self.url)!
        let request = URLRequest(url: url)
        view.load(request)
        
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
#else
struct WebViewWrapper: NSViewRepresentable {
    let url: String
    
    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        let url = URL(string: self.url)!
        let request = URLRequest(url: url)
        view.load(request)
        
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        
    }
}
#endif

#Preview {
    WebViewWrapper(url: "https://www.apple.com")
}
