//
//  NetworkClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 22/05/23.
//

import Foundation
import RestaurantDomain

final class NetworkClientSpy: NetworkClient {
    private(set) var urlRequests: [URL] = []
    private var completionHandler: ((NetworkResult) -> Void)?
    
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void) {
        urlRequests.append(url)
        completionHandler = completion
    }
    
    func completionWithError() {
        completionHandler?(.failure(anyError()))
    }
    
    func completionWithSuccess(statusCode: Int = 200, data: Data = Data()) {
        let response = HTTPURLResponse(url: urlRequests[0], statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        completionHandler?(.success((data, response)))
    }
    
    private func anyError() -> Error {
        return NSError(domain: "any error", code: -1)
    }
}
