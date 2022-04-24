//
//  ViewOffsetKey.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 11/4/2565 BE.
//

import Foundation
import SwiftUI

public struct ViewOffsetKey: PreferenceKey {
    public static var defaultValue = CGFloat.zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
