//
//  RestaurantItemCellController.swift
//  RestaurantUI
//
//  Created by Gabriel on 28/03/24.
//

import UIKit
import RestaurantDomain

final class RestaurantItemCellController {
    let viewModel: RestaurantItem
    
    init(viewModel: RestaurantItem) {
        self.viewModel = viewModel
    }
    
    func renderCell(_ cell: RestaurantItemCell) {
        cell.title.text = viewModel.name
        cell.location.text = viewModel.location
        cell.distance.text = viewModel.distanceToString
        cell.parasols.text = viewModel.parasolsToString
        cell.colletionOfRating.enumerated().forEach { (index, image) in
            let systemName = index < viewModel.ratings ? "star.fill" : "star"
            image.image = UIImage(systemName: systemName)
        }
    }
}

private extension RestaurantItem {
    
    var parasolsToString: String {
        return "Guarda-sois: \(parasols)"
    }
    
    var distanceToString: String {
        return "Distância: \(distance)m"
    }
}
