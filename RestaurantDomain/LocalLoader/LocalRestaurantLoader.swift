//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Gabriel Estudos on 27/05/23.
//

import Foundation

public protocol LocalRestaurantLoaderInsert {
    func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void)
}

public final class LocalRestaurantLoader {
    
    private let cache: CacheClient
    private let cachePolicy: CachePolicy
    private let currentDate: () -> Date
    
    public init(cache: CacheClient, cachePolicy: CachePolicy = RestaurantLoaderCachePolicy(), currentDate: @escaping () -> Date) {
        self.cache = cache
        self.cachePolicy = cachePolicy
        self.currentDate = currentDate
    }
    
    public func validateCache() {
        cache.load { [weak self] state in
            guard let self else { return }
            switch state {
            case let .success(_ , timestamp) where !self.cachePolicy.validate(timestamp, with: self.currentDate()):
                self.cache.delete() { _ in }
            case .failure:
                self.cache.delete() { _ in }
            default:
                break
            }
        }
    }
    
    private func saveOnCache(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.save(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

extension LocalRestaurantLoader: LocalRestaurantLoaderInsert {
    
    public func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.delete { [weak self] error in
            guard let self else { return }
            guard let error else {
                return self.saveOnCache(items, completion: completion)
            }
                completion(error)
        }
    }
}

extension LocalRestaurantLoader: RestaurantLoader {
    
    public func load(completion: @escaping (Result<[RestaurantItem], RestaurantResultError>) -> Void) {
        cache.load { [weak self] state in
            guard let self else { return }
            switch state {
            case let .success(items, timestamp) where self.cachePolicy.validate(timestamp, with: self.currentDate()):
                completion(.success(items))
            case .success, .empty:
                completion(.success([]))
            case .failure:
                completion(.failure(.invalidData))
            }
        }
    }
    
    
}
