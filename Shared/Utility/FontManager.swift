//
//  FontManager.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import SwiftUI

let DISPATCH_CONFIG = DispatchQueue.init(label: "InitConfig")
public var BUNDLE_ID: Bundle = Bundle(identifier: "oatxz.communityshelf.LMWN-Coinranking")!

//MARK: - Font Parts
public extension UIFont {
    
    enum Family: String {
        case bold           = "Roboto-Bold"
        case light          = "Roboto-Light"
        case regular        = "Roboto-Regular"
        case thin           = "Roboto-Thin"
        
        /// easy to change default app font family
        static let defaultFamily = Family.regular
    }
    
    enum CustomWeight: String {
        case regular    = "regular"
        case bold       = "bold"
        case thin       = "thin"
        case light      = "light"
    }
    
    //MARK: - load framework font in application
    static let loadAllFonts: () = {
        DISPATCH_CONFIG.async {
            registerFontWith(filenameString: Family.bold.rawValue)
            registerFontWith(filenameString: Family.light.rawValue)
            registerFontWith(filenameString: Family.regular.rawValue)
            registerFontWith(filenameString: Family.thin.rawValue)
        }
    }()

    //MARK: - Make custom font bundle register to framework
    private static func registerFontWith(filenameString: String) {
        
        let pathForResourceString = BUNDLE_ID.path(forResource: filenameString, ofType: "ttf")
        let fontData = NSData(contentsOfFile: pathForResourceString!)
        let dataProvider = CGDataProvider(data: fontData!)
        let fontRef = CGFont(dataProvider!)
        var errorRef: Unmanaged<CFError>? = nil

        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
            NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
    
    private class func stringName(_ weight: CustomWeight) -> String {
        /**
        Define incompatible family, weight  here
        in this case set defaults compatible values
        */
        
        switch weight {
        case .regular:
            return Family.regular.rawValue
        case .bold:
            return Family.thin.rawValue
        case .thin:
            return Family.thin.rawValue
        case .light:
            return Family.light.rawValue
        }
    }
}

//MARK: - Initializers UIFont UIKit
public extension UIFont {
    /// For example:
    ///
    ///     label.text = "Example UIFont"
    ///     label.font = UIFont.titleBar
    
    static var headerBold: UIFont   { UIFont(18.0, .bold) }
    static var headerText: UIFont   { UIFont(18.0, .regular) }
    static var bodyBold: UIFont { UIFont(16.0, .bold) }
    static var bodyText: UIFont { UIFont(16.0, .regular) }
    static var smallBold: UIFont { UIFont(14.0, .bold) }
    static var smallText: UIFont { UIFont(14.0, .regular) }
    static var extraSmallBold: UIFont { UIFont(12.0, .bold) }
    static var extraSmallText: UIFont { UIFont(12.0, .regular) }
    
    convenience init(_ size: CGFloat, _ weight: CustomWeight) {
        let nameSystem = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium).familyName
        self.init(name: nameSystem, size: size)!
    }
}

//MARK: - Initializers Font SwiftUI
@available(iOS 13.0, *)
public extension Font {
    /// For example:
    ///
    ///     Text("Example font").font(Font.titleBar)
    ///
    /// - Parameters:
    ///     - font: font syle.
    
    static var headerBold: Font   { Font(18.0, .bold) }
    static var headerText: Font   { Font(18.0, .regular) }
    static var bodyBold: Font { Font(16.0, .bold) }
    static var bodyText: Font { Font(16.0, .regular) }
    static var smallBold: Font { Font(14.0, .bold) }
    static var smallText: Font { Font(14.0, .regular) }
    static var extraSmallBold: Font { Font(12.0, .bold) }
    static var extraSmallText: Font { Font(12.0, .regular) }
    
    init() {
        self.init(UIFont.bodyText)
    }
    
    init(_ size: CGFloat, _ weight: UIFont.CustomWeight) {
        self.init(UIFont(size, weight))
    }
}

struct Fonts {
    struct Roboto {
        static let bold    = "Roboto-Bold"
        static let light   = "Roboto-Light"
        static let regular = "Roboto-Regular"
        static let thin    = "Roboto-Thin"
    }
}
