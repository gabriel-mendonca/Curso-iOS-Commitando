//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Gabriel Estudos on 18/03/23.
//

import Foundation
import NetworkClient

struct RestaurantRoot: Decodable {
    let items: [RestaurantItem]
}

public final class RemoteRestaurantLoader: RestaurantLoader {
    let url: URL
    let networkClient: NetworkClient
    let okResponse: Int = 200
    
    public init(url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    private func successFullyValidation(_ data: Data, response: HTTPURLResponse) -> RestaurantLoader.RestaurantResult {
        guard let json = try? JSONDecoder().decode(RestaurantRoot.self, from: data), response.statusCode == okResponse else {
            return .failure(.invalidData)
        }
        
        return .success(json.items)
    }
    
    public func load(completion: @escaping (RestaurantLoader.RestaurantResult) -> Void) {
        networkClient.request(from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.successFullyValidation(data, response: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
