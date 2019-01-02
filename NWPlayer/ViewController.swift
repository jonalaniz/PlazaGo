//
//  ViewController.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 12/30/18.
//  Copyright © 2018 Jon Alaniz. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingController: UIViewController {
    
    //********************************************************************
    //  MARK: - UI Elements
    //********************************************************************
    
    let background: UIImageView = {
        let imageView = UIImageView()
        imageView.loadGif(name: "bg4")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.4
        return imageView
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nwLabel: UILabel = {
        let label = UILabel()
        label.style()
        label.text = "Nightwave Plaza"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.style()
        label.text = "ACID.RAR"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        return label
    }()
    
    let artworkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Album"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.style()
        label.text = " として D E C O R 褪せる"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 28)
        return label
    }()
    
    let playBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pauseBtn"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        return button
    }()
    
    let qualityBtn: UIButton = {
        let button = UIButton()
        button.setTitle("high", for: .normal)
        button.style()
        button.addGlow()
        button.addTarget(self, action: #selector(changeQuality), for: .touchUpInside)
        return button
    }()
    
    //********************************************************************
    //  MARK: - Variables
    //********************************************************************
    
    let player: FRadioPlayer = FRadioPlayer.shared
    
    let station = Station().stations
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var track: Track? {
        didSet {
            artistLabel.text = track?.artist
            trackLabel.text = track?.name
            updateNowPlaying(with: track)
        }
    }
    
    //********************************************************************
    //  MARK: - Overrides
    //********************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.delegate = self
        setupRemoteTransportControls()
        addSubviews()
        constrainUI()
        
        selectStation(quality: station["High"]!)
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //********************************************************************
    //  MARK: - Functions
    //********************************************************************
    
    @objc private func playBtnPressed() {
        
    }
    
    @objc private func changeQuality() {
        
    }
    
    private func selectStation(quality key: URL) {
        player.radioURL = key
        updateNowPlaying(with: track)
    }
    
    private func addSubviews() {
        view.backgroundColor = .black
        view.addSubview(background)
        view.addSubview(icon)
        view.addSubview(nwLabel)
        view.addSubview(artistLabel)
        view.addSubview(artworkImageView)
        view.addSubview(trackLabel)
        view.addSubview(playBtn)
        view.addSubview(qualityBtn)
    }
    
    private func constrainUI() {
        
        let topSpace: CGFloat = {
            var space = CGFloat()
            if deviceHeight == 568 {
                space = 50
            } else if deviceHeight == 667 {
                space = 70
            } else {
                space = 90
            }
            return space
        }()
        
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        background.layer.opacity = 0.5
        
        icon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        icon.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        nwLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5).isActive = true
        nwLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nwLabel.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
        nwLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        artistLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        artistLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 8).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        artworkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        artworkImageView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10).isActive = true
        artworkImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        artworkImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        trackLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        trackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        trackLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 10).isActive = true
        
        playBtn.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 20).isActive = true
        playBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        qualityBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        qualityBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        qualityBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        qualityBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

}

extension NowPlayingController: FRadioPlayerDelegate {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print(state.description)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        track = Track(artist: artistName, name: trackName)
    }
    
    func radioPlayer(_ player: FRadioPlayer, itemDidChange url: URL?) {
        track = nil
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        
        // Please note that the following example is for demonstration purposes only, consider using asynchronous network calls to set the image from a URL.
        guard let artworkURL = artworkURL, let data = try? Data(contentsOf: artworkURL) else {
            artworkImageView.image = #imageLiteral(resourceName: "Album")
            return
        }
        track?.image = UIImage(data: data)
        artworkImageView.image = track?.image
        //artworkImageView.animate()
        updateNowPlaying(with: track)
    }
}

// MARK: - Remote Controls / Lock screen

extension NowPlayingController {
    
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.player.rate == 0.0 {
                self.player.play()
                return .success
            }
            return .commandFailed
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.player.rate == 1.0 {
                self.player.pause()
                return .success
            }
            return .commandFailed
        }
        
    }
    
    func updateNowPlaying(with track: Track?) {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        
        if let artist = track?.artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = track?.name ?? "Nothing Playing"
        
        if let image = track?.image ?? UIImage(named: "albumArt") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ -> UIImage in
                return image
            })
        }
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
