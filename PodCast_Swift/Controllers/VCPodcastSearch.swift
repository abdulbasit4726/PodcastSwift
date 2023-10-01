//
//  VCPodcastSearch.swift
//  PodCast_Swift
//
//  Created by frizhub on 08/09/2023.
//

import UIKit
import Alamofire

class VCPodcastSearch: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    var podcasts: [Podcast] = []
    let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Setting Search Bar
        setupSearchBar()
        
        // TODO: Setting TableView
        setupTableView()
    }
    
    // MARK: - Functions
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchBar(searchController.searchBar, textDidChange: "Voong")
    }
    
    // MARK: - SearchBar delegate function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            APIService.shared.fetchPodcasts(searchText: searchText) { podcasts in
                LoaderView.shared.hideLoader()
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - TableView Delegate Functions
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No podcasts to show"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        
        if podcasts.count == 0 {
            return label
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if podcasts.count == 0 {
            return 250
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return LoaderView.shared.showLoader()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 122
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VCEpisodes()
        vc.podcast = self.podcasts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
