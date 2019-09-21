//
//  BookmarksCoordinator.swift
//  GitHub Search
//
//  Created by Sergey on 19/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class BookmarksCoordinator {
    
    private let navigationController: UINavigationController
    private var bookmarksViewController: BookmarksViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Coordinator
extension BookmarksCoordinator: Coordinator {
    
    func start() {
        let vc = BookmarksViewController.instantinateFromStoryboard()
        bookmarksViewController = vc
        navigationController.pushViewController(vc, animated: true)
    }
}

