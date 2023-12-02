//
//  MainTabBarController.swift
//  PodCast_Swift
//
//  Created by frizhub on 08/09/2023.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    let playerDetailView = PlayersDetailView.initFromNib()
    var maximizeTopAnchor: NSLayoutConstraint!
    var minimizeTopAnchor: NSLayoutConstraint!
    var bottomAnchor: NSLayoutConstraint!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        tabBar.unselectedItemTintColor = .gray
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        
        setupViewControllers()
        setupPlayerDetailView()
    }
    
    // MARK: - Functions
    fileprivate func setupPlayerDetailView() {
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizeTopAnchor = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizeTopAnchor.isActive = true
        
        minimizeTopAnchor = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomAnchor = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchor.isActive = true
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func minimizePlayerDetailView() {
        maximizeTopAnchor.isActive = false
        bottomAnchor.constant = view.frame.height
        minimizeTopAnchor.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.playerDetailView.mainPlayerStackView.alpha = 0
            self.playerDetailView.miniPlayerView.alpha = 1
        }
    }
    
    func maximizePlayerDetailView(episode: Episode?, playListEpisodes: [Episode] = []) {
        minimizeTopAnchor.isActive = false
        maximizeTopAnchor.isActive = true
        maximizeTopAnchor.constant = 0
        bottomAnchor.constant = 0
        
        if episode != nil {
            playerDetailView.player.replaceCurrentItem(with: nil)
            playerDetailView.episode = episode
        }
        
        playerDetailView.playListEpisodes = playListEpisodes
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.playerDetailView.mainPlayerStackView.alpha = 1
            self.playerDetailView.miniPlayerView.alpha = 0
        }
    }
    
    fileprivate func setupViewControllers() {
        viewControllers = [
            generateNavigationController(with: VCFavorites(collectionViewLayout: UICollectionViewFlowLayout()), title: "Favorites", image: "play.circle.fill"),
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
