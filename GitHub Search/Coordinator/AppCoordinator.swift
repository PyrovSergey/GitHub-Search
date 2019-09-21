//
//  AppCoordinator.swift
//  GitHub Search
//
//  Created by Sergey on 19/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    let window: UIWindow
    let rootViewController: UITabBarController
    
    let searchCoordinator: SearchCoordinator
    let bookmarksCoordinator: BookmarksCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UITabBarController()
        
        let searchRootViewController = UINavigationController()
        searchRootViewController.tabBarItem = UITabBarItem(title: "Search",
                                                           image: UIImage(named: "search"),
                                                           selectedImage: nil)
        
        let bookmarksRootViewController = UINavigationController()
        bookmarksRootViewController.tabBarItem = UITabBarItem(title: "Bookmarks",
                                                              image: UIImage(named: "bookmarks"),
                                                              selectedImage: nil)
        
        rootViewController.viewControllers = [searchRootViewController, bookmarksRootViewController]
        
        searchCoordinator = SearchCoordinator(navigationController: searchRootViewController)
        bookmarksCoordinator = BookmarksCoordinator(navigationController: bookmarksRootViewController)
    }
}

// MARK: - Coordinator
extension AppCoordinator: Coordinator {
    
    func start() {
        window.rootViewController = rootViewController
        searchCoordinator.start()
        bookmarksCoordinator.start()
        window.makeKeyAndVisible()
    }
}
