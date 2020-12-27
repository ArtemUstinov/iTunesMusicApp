//
//  TabBarController.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 23.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - Private properties:
    private let searchVC = SearchViewController()
    private let libraryVC =
        LibraryViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - Override methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    //MARK: - Private methods:
    private func setupTabBar() {
        
        tabBar.barTintColor = .secondarySystemBackground
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        viewControllers = [
            generateViewController(rootViewController: searchVC,
                                   image: UIImage(systemName: "magnifyingglass"),
                                   title: "Search"),
            generateViewController(rootViewController: libraryVC,
                                   image: UIImage(systemName: "music.house"),
                                   title: "Library")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController,
                                        image: UIImage?,
                                        title: String) -> UIViewController {
        
        let navigationVC =
            UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
}
