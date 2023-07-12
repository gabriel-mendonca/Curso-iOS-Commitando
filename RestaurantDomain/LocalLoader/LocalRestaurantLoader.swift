//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Gabriel Estudos on 27/05/23.
//

import Foundation

enum LocalResultState {
    case empty
    case success(items: [RestaurantItem], timestamp: Date)
    case failure(Error)
}

public protocol CacheClient {
    typealias SaveResult = (Error?) -> Void
    typealias DeleteResult = (Error?) -> Void
    typealias LoadResult = (LocalResultState) -> Void
    
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult)
    func delete(comletion: @escaping DeleteResult)
    func load(comletion: @escaping LoadResult)
}


public final class LocalRestaurantLoader {
    
    private let cache: CacheClient
    private let currentDate: () -> Date
    
    public init(cache: CacheClient, currentDate: @escaping () -> Date) {
        self.cache = cache
        self.currentDate = currentDate
    }
    
    public func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.delete { [weak self] error in
            guard let self else { return }
            guard let error else {
                return self.saveOnCache(items, completion: completion)
            }
                completion(error)
        }
    }
    
    private func saveOnCache(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.save(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}

extension LocalRestaurantLoader: RestaurantLoader {
    public func load(completion: @escaping (Result<[RestaurantItem], RestaurantResultError>) -> Void) {
        cache.load { state in
            
            switch state {
            case .empty: completion(.success([]))
            case.success(items: <#T##[RestaurantItem]#>, timestamp: <#T##Date#>)
            }
            if error == nil {
                completion(.success([]))
            } else {
                completion(.failure(.invalidData))
            }
        }
    }
    
    
}
