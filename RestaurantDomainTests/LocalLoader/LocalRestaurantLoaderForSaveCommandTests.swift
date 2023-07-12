//
//  LocalRestaurantLoaderTests.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 27/05/23.
//

import XCTest
@testable import RestaurantDomain

final class LocalRestaurantLoaderForSaveCommandTests: XCTestCase {

  
    func test_save_deletes_old_cache() {
        let (sut, cache) = makeSUT()
        let items = [makeItem()]
        
        sut.save(items) { _ in }
   
        XCTAssertEqual(cache.methodsCalled, [.delete])
    }
    
    func test_Save_insert_new_data_on_cache() {
        let currentDate = Date()
        let (sut, cache) = makeSUT(currentDate: currentDate)
        let items = [makeItem()]
        
        sut.save(items) { _ in }
        
        cache.completionHandlerDelete(nil)
        
        XCTAssertEqual(cache.methodsCalled, [.delete, .save(items, timestamp: currentDate)])
    }
    
    func test_save_fails_after_delete_old_cache() {
        let (sut, cache) = makeSUT()
        
        let anyError = NSError(domain: "any error", code: -1)
        assert(sut, completion: anyError) {
            cache.completionHandlerDelete(anyError)
        }
    }
    
    func test_save_fails_after_insert_new_data_cache() {
        let (sut, cache) = makeSUT()
        
        let anyError = NSError(domain: "any error", code: -1)
        assert(sut, completion: anyError) {
            cache.completionHandlerDelete(nil)
            cache.completionHandlerForInsert(anyError)
        }
    }
    
    func test_save_success_after_insert_new_data_cache() {
        let (sut, cache) = makeSUT()
        
        assert(sut, completion: nil) {
            cache.completionHandlerDelete(nil)
            cache.completionHandlerForInsert(nil)
        }
    }
    
    func test_save_non_insert_after_sut_deallocated() {
        let currentDate = Date()
        let cache = CacheClientSpy()
        var sut: LocalRestaurantLoader? = LocalRestaurantLoader(cache: cache, currentDate: { currentDate })
        let items = [makeItem()]
        
        var returnedError: Error?
        sut?.save(items) { error in
            returnedError = error
        }
        sut = nil
        
        cache.completionHandlerForInsert(nil)
        
        XCTAssertNil(returnedError)
    }
    
    func test_save_non_completion_after_sut_deallocated() {
        let currentDate = Date()
        let cache = CacheClientSpy()
        var sut: LocalRestaurantLoader? = LocalRestaurantLoader(cache: cache, currentDate: { currentDate })
        let items = [makeItem()]
        
        var returnedError: Error?
        sut?.save(items) { error in
            returnedError = error
        }
        
        cache.completionHandlerForInsert(nil)
        sut = nil
        cache.completionHandlerForInsert(nil)
        
        XCTAssertNil(returnedError)
    }
    
    private func makeItem() -> RestaurantItem {
        return RestaurantItem(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)
    }
    
    private func assert(
        _ sut: LocalRestaurantLoader,
        completion error: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let items = [makeItem()]
        
        var returnedError: Error?
        sut.save(items) { error in
            returnedError = error
        }
        
        action()
        
        XCTAssertEqual(returnedError as? NSError, error)
    }
    
    private func makeSUT(currentDate: Date = Date(), file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache: cache, currentDate: { currentDate })
        trackForMemoryLeaks(cache)
        trackForMemoryLeaks(sut)
        return (sut, cache)
    }

}
