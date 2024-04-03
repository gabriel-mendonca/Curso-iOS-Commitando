//
//  XCTestCase+Helpers.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 27/05/23.
//

import XCTest
import RestaurantDomain

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"A instancia deveria ter sido desalocada, possivel vazamento de memória.", file: file, line: line)
        }
    }
    
    func makeItem() -> RestaurantItem {
        return RestaurantItem(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)
    }
}

extension Date {
        func adding(days: Int) -> Date {
            return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
        }
        
        func adding(seconds: TimeInterval) -> Date {
            return self + seconds
        }
    }
