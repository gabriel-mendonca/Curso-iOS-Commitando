//
//  LocalRestaurantLoaderForLoadCommandTests.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 27/05/23.
//

import XCTest
@testable import RestaurantDomain

final class LocalRestaurantLoaderForLoadCommandTests: XCTestCase {
    
    func test_load_returned_completion_error() {
        let (sut, cache) = makeSUT()
        
        assert(sut, completion: .failure(.invalidData)) {
            let anyError = NSError(domain: "any error", code: -1)
            cache.completionHandlerForLoad(.failure(anyError))
        }
    }
    
    func test_load_returned_completion_success_with_empty_data() {
        let (sut, cache) = makeSUT()
        
        assert(sut, completion: .success([])) {
            cache.completionHandlerForLoad(.empty)
        }
    }
    
    func test_load_returned_data_with_one_day_less_than_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1).adding(seconds: 1)
        let (sut, cache) = makeSUT(currentDate: currentDate)
        let items = [makeItem()]
        
        assert(sut, completion: .success(items)) {
            cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        }
    }
    
    func test_load_returned_data_with_one_day_old_cache() {
        let currentDate = Date()
        let oneDayOldCacheDate = currentDate.adding(days: -1)
        let (sut, cache) = makeSUT(currentDate: currentDate)
        let items = [makeItem()]
        
        assert(sut, completion: .success([])) {
            cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayOldCacheDate))
        }
    }
    
    private func makeSUT(currentDate: Date = Date(),
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache: cache, currentDate: { currentDate })
        trackForMemoryLeaks(cache)
        trackForMemoryLeaks(sut)
        return (sut, cache)
    }
    
    private func assert(
        _ sut: LocalRestaurantLoader,
        completion result: (Result<[RestaurantItem], RestaurantResultError>)??,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var returnedResult: (Result<[RestaurantItem], RestaurantResultError>)?
        sut.load { result in
            returnedResult = result
        }
        
        action()
        
        XCTAssertEqual(returnedResult, result)
    }

}
