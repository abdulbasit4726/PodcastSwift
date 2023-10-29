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
    }
    
    // MARK: - Functions
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
