//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 18/03/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {

    func test_initializer_remoteRestaurantLoader_and_validate_urlRequest() {
        let (sut, client, anyURL) = makeSUT()
        
        sut.load() { _ in}
        
        XCTAssertEqual(client.urlRequests, [anyURL])
    }
    
    func test_load_twice() {
        let (sut, client, anyURL) = makeSUT()
        
        sut.load() { _ in}
        sut.load() { _ in}
        
        XCTAssertEqual(client.urlRequests, [anyURL, anyURL])
    }

    func test_load_and_returned_error_for_connectivity() {
        let (sut, client, _) = makeSUT()
        
        assert(sut: sut, completion: .failure(.connectivity)) {
            client.completionWithError()
        }
    }
    
    func test_load_and_returned_error_for_invalidData() {
        let (sut, client, _) = makeSUT()
        
        assert(sut: sut, completion: .failure(.invalidData)) {
            client.completionWithSuccess()
        }
    }
    
    func test_load_and_returned_success_with_empty_list() {
        let (sut, client, _) = makeSUT()
        
        assert(sut: sut, completion: .success([])) {
            client.completionWithSuccess(data: emptyData())
        }
    }
    
    func test_load_and_returned_success_with_restaurant_item_list() throws {
        let (sut, client, _) = makeSUT()
        
        let (model1, json1) = makeItem()
        let (model2, json2) = makeItem()
        
        assert(sut: sut, completion: .success([model1, model2])) {
            let jsonItem = ["items": [json1, json2]]
            let data = try! XCTUnwrap(JSONSerialization.data(withJSONObject: jsonItem))
            client.completionWithSuccess(data: data)
        }
    }
    
    func test_load_and_returned_error_for_invalid_statusCode() throws {
        let (sut, client, _) = makeSUT()
        
        assert(sut: sut, completion: .failure(.invalidData)) {
            let (_, json1) = makeItem()
            let (_, json2) = makeItem()
            
            let jsonItem = ["items": [json1, json2]]
            let data = try! XCTUnwrap(JSONSerialization.data(withJSONObject: jsonItem))
            
            client.completionWithSuccess(statusCode: 201, data: data)
        }
    }
    
    func test_load_not_returned_after_sut_deallocated() {
        let anyURL = URL(string: "https://commitando.com.br")!
        let client = NetworkClientSpy()
        var sut: RemoteRestaurantLoader? = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        
        var returnedResult: RestaurantLoader.RestaurantResult?
        sut?.load(completion: { result in
            returnedResult = result
        })
        
        sut = nil
        client.completionWithSuccess()
        
    XCTAssertNil(returnedResult)
    }
    
    private func assert(sut: RemoteRestaurantLoader,
                        completion result: RestaurantLoader.RestaurantResult,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line
    ) {
        let exp = expectation(description: "esperando retorno da closure.")
        var returnedResult: RestaurantLoader.RestaurantResult?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, result)
        
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteRestaurantLoader, client: NetworkClientSpy, anyURL: URL) {
        let anyURL = URL(string: "https://commitando.com.br")!
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        trackForMemoryLeaks(client,file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client, anyURL)
    }
    
    private func emptyData() -> Data {
        return Data("{\"items\": [] }".utf8)
    }
    
    private func makeItem(id: UUID = UUID(),
                          name: String = "name",
                          location: String = "location",
                          distance: Float = 5.5,
                          ratings: Int = 4,
                          parasols: Int = 10
    ) -> (model: RestaurantItem, json: [String: Any]) {
        let model = RestaurantItem(id: id,
                                   name: name,
                                   location: location,
                                   distance: distance,
                                   ratings: ratings,
                                   parasols: parasols
        )
        let json: [String: Any] = [
            "id": model.id.uuidString,
            "name": model.name,
            "location": model.location,
            "distance": model.distance,
            "ratings": model.ratings,
            "parasols": model.parasols
        ]
        
        return (model, json)
    }

}
