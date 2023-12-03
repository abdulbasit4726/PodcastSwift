//
//  UserDefaults.swift
//  PodCast_Swift
//
//  Created by frizhub on 02/12/2023.
//

import Foundation

extension UserDefaults  {
    enum Keys {
        static let FAVORITES_KEY = "FAVORITES_KEY"
    }
    
    func fetchSavedPodcasts() -> [Podcast] {
        guard let data = self.data(forKey: Keys.FAVORITES_KEY) else { return []}
        let decoder = JSONDecoder()
        let podcasts = try? decoder.decode([Podcast].self, from: data)
        return podcasts ?? []
    }
    
    func savePodcast(podcasts: [Podcast]) {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(podcasts)
        self.set(encoded, forKey: Keys.FAVORITES_KEY)
    }
    
    func isContainsPodcast(podcast: Podcast) -> Bool {
        let savedPodcasts = fetchSavedPodcasts()
        return savedPodcasts.contains(where: {$0.trackName == podcast.trackName && $0.artistName == podcast.artistName})
    }
}
