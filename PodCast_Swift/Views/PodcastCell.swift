//
//  PodcastCell.swift
//  PodCast_Swift
//
//  Created by frizhub on 12/09/2023.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblEpisodeCount: UILabel!
    
    // MARK: - Properties
    var podcast: Podcast! {
        didSet {
            lblTrackName.text = podcast.trackName
            lblArtistName.text = podcast.artistName
            lblEpisodeCount.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            self.podcastImageView.sd_setImage(with: url)
        }
    }
    
}
