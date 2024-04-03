//
//  SunnyDayUITests.swift
//  SunnyDayUITests
//
//  Created by Gabriel on 29/03/24.
//

import XCTest
@testable import RestaurantDomain

final class SunnyDayUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func test_launch_should_be_show_remote_data_with_client_have_connectivity() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertEqual(app.cells.count, 10)
        XCTAssertEqual(app.cells.firstMatch.staticTexts.count, 4)
    }

    func test_launch_should_be_show_cache_data_when_client_does_not_have_connectivity() {
        let online = XCUIApplication()
        online.launchArguments = ["-reset"]
        online.launch()
        
        let offline = XCUIApplication()
        offline.launchArguments = ["-connectivity", "offline"]
        offline.launch()
        
        XCTAssertEqual(offline.cells.count, 10)
        XCTAssertEqual(offline.cells.firstMatch.staticTexts.count, 4)
    }
    
    func test_launch_should_be_show_cache_data_when_client_does_not_have_connectivity_and_cache() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset", "-connectivity", "offline"]
        app.launch()
        
        XCTAssertEqual(app.cells.count, 0)
    }
}
