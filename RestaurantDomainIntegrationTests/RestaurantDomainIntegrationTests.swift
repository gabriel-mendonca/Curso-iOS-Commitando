//
//  RestaurantDomainIntegrationTests.swift
//  RestaurantDomainIntegrationTests
//
//  Created by Gabriel on 01/04/24.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainIntegrationTests: XCTestCase {
    
    func test_load_and_returned_restaurantItem_list() {
        
        let sut = makeSUT()
        let exp = expectation(description: "esperado retorno do bloco")
        sut.load { result in
            switch result {
            case let .success(items):
                
                let item = items.first
                
                XCTAssertEqual(items.count, 10)
                XCTAssertEqual(item?.name, "Tenda do quartel 1")
                
                XCTAssertTrue(((item?.name.isEmpty) != nil))
                XCTAssertNotNil(item?.location)
                XCTAssertNotNil(item?.distance)
                XCTAssertNotNil(item?.ratings)
                XCTAssertNotNil(item?.parasols)
                
            default:
                XCTFail("Era esperado retorno [RestaurantItem] porem \(result)")
            }
        }
        exp.fulfill()
        
        wait(for: [exp], timeout: 3.0)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RemoteRestaurantLoader {
        let session = URLSession(configuration: .ephemeral)
        let network = NetworkService(session: session)
        let url = URL(string: "https://raw.githubusercontent.com/comitando/assets/main/api/restaurant_list_endpoint.json")!
        return RemoteRestaurantLoader(url: url, networkClient: network)
    }
}
