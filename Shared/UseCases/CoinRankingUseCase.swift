//
//  CoinRankingUseCase.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import Combine

public protocol CoinRankingUseCase {
    func getCoins(limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error>
    func searchCoin(keyword: String, limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error>
    func getCoinDetail(uuid: String) -> AnyPublisher<CoinDetailResponseModel, Error>
}

public class CoinRankingUseCaseImpl: CoinRankingUseCase {
    public let repository: CoinRankingRepository
    
    public init(repository: CoinRankingRepository = CoinRankingRepositoryImpl()) {
        self.repository = repository
    }
    
    public func getCoins(limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error> {
        return repository.getCoins(limit: limit).eraseToAnyPublisher()
    }
    
    public func searchCoin(keyword: String, limit: Int) -> AnyPublisher<CoinRankingResponseModel, Error> {
        return repository.searchCoin(keyword: keyword, limit: limit)
    }
    
    public func getCoinDetail(uuid: String) -> AnyPublisher<CoinDetailResponseModel, Error> {
        return repository.getCoinDetail(uuid: uuid).eraseToAnyPublisher()
    }
    
    
}
