//
//  FontManager.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import SwiftUI

public enum Style: String {
    case regular    = "Roboto-Regular"
    case bold       = "Roboto-Bold"
}

//MARK: - Initializers Font SwiftUI
@available(iOS 13.0, *)
public extension Font {
    
    static var headerBold: Font = Font.custom(Style.bold.rawValue, size: 18)
    static var headerText: Font = Font.custom(Style.regular.rawValue, size: 18)
    static var bodyBold: Font   = Font.custom(Style.bold.rawValue, size: 16)
    static var bodyText: Font   = Font.custom(Style.regular.rawValue, size: 16)
    static var smallBold: Font  = Font.custom(Style.bold.rawValue, size: 14)
    static var smallText: Font  = Font.custom(Style.regular.rawValue, size: 14)
    static var extraSmallBold: Font = Font.custom(Style.bold.rawValue, size: 12)
    static var extraSmallText: Font = Font.custom(Style.regular.rawValue, size: 12)

}
