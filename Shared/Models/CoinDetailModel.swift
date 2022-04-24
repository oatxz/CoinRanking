//
//  CoinDetailModel.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation

struct CoinDetailModel: Identifiable {
    let id: String
    let uuid: String
    let iconUrl: String
    let name: String
    let nameColor: String
    let symbol: String
    let price: Double
    let marketCap: Int
    let description: String
    let websiteUrl: String
    
    init(uuid: String, iconUrl: String, name: String, nameColor: String, symbol: String, price: Double, marketCap: Int, description: String, websiteUrl: String) {
        self.id = uuid
        self.uuid = uuid
        self.iconUrl = iconUrl.replacingOccurrences(of: ".svg", with: ".png")
        self.name = name
        self.nameColor = nameColor
        self.symbol = symbol
        self.price = price
        self.marketCap = marketCap
        self.description = description
        self.websiteUrl = websiteUrl
    }
}
