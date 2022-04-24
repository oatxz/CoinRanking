//
//  CoinRankingRepository.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import Combine
import Moya

public protocol CoinRankingRepository {
    func getCoins(limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error>
    func searchCoin(keyword: String, limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error>
    func getCoinDetail(uuid: String) -> AnyPublisher<CoinDetailResponseModel, Error>
}

public class CoinRankingRepositoryImpl: CoinRankingRepository {
    public let provider = MoyaProvider<CoinRankingAPI>()
    public init() {}
    
    public func getCoins(limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error> {
        return provider
            .cb
            .request(.getCoins(limit: limit))
            .map(CoinRankingResponseModel.self)
            .eraseToAnyPublisher()
    }
    
    public func searchCoin(keyword: String, limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error> {
        return provider
            .cb
            .request(.searchCoin(keyword: keyword, limit: limit))
            .map(CoinRankingResponseModel.self)
            .eraseToAnyPublisher()
    }
    
    public func getCoinDetail(uuid: String) -> AnyPublisher<CoinDetailResponseModel, Error> {
        return provider
            .cb
            .request(.getCoinDetail(uuid: uuid))
            .map(CoinDetailResponseModel.self)
            .eraseToAnyPublisher()
    }
}
