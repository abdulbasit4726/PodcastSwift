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
    @IBOutlet weak var mainPlayerStackView: UIStackView!
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var lblMiniPlayerTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var miniPlayerImageView: UIImageView! {
        didSet {
            miniPlayerImageView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.transform = shrinkTransform
        }
    }
    @IBOutlet weak var btnMiniPlayerPause: UIButton! {
        didSet {
            btnMiniPlayerPause.imageView?.contentMode  = .scaleAspectFit
            btnMiniPlayerPause.transform = shrinkTransform
            btnMiniPlayerPause.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnMiniPlayerFastForward: UIButton! {
        didSet {
            btnMiniPlayerFastForward.transform = shrinkTransform
            btnMiniPlayerFastForward.addTarget(self, action: #selector(handleMiniFastForward), for: .touchUpInside)
        }
    }
    
    // MARK: - Properties
    var episode: Episode! {
        didSet {
            lblMiniPlayerTitle.text = episode.title
            lblTitle.text = episode.title
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "podcast"))
            miniPlayerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "podcast"))
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
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observePlayerCurrentTime()
        observePlayerStartTime()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMaximizePan(gesture:)))
        miniPlayerView.addGestureRecognizer(panGesture)
        mainPlayerStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMinimizePan(gesture:))))
    }
    
    static func initFromNib() -> PlayersDetailView {
        Bundle.main.loadNibNamed("PlayersDetailView", owner: self)?.first as! PlayersDetailView
    }
    
    // MARK: - Functions
    fileprivate func playEpisode() {
        guard let url = URL(string: episode.streamUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem)
        player.play()
        btnPlay.setImage(UIImage(named: "pause"), for: .normal)
        btnMiniPlayerPause.setImage(UIImage(named: "pause"), for: .normal)
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
            DispatchQueue.main.async {
                self?.transformImageToLarge()
            }
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
    
    fileprivate func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.mainPlayerStackView.alpha = -translation.y / 200
    }
    
    fileprivate func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetailView(episode: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.mainPlayerStackView.alpha = 0
            }
        }
    }
    
    // MARK: - @Objc
    @objc fileprivate func handleMiniFastForward() {
        seekToTime(delta: 15)
    }
    
    @objc func handleTapOnView() {
        UIApplication.mainTabBarController()?.maximizePlayerDetailView(episode: nil)
    }
    
    @objc func handleMaximizePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    @objc fileprivate func handleMinimizePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: self.superview)
            mainPlayerStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
                self.mainPlayerStackView.transform = .identity
                
                if translation.y > 100 {
                    UIApplication.mainTabBarController()?.minimizePlayerDetailView()
                }
                
            }
        }
    }
    
    @objc fileprivate func handlePlayPause() {
        if player.timeControlStatus == .paused {
            btnPlay.setImage(UIImage(named: "pause"), for: .normal)
            btnMiniPlayerPause.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
            transformImageToLarge()
        } else {
            player.pause()
            btnPlay.setImage(UIImage(named: "play"), for: .normal)
            btnMiniPlayerPause.setImage(UIImage(named: "play"), for: .normal)
            transformImageToSmall()
        }
    }
    
    // MARK: - IBActions
    @IBAction private func btnDismiss(_ sender: UIButton) {
        UIApplication.mainTabBarController()?.minimizePlayerDetailView()
    }
    
    @IBAction fileprivate func btnPlay(_ sender: UIButton) {
       handlePlayPause()
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
