//
//  RestaurantUISnapshotTests.swift
//  RestaurantUITests
//
//  Created by Gabriel on 29/03/24.
//

import XCTest
import SnapshotTesting
import RestaurantDomain
@testable import RestaurantUI


final class RestaurantUISnapshotTests: XCTestCase {

    ///Rodar os testes com device iPhone 15 Pro
    func test_snapshot_after_render_restaurantItemCell() {
        let controller = RestaurantItemCellController(viewModel: dataModel[0])
        let cell = RestaurantItemCell(style: .default, reuseIdentifier: RestaurantItemCell.identifier)
        cell.backgroundColor = .white
        controller.renderCell(cell)
        assertSnapshot(matching: cell, as: .image(size: CGSize(width: 375, height: 175)))
    }
    
    ///Rodar os testes com device iPhone 15 Pro
    func test_snapshot_render_restaurantListViewController() {
        let (sut, service) = makeSUT()
        let navigation = UINavigationController(rootViewController: sut)
        
        sut.loadViewIfNeeded()
        service.completionResult(.success(dataModel))
        
        assertSnapshot(matching: navigation, as: .image(on: .iPhoneX(.portrait)))
    }

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RestaurantListViewController, service: RestaurantLoaderSpy) {
        let service = RestaurantLoaderSpy()
        let sut = RestaurantListCompose.compose(service: service) as! RestaurantListViewController
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        return (sut, service)
    }
    
    private let dataModel = [
        RestaurantItem(id: UUID(), name: "Tenda do quartel", location: "Canto do Forte - Praia Grande", distance: 50, ratings: 4, parasols: 10),
        RestaurantItem(id: UUID(), name: "Barraquinha do seu Zé", location: "Canto do Forte - Praia Grande", distance: 100, ratings: 2, parasols: 22),
        RestaurantItem(id: UUID(), name: "Barraquinha do Coronel", location: "Canto do Forte - Praia Grande", distance: 150, ratings: 3, parasols: 35),
        RestaurantItem(id: UUID(), name: "Tenda dos soldados", location: "Canto do Forte - Praia Grande", distance: 200, ratings: 4, parasols: 47),
        RestaurantItem(id: UUID(), name: "Tenda do quartel", location: "Canto do Forte - Praia Grande", distance: 250, ratings: 4, parasols: 15)
    ]

}
