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
    func delete(completion: @escaping DeleteResult)
    func load(completion: @escaping LoadResult)
}

public final class CacheService: CacheClient {
    
    private struct Cache: Codable {
        let items: [RestaurantItem]
        let timestamp: Date
    }
    
    private let managerURL: URL
    private let callbackQueue = DispatchQueue(label: "\(CacheService.self).CallbackQueue", qos: .userInitiated, attributes: .concurrent)
    
    public init(managerURL: URL) {
        self.managerURL = managerURL
    }
    
    public func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult) {
        let managerURL = self.managerURL
        callbackQueue.async(flags: .barrier) {
            do {
                let cache = Cache(items: items, timestamp: timestamp)
                let encoder = JSONEncoder()
                let encoded = try encoder.encode(cache)
                try encoded.write(to: managerURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func delete(completion: @escaping DeleteResult) {
         let managerURL = self.managerURL
         callbackQueue.async(flags: .barrier) {
             guard FileManager.default.fileExists(atPath: managerURL.path) else {
                 return completion(nil)
             }

             do {
                 try FileManager.default.removeItem(at: managerURL)
                 completion(nil)
             } catch {
                 completion(error)
             }
         }
     }
    
    public func load(completion: @escaping LoadResult) {
        let managerURL = self.managerURL
        callbackQueue.async {
            guard let data = try? Data(contentsOf: managerURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.success(items: cache.items, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
