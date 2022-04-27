//
//  CoinRankingResponseModel.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 8/4/2565 BE.
//
//   let coinRankingModel = try? newJSONDecoder().decode(CoinRankingModel.self, from: jsonData)

import Foundation

// MARK: - CoinRankingResponseModel
public struct CoinRankingResponseModel: Codable {
    let status: String
    let data: DataClass
    
    // MARK: - DataClass
    public struct DataClass: Codable {
        let stats: Stats
        let coins: [Coin]
    }

    // MARK: - Coin
    public struct Coin: Codable {
        let uuid, symbol, name: String?
        let color: String?
        let iconURL: String?
        let marketCap, price: String?
        let listedAt, tier: Int?
        let change: String?
        let rank: Int?
        let sparkline: [String?]
        let lowVolume: Bool?
        let coinrankingURL: String?
        let the24HVolume, btcPrice: String?

        enum CodingKeys: String, CodingKey {
            case uuid, symbol, name, color
            case iconURL = "iconUrl"
            case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
            case coinrankingURL = "coinrankingUrl"
            case the24HVolume = "24hVolume"
            case btcPrice
        }
    }

    // MARK: - Stats
    public struct Stats: Codable {
        let total, totalCoins, totalMarkets: Int
        let totalExchanges: Int
        let totalMarketCap, total24HVolume: String

        enum CodingKeys: String, CodingKey {
            case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
            case total24HVolume = "total24hVolume"
        }
    }
}

// MARK: - CoinRankingResponseModel
public struct CoinRankingErrorResponseModel: Codable {
    let status, type, message: String?
    
    enum CodingKeys: String, CodingKey {
        case status, type, message
    }
}
