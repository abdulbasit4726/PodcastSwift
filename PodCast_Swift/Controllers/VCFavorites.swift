//
//  VCFavorites.swift
//  PodCast_Swift
//
//  Created by frizhub on 01/11/2023.
//

import UIKit

class VCFavorites: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // MARK: - Properties
    fileprivate var cellId = "cellId"
    
    var savedPodcasts: [Podcast] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedPodcasts = UserDefaults.standard.fetchSavedPodcasts()
        collectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
    }
    
    // MARK: - @objc functions
    @objc fileprivate func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
        
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            
            self.savedPodcasts.remove(at: selectedIndexPath.item)
            self.collectionView.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.savePodcast(podcasts: self.savedPodcasts)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    // MARK: - CollecitionView Delegates
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedPodcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
        cell.podcast = savedPodcasts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vcEpisode = VCEpisodes()
        vcEpisode.podcast = savedPodcasts[indexPath.item]
        self.navigationController?.pushViewController(vcEpisode, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    // MARK: - Functions
}
