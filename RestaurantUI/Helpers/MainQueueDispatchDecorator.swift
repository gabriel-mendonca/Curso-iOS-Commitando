//
//  MainQueueDispatchDecorator.swift
//  RestaurantUI
//
//  Created by Gabriel on 29/03/24.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    
    let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}
