//
//  Podcast.swift
//  PodCast_Swift
//
//  Created by frizhub on 08/09/2023.
//

import Foundation

struct Podcast: Decodable {
    let trackName: String?
    let artistName: String?
    let artworkUrl600: String?
    let trackCount: Int?
    let feedUrl: String?
}
