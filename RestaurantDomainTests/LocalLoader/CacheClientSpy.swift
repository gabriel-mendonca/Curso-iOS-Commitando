//
//  CacheClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 27/05/23.
//

import RestaurantDomain

final class CacheClientSpy: CacheClient {
    
    enum Methods: Equatable {
        case save(_ items: [RestaurantItem], timestamp: Date)
        case delete
        case load
    }
    
    private(set) var methodsCalled = [Methods]()

    private var completionHandlerInsert: ((Error?) -> Void)?
    func save(_ items: [RestaurantDomain.RestaurantItem], timestamp: Date, completion: @escaping CacheClient.SaveResult) {
        methodsCalled.append(.save(items, timestamp: timestamp))
        completionHandlerInsert = completion
    }

    private var completionHandlerDelete: ((Error?) -> Void)?
    func delete(comletion: @escaping CacheClient.DeleteResult) {
        methodsCalled.append(.delete)
        completionHandlerDelete = comletion
    }

    private var completionHandlerLoad: ((Error?) -> Void)?
    func load(comletion: @escaping LoadResult) {
        methodsCalled.append(.load)
        completionHandlerLoad = comletion
        
    }
    
    func completionHandlerDelete(_ error: Error?) {
        completionHandlerDelete?(error)
    }
    
    func completionHandlerForInsert(_ error: Error?) {
        completionHandlerInsert?(error)
    }
    
    func completionHandlerForLoad(_ error: Error?) {
        completionHandlerLoad?(error)
    }
    
}
