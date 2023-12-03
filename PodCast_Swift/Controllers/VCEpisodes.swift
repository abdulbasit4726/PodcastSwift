//
//  VCEpisodes.swift
//  PodCast_Swift
//
//  Created by frizhub on 15/09/2023.
//

import UIKit
import FeedKit

class VCEpisodes: UITableViewController {
    
    // MARK: - Properties
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    var episodes: [Episode] = []
    private let cellId = "cellId"
    var isShowLoading = false
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setNavBarButtons()
    }
    
    // MARK: - Functions
    fileprivate func setNavBarButtons() {
        guard let podcast = podcast else { return }
        let isContainsPodcast = UserDefaults.standard.isContainsPodcast(podcast: podcast)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: isContainsPodcast ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(handleFavorite))
        
    }
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func showLoader() {
        self.isShowLoading = true
        self.episodes.removeAll()
        self.tableView.reloadData()
    }
    
    func hideLoader() {
        self.isShowLoading = false
        LoaderView.shared.hideLoader()
        self.tableView.reloadData()
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        self.showLoader()
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) {[weak self] episodes in
            DispatchQueue.main.async {
                self?.episodes = episodes
                self?.hideLoader()
            }
        }
    }
    
    // MARK: - @objc Methods
    @objc fileprivate func handleFavorite() {
        guard let podcast = podcast else { return }
        var savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        let isContainsPodcast = UserDefaults.standard.isContainsPodcast(podcast: podcast)
        
        if isContainsPodcast {
            guard let index = savedPodcasts.firstIndex(where: {$0.trackName == podcast.trackName && $0.artistName == podcast.artistName}) else { return }
            savedPodcasts.remove(at: index)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            savedPodcasts.append(podcast)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
        }
        UserDefaults.standard.savePodcast(podcasts: savedPodcasts)
    }
    
    // MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return isShowLoading ? LoaderView.shared.showLoader() : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return isShowLoading ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        for (scene) in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                guard let window = scene as? UIWindowScene else { return }
                let mainTabBarController = window.keyWindow?.rootViewController as? MainTabBarController
                mainTabBarController?.maximizePlayerDetailView(episode: episode, playListEpisodes: self.episodes)
            }
        }
    }
}
