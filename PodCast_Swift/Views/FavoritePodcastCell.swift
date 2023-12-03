//
//  FavoritePodcastCell.swift
//  PodCast_Swift
//
//  Created by frizhub on 06/11/2023.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var podcast: Podcast! {
        didSet {
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            imageView.sd_setImage(with: url)
        }
    }
    
    let imageView = UIImageView(image: UIImage(named: "podcast"))
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "Name Lable"
        artistNameLabel.text = "artist Name"
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, artistNameLabel])
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
