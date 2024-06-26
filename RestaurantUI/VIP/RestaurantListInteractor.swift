//
//  RestaurantListInteractor.swift
//  RestaurantUI
//
//  Created by Gabriel on 28/03/24.
//

import Foundation
import RestaurantDomain

protocol RestaurantListInteractorInput: AnyObject {
    func loadService()
}

final class RestaurantListInteractor: RestaurantListInteractorInput {
    
    private let service: RestaurantLoader
    private let presenter: RestaurantListPresenterInput
    
    init(service: RestaurantLoader, presenter: RestaurantListPresenterInput) {
        self.service = service
        self.presenter = presenter
    }
    
    func loadService() {
        presenter.onLoadingChange(true)
        service.load { [weak presenter] result in
            switch result {
            case let .success(items):
                presenter?.onRestaurantItem(items)
            default:
                break
            }
            presenter?.onLoadingChange(false)
        }
    }
    
    
}
