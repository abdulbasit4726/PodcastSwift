//
//  SearchResult.swift
//  PodCast_Swift
//
//  Created by frizhub on 09/09/2023.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
