//
//  HTMLTextView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import WebKit
import SwiftUI

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let textContentShow = """
        <!doctype html>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <html>
            <head>
                <link href='http://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' type='text/css'>
                <style>
                    body {
                      font-family: 'Roboto', sans-serif;
                      font-size: 14px;
                      color: #999999;
                    }
                </style>
            </head>
            <body>
                \(self.htmlContent)
            </body>
        </html>
        """
        uiView.loadHTMLString(textContentShow, baseURL: nil)
    }
}
