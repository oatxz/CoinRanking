//
//  ColorExtension.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import SwiftUI
import UIKit

extension Color {
    static let _GRAY    = Color.init(hex: "#999999")
    static let _WHITE   = Color.init(hex: "#F9F9F9")
    static let _BLUE    = Color.init(hex: "#38A0FF")
    static let _LIGHT_BLUE  = Color.init(hex: "#C5E6FF")
    static let _LIGHT_GRAY  = Color.init(hex: "#EEEEEE")
    static let _MEDUIM_GRAY = Color.init(hex: "#C4C4C4")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
