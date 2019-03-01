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
        imageView.layer.opacity = 0.5
        return imageView
    }()
    
    let icon: SpringImageView = {
        let imageView = SpringImageView(image: UIImage(named: "icon"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupAnimation()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nwLabel: SpringLabel = {
        let label = SpringLabel()
        label.setupAnimation()
        label.delay = 0.1
        label.style()
        label.text = "Nightwave Plaza"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        return label
    }()
    
    let artistLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        return label
    }()
    
    let albumLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 26)
        return label
    }()
    
    let artworkImageView: SpringImageView = {
        let imageView = SpringImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupAnimation()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let trackLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.isUserInteractionEnabled = true
        label.setupAnimation()
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 28)
        return label
    }()
    
    let playBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pauseBtn"), for: .normal)
        button.style()
        button.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        return button
    }()
    
    let qualityBtn: UIButton = {
        let button = UIButton()
        button.setTitle("HQ", for: .normal)
        button.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.style()
        button.addGlow()
        button.addTarget(self, action: #selector(changeQuality), for: .touchUpInside)
        return button
    }()
    
    let aboutBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "about"), for: .normal)
        button.style()
        button.addTarget(self, action: #selector(changeQuality), for: .touchUpInside)
        return button
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .white
        progressView.progressViewStyle = .bar
        progressView.progress = 0.5
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    //********************************************************************
    //  MARK: - Variables
    //********************************************************************
    
    let player: FRadioPlayer = FRadioPlayer.shared
    
    var station = Station().stations
    
    var stream = Stream() {
        didSet {
            artistLabel.text = stream.playback?.artist?.uppercased()
            trackLabel.text = stream.playback?.title
            albumLabel.text = stream.playback?.album?.uppercased()
            updateNowPlaying(with: stream)
            self.artistLabel.animation = "fadeInLeft"
            self.artistLabel.animate()
            self.albumLabel.animation = "fadeInLeft"
            self.albumLabel.animate()
            self.trackLabel.animation = "fadeInLeft"
            self.trackLabel.delay = 0.1
            self.trackLabel.animate()
        }
    }
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var isHQ = true
    
    //********************************************************************
    //  MARK: - Overrides
    //********************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // NotificationCenter.default.addObserver(self, selector:#selector(NowPlayingController.getSongInfo), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        player.delegate = self
        setupRemoteTransportControls()
        addSubviews()
        constrainUI()
        trackLabel.addGestureRecognizer(addGestureRecognizer())
        
        icon.animate()
        nwLabel.animate()
        
        selectStation(quality: station["High"]!)
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //********************************************************************
    //  MARK: - Functions
    //********************************************************************
    
    @objc private func playBtnPressed() {
        if player.isPlaying {
            player.stop()
            playBtn.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            player.play()
            playBtn.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
    }
    
    @objc private func changeQuality() {
        if isHQ {
            isHQ = false
            qualityBtn.setTitle("LQ", for: .normal)
            qualityBtn.removeGlow()
            selectStation(quality: station["Low"]!)
        } else {
            isHQ = true
            qualityBtn.setTitle("HQ", for: .normal)
            qualityBtn.addGlow()
            selectStation(quality: station["High"]!)
        }
    }
    
    @objc private func copySongInfo() {
        let info = "\(stream.playback?.artist!) \(stream.playback?.title!)"
        UIPasteboard.general.string = info
        nwLabel.text = "Song Info Copied"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nwLabel.text = "Nightwave Plaza"

        }
    }
    
    private func addGestureRecognizer() -> UILongPressGestureRecognizer{
        let holdToSearch = UILongPressGestureRecognizer(target: self, action: #selector(copySongInfo))
        return holdToSearch
    }
    
    private func selectStation(quality key: URL) {
        player.radioURL = key
        updateNowPlaying(with: stream)
    }
    
    func addParallaxToView(vw: UIView, amount: Int) {
        let amount = amount
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    private func addSubviews() {
        view.backgroundColor = .black
        view.addSubview(background)
        view.addSubview(icon)
        view.addSubview(nwLabel)
        view.addSubview(artistLabel)
        view.addSubview(albumLabel)
        view.addSubview(artworkImageView)
        view.addSubview(progressView)
        view.addSubview(trackLabel)
        view.addSubview(playBtn)
        view.addSubview(qualityBtn)
        view.addSubview(aboutBtn)
        
        addParallaxToView(vw: icon, amount: 10)
        addParallaxToView(vw: nwLabel, amount: 10)
        addParallaxToView(vw: artistLabel, amount: 20)
        addParallaxToView(vw: albumLabel, amount: 20)
        addParallaxToView(vw: artworkImageView, amount: 20)
        addParallaxToView(vw: progressView, amount: 20)
        addParallaxToView(vw: trackLabel, amount: 20)
        addParallaxToView(vw: playBtn, amount: 10)
        addParallaxToView(vw: qualityBtn, amount: 10)
        addParallaxToView(vw: aboutBtn, amount: 10)
    }
    
    private func constrainUI() {
        
        let topSpace: CGFloat = {
            var space = CGFloat()
            space = (deviceHeight / 5) / 2
//            if deviceHeight == 568 {
//                space = 35
//            } else if deviceHeight == 667 {
//                space = 50
//            } else {
//                space = 60
//            }
            return space
        }()
        
        let bottomSpace: CGFloat = {
            var space = CGFloat()
            if deviceHeight > 736 {
                space = -50
            } else {
                space = -25
            }
            return space
        }()
        
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        background.layer.opacity = 0.4
        
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
        artistLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 15).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        albumLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        albumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 2).isActive = true
        albumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        
        artworkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        artworkImageView.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 8).isActive = true
        artworkImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.38).isActive = true
        artworkImageView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.38).isActive = true
        
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        progressView.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        progressView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.38).isActive = true
        
        trackLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        trackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        trackLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 8).isActive = true
        
        playBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        qualityBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        qualityBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
        qualityBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        qualityBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        aboutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        aboutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
        aboutBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        aboutBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

}

extension NowPlayingController: FRadioPlayerDelegate {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        nwLabel.text = state.description
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        
        // give the server some time to catch up with the stream
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.getSongInfo()
            })
        
    }
    
    func radioPlayer(_ player: FRadioPlayer, itemDidChange url: URL?) {
        //track = nil
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        updateNowPlaying(with: stream)
    }
    
    @objc func getSongInfo() {
        let url = URL(string: "https://api.plaza.one/status")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let jsonData = try JSONDecoder().decode(Stream.self, from: data)
                DispatchQueue.main.async {
                    self.stream = jsonData
                    self.getArtworkURL()
                }
                
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
            
            }.resume()
    }
    
    func getArtworkURL() {
        var components = URLComponents()
        let artworkURL = stream.playback?.artwork
        components.scheme = "https"
        components.host = "api.plaza.one"
        components.path = "/\(artworkURL ?? "/ass")"
        
        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.downloadImage(with: url)
            
        }.resume()
    }
    
    func downloadImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                DispatchQueue.main.async {
                    self.artworkImageView.image = UIImage(named: "Album")
                    self.artworkImageView.animation = "fadeInLeft"
                    self.artworkImageView.animate()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.artworkImageView.image = UIImage(data: data!)
                self.artworkImageView.animation = "fadeInLeft"
                self.artworkImageView.animate()
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
    
    func updateNowPlaying(with stream: Stream?) {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        
        if let artist = stream?.playback?.artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = stream?.playback?.title ?? "Nothing Playing"
        
        if let image = artworkImageView.image {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ -> UIImage in
                    return image
                })
        }
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
