//
//  RestaurantListViewModel.swift
//  RestaurantUI
//
//  Created by Gabriel on 28/03/24.
//

import Foundation
import RestaurantDomain

final class RestaurantListViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    var service: RestaurantLoader
    
    init(service: RestaurantLoader) {
        self.service = service
    }
    
    var onLoadingState: Observer<Bool>?
    var onRestaurantItem: Observer<[RestaurantItem]>?
    
    func loadService() {
        onLoadingState?(true)
        service.load { [weak self] result in
            switch result {
            case let .success(items):
                self?.onRestaurantItem?(items)
            default:
                break
            }
            self?.onLoadingState?(false)
        }
    }
}
