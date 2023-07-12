//
//  XCTestCase+Helpers.swift
//  RestaurantDomainTests
//
//  Created by Gabriel Estudos on 27/05/23.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"A instancia deveria ter sido desalocada, possivel vazamento de memória.", file: file, line: line)
        }
    }
}
