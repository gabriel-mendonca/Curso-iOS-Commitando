//
//  RestaurantLoaderCacheDecorator.swift
//  SunnyDay
//
//  Created by Gabriel on 30/03/24.
//

import Foundation
import RestaurantDomain

final class RestaurantLoaderCacheDecorator {
    
    private let decoratee: RestaurantLoader
    private let cache: LocalRestaurantLoaderInsert
    
    init(decoratee: RestaurantLoader, cache: LocalRestaurantLoaderInsert) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    private func save(_ items: [RestaurantItem]) {
        cache.save(items) { _ in }
    }
}

extension RestaurantLoaderCacheDecorator: RestaurantLoader {
    func load(completion: @escaping (Result<[RestaurantDomain.RestaurantItem], RestaurantDomain.RestaurantResultError>) -> Void) {
        decoratee.load { [weak self] result in
            completion( result.map { items in
                self?.save(items)
                return items
            })
        }
    }
    
    
}
