//
//  WebView.swift
//  BareBonesBlog
//
//  Created by Mitchell Cootauco on 4/5/22.
//

import SwiftUI
import WebKit
import SafariServices

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            webView.load(request)
    }

}
