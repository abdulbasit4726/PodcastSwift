//
//  PlayersDetailView.swift
//  PodCast_Swift
//
//  Created by frizhub on 18/09/2023.
//

import UIKit
import AVKit

class PlayersDetailView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.transform = shrinkTransform
        }
    }
    
    // MARK: - Properties
    var episode: Episode! {
        didSet {
            lblTitle.text = episode.title
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            lblAuthor.text = episode.author
            playEpisode()
        }
    }
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    let shrinkTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    
    // MARK: - Initialization
        override func awakeFromNib() {
            super.awakeFromNib()
            
            observePlayerCurrentTime()
            observePlayerStartTime()
        }
    
    // MARK: - Functions
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem)
        player.play()
        btnPlay.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    fileprivate func transformImageToLarge() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.episodeImageView.transform = .identity
        }
    }
    
    fileprivate func transformImageToSmall() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1,options: .curveEaseIn) {
            self.episodeImageView.transform = self.shrinkTransform
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1,timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {  [weak self] time in
            self?.lblCurrentTime.text = time.formatTimeString()
            self?.lblTotalTime.text = self?.player.currentItem?.duration.formatTimeString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func observePlayerStartTime() {
        let time = CMTimeMake(value: 1, timescale: 1)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: .main) { [weak self] in
            self?.transformImageToLarge()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let seconds = CMTimeGetSeconds(player.currentTime())
        let totalSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        self.currentTimeSlider.value = Float(seconds / totalSeconds)
    }
    
    fileprivate func seekToTime(delta: Int64) {
        let seconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    // MARK: - IBActions
    @IBAction private func btnDismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction fileprivate func btnPlay(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            sender.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
            transformImageToLarge()
        } else {
            player.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
            transformImageToSmall()
        }
    }
    
    @IBAction fileprivate func handlePlaySlider(_ sender: UISlider) {
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        let seekTime = CMTimeMakeWithSeconds(Double(sender.value) * duration, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction fileprivate func handleVolumeSlider(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction fileprivate func btnRewind(_ sender: Any) {
        seekToTime(delta: -15)
    }
    
    @IBAction fileprivate func btnFastForward(_ sender: Any) {
        seekToTime(delta: 15)
    }
}
