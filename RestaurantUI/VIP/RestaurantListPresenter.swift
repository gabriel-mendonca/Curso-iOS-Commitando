//
//  RestaurantListPresenter.swift
//  RestaurantUI
//
//  Created by Gabriel on 28/03/24.
//

import Foundation
import RestaurantDomain

protocol RestaurantListPresenterInput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItem(_ items: [RestaurantItem])
}

protocol RestaurantListPresenterOutput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItemCell(_ items: [RestaurantItemCellController])
}

final class RestaurantListPresenter: RestaurantListPresenterInput {
    
    weak var view: RestaurantListPresenterOutput?
    
    func onLoadingChange(_ isLoading: Bool) {
        view?.onLoadingChange(isLoading)
    }
    
    func onRestaurantItem(_ items: [RestaurantItem]) {
        view?.onRestaurantItemCell(adpatRestaurantItemToCellController(items: items))
    }
    
    func adpatRestaurantItemToCellController(items: [RestaurantItem]) -> [RestaurantItemCellController] {
        return items.map { RestaurantItemCellController(viewModel: $0)}
    }
}
