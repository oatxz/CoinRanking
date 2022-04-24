//
//  CoinItemModel.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation

struct CoinItemModel: Identifiable {
    let id: String
    let iconUrl: String
    let name: String
    let symbol: String
    let price: Double
    let change: Double
    let uuid: String
    let isChangePositive: Bool
    
    init(iconUrl: String, name: String, symbol: String, price: Double, change: Double, uuid: String, isChangePositive: Bool) {
        self.id         = uuid
        self.iconUrl    = iconUrl.replacingOccurrences(of: ".svg", with: ".png")
        self.name       = name
        self.symbol     = symbol
        self.price      = price
        self.change     = change
        self.uuid       = uuid
        self.isChangePositive = isChangePositive
    }
}
