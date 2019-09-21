//
//  SearchCoordinator.swift
//  GitHub Search
//
//  Created by Sergey on 19/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class SearchCoordinator {
    
    private let navigationController: UINavigationController
    private var searchViewController: SearchViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Coordinator
extension SearchCoordinator: Coordinator {
    
    func start() {
        let vc = SearchViewController.instantinateFromStoryboard()
        searchViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
}
