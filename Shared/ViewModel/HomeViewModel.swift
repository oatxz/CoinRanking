//
//  HomeViewModel.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 8/4/2565 BE.
//

import Foundation
import SwiftUI
import Combine

public class HomeViewModel: ObservableObject {
    
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    @Published var coins: [CoinItemModel] = []
    @Published var detailCoin: CoinDetailModel?
    @Published var filterCoins: [CoinItemModel] = []
    @Published var state: LoadShelfState = .idle
    @Published var detailState: LoadShelfState = .idle
    @Published var useCase: CoinRankingUseCase
    public var limitCoinsList: Int
    public let inviteCode: String = "X67VaMOA" // random code
    
    init(useCase: CoinRankingUseCase) {
        self.useCase = useCase
        self.limitCoinsList = 10
    }
    
    // MARK: - loadShelf
    func loadShelf() {
        self.state = .loading
        fetchCoinRanking(limit: limitCoinsList, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let object):
                self.coins = self.coinsData(object: object)
                self.filterCoins = self.coins
                self.state = .success
            case .failure(_):
                self.state = .fail
            }
        })
    }

    func pullToNext() {
        /// when pull to last coin in Main
        self.limitCoinsList  *= 2
    }
    
    // MARK: - fetchCoinRanking
    func fetchCoinRanking(limit: Int, completion: @escaping ((Result<CoinRankingResponseModel>) -> Void)) {
        self.useCase.getCoins(limit: limit)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .finished:
                    debugPrint("fetch CoinRankingData - Finish")
                case .failure(let error):
                    debugPrint("fetch CoinRankingData - Error: \(error)")
                    completion(.failure(error))
                }
            }, receiveValue: { value in
                self.coins = self.coinsData(object: value)
                self.filterCoins = self.coins
                completion(.success(value))
            })
            .store(in: &self.anyCancellable)
    }
    
    // MARK: - fetchSearchCoins
    func fetchSearchCoins(keyword: String, limit: Int, completion: @escaping ((Result<CoinRankingResponseModel>) -> Void)) {
        self.useCase.searchCoin(keyword: keyword, limit: limit)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .finished:
                    debugPrint("fetch SearchCoins - Finish")
                case .failure(let error):
                    debugPrint("fetch SearchCoins - Error: \(error)")
                    completion(.failure(error))
                }
            }, receiveValue: { value in
                self.filterCoins = self.coinsData(object: value)
                completion(.success(value))
            })
            .store(in: &self.anyCancellable)
    }
    
    // MARK: - coinsData
    func coinsData(object: CoinRankingResponseModel) -> [CoinItemModel] {
        let coins = object.data.coins
        var deck: [CoinItemModel] = []
        for coin in coins {
            let price: Double  = Double(coin.price) ?? 0
            let change: Double = Double(coin.change) ?? 0
            let isChangePositive: Bool = {
                return change >= 0 ? true : false
            }()
            let item = CoinItemModel(iconUrl: coin.iconURL,
                                     name: coin.name,
                                     symbol: coin.symbol,
                                     price: price,
                                     change: change,
                                     uuid: coin.uuid,
                                     isChangePositive: isChangePositive)
            deck.append(item)
        }
        return deck
    }
    
    // MARK: - loadCoinDetail
    func loadCoinDetail(uuid: String) {
        self.detailState = .loading
        self.fetchCoinDetail(uuid: uuid, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(_):
                self.detailState = .fail
            case .success(_):
                self.detailState = .success
            }
        })
    }
    
    // MARK: - fetchCoinDetail
    func fetchCoinDetail(uuid: String, completion: @escaping ((Result<CoinDetailModel>) -> Void)) {
        self.useCase.getCoinDetail(uuid: uuid)
            .sink(receiveCompletion: { complete in
                switch complete {
                case .finished:
                    debugPrint("fetch CoinDetail - Finish")
                case .failure(let error):
                    debugPrint("fetch CoinDetail - Error: \(error)")
                    completion(.failure(error))
                }
            }, receiveValue: { value in
                let coin = value.data.coin
                let detail = CoinDetailModel(uuid:    coin.uuid,
                                           iconUrl:      coin.iconURL,
                                           name:         coin.name,
                                           nameColor:    coin.color,
                                           symbol:       coin.symbol,
                                           price:        Double(coin.price) ?? 0.0,
                                           marketCap:    Int(coin.marketCap) ?? 0,
                                           description:  coin.coinDescription,
                                           websiteUrl:   coin.websiteURL)
                self.detailCoin = detail
                completion(.success(detail))
            })
            .store(in: &self.anyCancellable)
    }
}

enum LoadShelfState {
    case idle
    case loading
    case success
    case fail
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}
