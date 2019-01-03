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
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        return label
    }()
    
    let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.style()
        label.text = ""
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
    
    let apiKey = LastFMAPI().apiKey
    
    let station = Station().stations
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var isHQ = true
    
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
        //getArtworkURL(withTrack: "Stronger", withArtist: "Kanye West")
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //********************************************************************
    //  MARK: - Functions
    //********************************************************************
    
    @objc private func playBtnPressed() {
        if player.isPlaying {
            player.pause()
            playBtn.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            player.play()
            playBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
    }
    
    @objc private func changeQuality() {
        if isHQ {
            isHQ = false
            qualityBtn.setTitle("low", for: .normal)
            qualityBtn.removeGlow()
            selectStation(quality: station["Low"]!)
        } else {
            isHQ = true
            qualityBtn.setTitle("high", for: .normal)
            qualityBtn.addGlow()
            selectStation(quality: station["High"]!)
        }
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
        
        trackLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
        nwLabel.text = state.description
        print(state.description)
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        track = Track(artist: artistName, name: trackName)
        getArtworkURL(withTrack: trackName ?? "", withArtist: artistName ?? "")
    }
    
    func radioPlayer(_ player: FRadioPlayer, itemDidChange url: URL?) {
        track = nil
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        
        updateNowPlaying(with: track)
    }
    
    func getURL(withTrack track: String, withArtist artist: String) -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "ws.audioscrobbler.com"
        components.path = "/2.0/"
        let queryItemType = URLQueryItem(name: "method", value: "track.getInfo")
        let queryItemKey = URLQueryItem(name: "api_key", value: apiKey)
        let queryItemArtist = URLQueryItem(name: "artist", value: artist)
        let queryItemTrack = URLQueryItem(name: "track", value: track)
        let queryItemFormat = URLQueryItem(name: "format", value: "json")
        components.queryItems = [queryItemType, queryItemKey, queryItemArtist, queryItemTrack,queryItemFormat]
        print(components.url)
        return components.url
    }
    
    func getArtworkURL(withTrack track: String, withArtist artist: String) {
        guard let url = getURL(withTrack: track, withArtist: artist) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let json = try JSON(data: data!)
                
                if let imageArray = json["track"]["album"]["image"].array {
                    let arrayCount = imageArray.count
                    let lastImage = imageArray[arrayCount - 1]
                    
                    if let artURL = lastImage["#text"].string {
                        // Check for Default Last FM Image
                        if artURL.range(of: "/noimage/") != nil {
                            self.artworkImageView.image = UIImage(named: "Album")
                            print("noimage")
                        } else {
                            if artURL == "" {
                                print("artURL is empty")
                                self.artworkImageView.image = UIImage(named: "Album")
                                return
                            } else {
                                self.downloadImage(with: URL(string: artURL)!)
                            }
                            
                        }
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            
        }.resume()
    }
    
    func downloadImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.artworkImageView.image = UIImage(data: data!)
            }
            
            }.resume()
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
