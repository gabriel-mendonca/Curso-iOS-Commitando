//
//  CacheClient.swift
//  RestaurantDomain
//
//  Created by GabrielEstudos on 11/10/23.
//

import Foundation

public enum LoadResultState {
    case empty
    case success(items: [RestaurantItem], timestamp: Date)
    case failure(Error)
}

public protocol CacheClient {
    typealias SaveResult = (Error?) -> Void
    typealias DeleteResult = (Error?) -> Void
    typealias LoadResult = (LoadResultState) -> Void
    
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult)
    func delete(comletion: @escaping DeleteResult)
    func load(comletion: @escaping LoadResult)
}
