//
//  CoinRankingAPI.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import Moya

public enum CoinRankingAPI {
    case getCoins(limit: Int)
    case searchCoin(keyword: String, limit: Int)
    case getCoinDetail(uuid: String)
}

extension CoinRankingAPI: TargetType {
    public var baseURL: URL {
        return URL(string: Config.COINRANKING_BASE_URL)!
    }
    
    public var path: String {
        switch self {
        case .getCoins(_):
            return "/v2/coins"
        case .searchCoin(_, _):
            return "/v2/coins"
        case .getCoinDetail(uuid: let uuid):
            return "/v2/coin/\(uuid)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getCoins(limit:_), .searchCoin(keyword: _, limit: _):
            return .get
        case .getCoinDetail(uuid: _):
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getCoins(limit: let limit):
            let param = ["limit": limit]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .searchCoin(keyword: let keyword, limit: let limit):
            let param = ["limit": limit,
                         "search": keyword] as [String : Any]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case .getCoinDetail(uuid: _):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        let header = [
            "x-access-token": Config.COINRANKING_APIKEY,
            "Content-type": "application/json"
        ]
        return header
    }
}
