//
//  MainTabBarController.swift
//  PodCast_Swift
//
//  Created by frizhub on 08/09/2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        tabBar.unselectedItemTintColor = .gray
        view.backgroundColor = .white
        
        setupViewControllers()
    }
    
    // MARK: - Functions
    fileprivate func setupViewControllers() {
        viewControllers = [
            generateNavigationController(with: ViewController(), title: "Favorites", image: "play.circle.fill"),
            generateNavigationController(with: VCPodcastSearch(), title: "Search", image: "magnifyingglass"),
            generateNavigationController(with: ViewController(), title: "Downloads", image: "square.stack.fill")
        ]
    }
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
    }
}
