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
        imageView.loadGif(name: "1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.opacity = 0.5
        return imageView
    }()
    
    let gradient: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.compositingFilter = "overlayBlendMode"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
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
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        return label
    }()
    
    let albumLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.thin)
        return label
    }()
    
    let artworkImageView: SpringImageView = {
        let imageView = SpringImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupAnimation()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .white
        progressView.progressViewStyle = .bar
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    let trackLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.isUserInteractionEnabled = true
        label.setupAnimation()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        return label
    }()
    
    let qualityBtn: SpringButton = {
        let button = SpringButton()
        button.setTitle("HQ", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.style()
        button.addGlow()
        button.setupAnimation()
        button.delay = 0.2
        button.addTarget(self, action: #selector(changeQuality), for: .touchUpInside)
        return button
    }()
    
    let playBtn: SpringButton = {
        let button = SpringButton()
        button.setImage(UIImage(named: "pauseBtn"), for: .normal)
        button.style()
        button.setupAnimation()
        button.delay = 0.3
        button.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        return button
    }()
    
    let aboutBtn: SpringButton = {
        let button = SpringButton()
        button.setImage(UIImage(named: "about"), for: .normal)
        button.style()
        button.setupAnimation()
        button.delay = 0.4
        button.addTarget(self, action: #selector(segueToAboutScreen), for: .touchUpInside)
        return button
    }()
    
    //********************************************************************
    //  MARK: - Variables
    //********************************************************************
    
    let player: FRadioPlayer = FRadioPlayer.shared
    
    var station = Station().stations
    
    var stream = Stream() {
        didSet {
            self.artistLabel.text = stream.playback?.artist?.uppercased()
            self.trackLabel.text = stream.playback?.title
            self.albumLabel.text = stream.playback?.album?.uppercased()
            self.updateNowPlaying(with: stream)
            self.artistLabel.animation = "fadeInLeft"
            self.artistLabel.animate()
            self.albumLabel.animation = "fadeInLeft"
            self.albumLabel.animate()
            self.trackLabel.animation = "fadeInLeft"
            self.trackLabel.delay = 0.1
            self.trackLabel.animate()
        }
    }
    
    let gradients = ["gradient", "gradient1", "gradient3", "gradient4"]
    
    var backgrounds: [String] = []
    
    var backgroundSelection = 0
    
    let deviceHeight = UIScreen.main.bounds.height
    
    var isHQ = true
    
    lazy var progress = Progress(totalUnitCount: Int64(stream.playback?.length ?? 0))
    
    var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }
    
    //********************************************************************
    //  MARK: - Overrides
    //********************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i = 1
        while i <= 20 {
            backgrounds.append("\(i)")
            i += 1
        }
        
        player.delegate = self
        setupRemoteTransportControls()

        addSubviews()
        constrainUI()
        trackLabel.addGestureRecognizer(addGestureRecognizer())
        artworkImageView.addGestureRecognizer(addWallpaperChanger())
        gradient.addGestureRecognizer(addGradientChanger())
        initialAnimation()
        rotate()
        
        selectStation(quality: station["High"]!)
        //background.isHidden = true
        //gradient.isHidden = true
        //view.transform = CGAffineTransform(scaleX: -1, y: -1)
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
        let info = "\(stream.playback?.artist ?? "nothing") \(stream.playback?.title ?? "playing")"
        UIPasteboard.general.string = info
        nwLabel.text = "Song Info Copied"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nwLabel.text = "Nightwave Plaza"
        }
    }
    
    @objc private func changeWallpaper() {
        if backgroundSelection < backgrounds.count - 1 {
            backgroundSelection += 1
            SpringView.transition(with: self.background,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.background.loadGif(name: self.backgrounds[self.backgroundSelection]) },
                              completion: nil)
        } else {
            backgroundSelection = 0
            SpringView.transition(with: self.background,
                                  duration:0.5,
                                  options: .transitionCrossDissolve,
                                  animations: { self.background.loadGif(name: self.backgrounds[self.backgroundSelection]) },
                                  completion: nil)
        }
    }
    
    @objc private func segueToAboutScreen() {
        let page = AboutViewController()
        page.modalPresentationStyle = .overCurrentContext
        page.modalTransitionStyle = .crossDissolve
        present(page, animated: true, completion: nil)
    }
    
    private func rotate() {
        // uses Core Animation to spin the gradient in the background
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 40
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        gradient.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    @objc private func changeGradient() {
        let selection = Int.random(in : 0 ..< gradients.count)
        UIView.transition(with: self.gradient,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.gradient.image = UIImage(named: self.gradients[selection]) },
                          completion: nil)
    }
    
    @objc private func nextGradient() {
        let selection = Int.random(in : 0 ..< gradients.count)
        UIView.transition(with: self.gradient,
                          duration:0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.gradient.image = UIImage(named: self.gradients[selection]) },
                          completion: nil)
    }
    
    private func initialAnimation() {
        // animate in the UI
        icon.animate()
        nwLabel.animate()
        qualityBtn.animate()
        playBtn.animate()
        aboutBtn.animate()
    }
    
    private func addGestureRecognizer() -> UILongPressGestureRecognizer{
        let holdToSearch = UILongPressGestureRecognizer(target: self, action: #selector(copySongInfo))
        return holdToSearch
    }
    
    private func addWallpaperChanger() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.changeWallpaper))
        gesture.numberOfTapsRequired = 2
        return gesture
    }
    
    private func addGradientChanger() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.changeGradient))
        gesture.numberOfTapsRequired = 2
        return gesture
    }
    
    private func selectStation(quality key: URL) {
        player.radioURL = key
        updateNowPlaying(with: stream)
    }
    
    private func setProgressBar() {
        
        progress.totalUnitCount = Int64(stream.playback?.length ?? 0)
        progress.completedUnitCount = Int64(stream.playback?.position ?? 0)
        progressView.setProgress(Float(progress.fractionCompleted), animated: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            guard self.progress.isFinished == false else {
                timer.invalidate()
                print("finished")
                return
            }
            
            self.progress.completedUnitCount += 1
            
            let progressFloat = Float(self.progress.fractionCompleted)
            self.progressView.setProgress(progressFloat, animated: true)
            print(self.progress.totalUnitCount, self.progress.completedUnitCount)
            
        }
        
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
        view.addSubview(gradient)
        view.addSubview(icon)
        view.addSubview(nwLabel)
        view.addSubview(artistLabel)
        view.addSubview(albumLabel)
        view.addSubview(artworkImageView)
        view.addSubview(progressView)
        view.addSubview(trackLabel)
        view.addSubview(qualityBtn)
        view.addSubview(playBtn)
        view.addSubview(aboutBtn)
        
        addParallaxToView(vw: icon, amount: 10)
        addParallaxToView(vw: nwLabel, amount: 10)
        addParallaxToView(vw: artistLabel, amount: 20)
        addParallaxToView(vw: albumLabel, amount: 20)
        addParallaxToView(vw: artworkImageView, amount: 20)
        addParallaxToView(vw: progressView, amount: 20)
        addParallaxToView(vw: trackLabel, amount: 20)
        addParallaxToView(vw: qualityBtn, amount: 10)
        addParallaxToView(vw: playBtn, amount: 10)
        addParallaxToView(vw: aboutBtn, amount: 10)
    }
    
    private func constrainUI() {
        
        let topSpace: CGFloat = {
            var space = CGFloat()
            space = (deviceHeight / 5) / 2
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
        
        let buttonSize: CGFloat = {
            var size = CGFloat()
            if deviceHeight > 666 {
                size = 50
            } else {
                size = 40
            }
            return size
        }()
        
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        background.layer.opacity = 0.4
        
        if deviceHeight == 768 || deviceHeight == 834 || deviceHeight > 1000 {
            
            //var height: NSLayoutDimension
            var width: CGFloat
            
            if deviceHeight > UIScreen.main.bounds.width {
                width = UIScreen.main.bounds.width
            } else {
                width = deviceHeight
                print("landscape")
            }
            
            gradient.heightAnchor.constraint(equalToConstant: deviceHeight + 500).isActive = true
            gradient.widthAnchor.constraint(equalToConstant: deviceHeight + 500).isActive = true
            gradient.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gradient.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            artworkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
            artworkImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            artworkImageView.heightAnchor.constraint(equalToConstant: width / 3).isActive = true
            artworkImageView.widthAnchor.constraint(equalToConstant: width / 3).isActive = true
            
            progressView.leadingAnchor.constraint(equalTo: artworkImageView.leadingAnchor).isActive = true
            progressView.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 2).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            progressView.widthAnchor.constraint(equalTo: artworkImageView.widthAnchor).isActive = true
            
            icon.leadingAnchor.constraint(equalTo: artworkImageView.leadingAnchor).isActive = true
            icon.bottomAnchor.constraint(equalTo: artworkImageView.topAnchor, constant: -16).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            nwLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5).isActive = true
            nwLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            nwLabel.topAnchor.constraint(equalTo: icon.topAnchor).isActive = true
            nwLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            artistLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
            artistLabel.topAnchor.constraint(equalTo: artworkImageView.topAnchor, constant: 20).isActive = true
            artistLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 25).isActive = true
            
            albumLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            albumLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
            albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10).isActive = true
            albumLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 25).isActive = true
            
            trackLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
            trackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
            trackLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 25).isActive = true
            trackLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 10).isActive = true
            
            qualityBtn.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 25).isActive = true
            qualityBtn.bottomAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: -20).isActive = true
            qualityBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            qualityBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            qualityBtn.layer.cornerRadius = buttonSize / 2
            
            playBtn.bottomAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: -20).isActive = true
            playBtn.leadingAnchor.constraint(equalTo: qualityBtn.trailingAnchor, constant: 50).isActive = true
            playBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            playBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            playBtn.layer.cornerRadius = buttonSize / 2
            
            aboutBtn.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: 50).isActive = true
            aboutBtn.bottomAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: -20).isActive = true
            aboutBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            aboutBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            aboutBtn.layer.cornerRadius = buttonSize / 2
            
        } else {
            
            gradient.heightAnchor.constraint(equalToConstant: deviceHeight + 200).isActive = true
            gradient.widthAnchor.constraint(equalToConstant: deviceHeight + 200).isActive = true
            gradient.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gradient.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
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
            trackLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8).isActive = true
            
            playBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
            playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            playBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            playBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            playBtn.layer.cornerRadius = buttonSize / 2
            
            qualityBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
            qualityBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
            qualityBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            qualityBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            qualityBtn.layer.cornerRadius = buttonSize / 2
            
            aboutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
            aboutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
            aboutBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            aboutBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            aboutBtn.layer.cornerRadius = buttonSize / 2
        }
        
    }

}

extension NowPlayingController: FRadioPlayerDelegate {
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        nwLabel.text = state.description
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        
        // check to see if metadata is new or not
        if trackName != stream.playback?.title {
            // give the server some time to catch up with the stream
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.changeGradient()
                self.getSongInfo()
            })
        }
        
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
                print(error!)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let jsonData = try JSONDecoder().decode(Stream.self, from: data)
                DispatchQueue.main.async {
                    self.stream = jsonData
                    self.setProgressBar()
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
                let cacheImage = UIImage(data: data!)
                if cacheImage == self.artworkImageView.image {
                    return
                } else {
                    self.artworkImageView.image = cacheImage
                    self.artworkImageView.animation = "fadeInLeft"
                    self.artworkImageView.animate()
                }
                
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
