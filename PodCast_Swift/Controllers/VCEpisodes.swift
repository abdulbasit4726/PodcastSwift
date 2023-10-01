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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Functions
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) {[weak self] episodes in
            LoaderView.shared.hideLoader()
            self?.episodes = episodes
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return LoaderView.shared.showLoader()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
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
        let window = UIApplication.shared.currentWindow
        let playersDetailView = Bundle.main.loadNibNamed("PlayersDetailView", owner: self)?.first as! PlayersDetailView
        playersDetailView.episode = self.episodes[indexPath.row]
        playersDetailView.frame = self.view.frame
        window?.addSubview(playersDetailView)
    }
}
