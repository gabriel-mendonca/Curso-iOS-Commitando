//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Gabriel on 13/03/24.
//

import UIKit
import RestaurantDomain

final class RestaurantListViewController: UITableViewController {
    
    private(set) var restaurantCollection: [RestaurantItemCellController] = []
    private let interactor: RestaurantListInteractorInput
    
    init(interactor: RestaurantListInteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(RestaurantItemCell.self, forCellReuseIdentifier: RestaurantItemCell.identifier)
        interactor.loadService()
    }
    
    @objc func refresh() {
        interactor.loadService()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantItemCell.identifier, for: indexPath) as? RestaurantItemCell else { return UITableViewCell() }
        
        restaurantCollection[indexPath.row].renderCell(cell)
        
        return cell
    }
}

extension RestaurantListViewController: RestaurantListPresenterOutput {
    func onLoadingChange(_ isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    func onRestaurantItemCell(_ items: [RestaurantItemCellController]) {
        restaurantCollection = items
        tableView.reloadData()
    }
    
    
}
