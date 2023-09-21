//
//  EpisodeCellTableViewCell.swift
//  PodCast_Swift
//
//  Created by frizhub on 16/09/2023.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var lblPubDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    // MARK: - Properties
    var episode: Episode? {
        didSet {
            self.lblTitle.text = episode?.title
            self.lblDescription.text = episode?.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            self.lblPubDate.text = dateFormatter.string(from: episode?.pubDate ?? Date())
            
            let url = URL(string: episode?.imageUrl?.toSecureHTTP() ?? "")
            self.episodeImageView.sd_setImage(with: url)
        }
    }
}
