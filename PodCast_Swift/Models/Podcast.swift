//
//  Podcast.swift
//  PodCast_Swift
//
//  Created by frizhub on 08/09/2023.
//

import Foundation

class Podcast: NSObject, Codable {
    
    let trackName: String?
    let artistName: String?
    let artworkUrl600: String?
    let trackCount: Int?
    let feedUrl: String?
    
//    func encode(with coder: NSCoder) {
//        coder.encode(trackName ?? "", forKey: "trackNameKey")
//        coder.encode(artistName ?? "", forKey: "artistNameKey")
//        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
//        coder.encode(trackCount ?? 0, forKey: "trackCountKey")
//        coder.encode(feedUrl ?? "", forKey: "feedUrlKey")
//    }
//
//    required init?(coder: NSCoder) {
//        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
//        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
//        self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
//        self.trackCount = coder.decodeInteger(forKey: "trackCountKey")
//        self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String
//    }
}


//enum CodingKeys: CodingKey {
//    case trackName
//    case artistName
//    case artworkUrl600
//    case trackCount
//    case feedUrl
//}
//
//required init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    self.trackName = try container.decodeIfPresent(String.self, forKey: .trackName)
//    self.artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
//    self.artworkUrl600 = try container.decodeIfPresent(String.self, forKey: .artworkUrl600)
//    self.trackCount = try container.decodeIfPresent(Int.self, forKey: .trackCount)
//    self.feedUrl = try container.decodeIfPresent(String.self, forKey: .feedUrl)
//}
