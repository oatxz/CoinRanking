//
//  Moya+Combine.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import Foundation
import Combine
import Moya

extension MoyaProvider: CombineCompatible { }

public extension Combine where Base: MoyaProviderType {
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Future<Response, Error> {
        return Future { [weak base] (promise) in
            _ = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { (result) in
                switch result {
                case let .success(response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
    }
}

public extension Publisher where Output == String?, Failure == Never {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D?, Never> {
        return flatMap { (output) -> Future<D?, Never> in
            return Future { (promise) in
                promise(.success(output?.decode(type: type)))
            }
        }.eraseToAnyPublisher()
    }
}

public extension Publisher where Output == Response, Failure == Error {
    func map<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> AnyPublisher<D, Self.Failure> {
        return flatMap { (output) -> Future<D, Self.Failure> in
            return Future { (promise) in
                do {
                    promise(.success(try output.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)))
                } catch {
                    promise(.failure(MoyaError.jsonMapping(output)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func filter(statusCode: Int) -> AnyPublisher<Response, Error> {
        return flatMap { (output) -> Future<Response, Error> in
            return Future { (promise) in
                do {
                    promise(.success(try output.filter(statusCode: statusCode)))
                } catch {}
            }
        }.eraseToAnyPublisher()
    }
    
    func filter<R: RangeExpression>(statusCodes: R) -> AnyPublisher<Response, Error> where R.Bound == Int {
        return flatMap { (output) -> Future<Response, Error> in
            return Future { (promise) in
                do {
                    promise(.success(try output.filter(statusCodes: statusCodes)))
                } catch {}
            }
        }.eraseToAnyPublisher()
    }
}

public struct Combine<Base> {
    
    let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

public protocol CombineCompatible {
    
    associatedtype CompatibleType
    
    static var cb: Combine<CompatibleType>.Type { get set }
    
    var cb: Combine<CompatibleType> { get set }
}

extension CombineCompatible {
    public static var cb: Combine<Self>.Type {
        get {
            return Combine<Self>.self
        }
        set {
            
        }
    }
    
    public var cb: Combine<Self> {
        get {
            return Combine(self)
        }
        set {
            
        }
    }
}

import class Foundation.NSObject

extension NSObject: CombineCompatible { }

public extension String {
    func decode<T: Decodable>(type: T.Type) -> T? {
        if let jsonData = self.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
            let decodable = try decoder.decode(type.self, from: jsonData)
                return decodable
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
