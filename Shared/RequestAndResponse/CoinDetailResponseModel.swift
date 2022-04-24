//
//  CoinDetailResponseModel.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation

// MARK: - CoinDetailResponseModel
public struct CoinDetailResponseModel: Codable {
    let status: String
    let data: DataClass
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let coin: Coin
    }

    // MARK: - Coin
    struct Coin: Codable {
        let uuid, symbol, name, coinDescription: String?
        let color: String?
        let iconURL: String?
        let websiteURL: String?
        let links: [Link]?
        let supply: Supply?
        let numberOfMarkets, numberOfExchanges: Int?
        let the24HVolume, marketCap, price, btcPrice: String?
        let priceAt: Int?
        let change: String?
        let rank: Int?
        let sparkline: [String]?
        let allTimeHigh: AllTimeHigh?
        let coinrankingURL: String?
        let tier: Int?
        let lowVolume: Bool?
        let listedAt: Int?

        enum CodingKeys: String, CodingKey {
            case uuid, symbol, name
            case coinDescription = "description"
            case color
            case iconURL = "iconUrl"
            case websiteURL = "websiteUrl"
            case links, supply, numberOfMarkets, numberOfExchanges
            case the24HVolume = "24hVolume"
            case marketCap, price, btcPrice, priceAt, change, rank, sparkline, allTimeHigh
            case coinrankingURL = "coinrankingUrl"
            case tier, lowVolume, listedAt
        }
    }
}

// MARK: - AllTimeHigh
struct AllTimeHigh: Codable {
    let price: String
    let timestamp: Int
}

// MARK: - Link
struct Link: Codable {
    let name, type, url: String
}

// MARK: - Supply
struct Supply: Codable {
    let confirmed: Bool
    let total, circulating: String
}
