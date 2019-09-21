//
//  DetailCoordinator.swift
//  GitHub Search
//
//  Created by Sergey on 19/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class DetailCoordinator {
    
    private let navigationController: UINavigationController
    private var detailViewController: DetailViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Coordinator
extension DetailCoordinator: Coordinator {
    
    func start() {
        let vc = DetailViewController.instantinateFromStoryboard()
        detailViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
}
