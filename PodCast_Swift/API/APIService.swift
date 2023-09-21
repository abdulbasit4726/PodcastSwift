//
//  APIService.swift
//  PodCast_Swift
//
//  Created by frizhub on 09/09/2023.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    static let shared = APIService()
    let baseUrl = "https://itunes.apple.com/search"
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl.toSecureHTTP()) else { return }
        FeedParser(URL: url).parseAsync { result in
            switch result {
            case .success(let feed):
                switch feed {
                case let .rss(feed):
                    completionHandler(feed.toEpisodes())
                    break
                default:
                    print("Found a feed...")
                }
            case .failure(let error):
                print("Failed to parse feed:", error)
            }
        }
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { dataResponse in
            if let error = dataResponse.error {
                print("Failed to contact requested search string: ", error)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeError {
                print("Failed to decode:", decodeError)
            }
        }
    }
}
