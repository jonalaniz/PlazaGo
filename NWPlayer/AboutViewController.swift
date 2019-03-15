//
//  AboutViewController.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 3/3/19.
//  Copyright © 2019 Jon Alaniz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let icon: SpringImageView = {
        let imageView = SpringImageView()
        imageView.image = UIImage(named: "aboutIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupAnimation()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nwLabel: SpringLabel = {
        let label = SpringLabel()
        label.setupAnimation()
        label.delay = 0.1
        label.style()
        label.text = "Plaza"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        return label
    }()
    
    let nwLabelGo: SpringLabel = {
        let label = SpringLabel()
        label.setupAnimation()
        label.delay = 0.1
        label.style()
        label.text = "Go"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.thin)
        return label
    }()
    
    let versionLabel: SpringLabel = {
        let label = SpringLabel()
        label.setupAnimation()
        label.delay = 0.2
        label.style()
        label.text = "Version 1.0.1"
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.thin)
        return label
    }()
    
    let aboutLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.delay = 0.3
        label.text = "NWPlayer is an unofficial streaming client for Nightwave Plaza."
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let plazaLabel: SpringLabel = {
        let label = SpringLabel()
        label.setupAnimation()
        label.delay = 0.4
        label.style()
        label.text = "Nightwave Plaza"
        label.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let aboutPlazaLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.delay = 0.5
        label.text = "Nightwave Plaza is a free 24/7 online vaporwave radio station. The broadcast also includes some future funk and experimental genres. We hope you enjoy."
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let visitBtn: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Visit Nightwave Plaza", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.animation = "fadeInLeft"
        button.curve = "easeOut"
        button.velocity = 0.1
        button.force = 0.1
        button.delay = 0.6
        button.addTarget(self, action: #selector(visitPlaza), for: .touchUpInside)
        return button
    }()
    
    let aboutBtn: SpringButton = {
        let button = SpringButton()
        button.setImage(UIImage(named: "about"), for: .normal)
        button.style()
        button.addGlow()
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()
    
    let hintLabel: SpringLabel = {
        let label = SpringLabel()
        label.style()
        label.setupAnimation()
        label.delay = 0.7
        label.text = "Hint: Double-tap the album art to change wallpaper"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.alpha = 0.1
        return label
    }()
    
    let deviceHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        visualEffectView.frame = view.bounds
        
        view.addSubview(visualEffectView)
        view.addSubview(icon)
        view.addSubview(nwLabel)
        view.addSubview(nwLabelGo)
        view.addSubview(versionLabel)
        view.addSubview(aboutLabel)
        view.addSubview(plazaLabel)
        view.addSubview(aboutPlazaLabel)
        view.addSubview(visitBtn)
        view.addSubview(hintLabel)
        view.addSubview(aboutBtn)
        
        constrainUI()
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        animateIn()
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func visitPlaza() {
        if let url = URL(string: "https://plaza.one") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    private func animateIn() {
        icon.animate()
        nwLabel.animate()
        nwLabelGo.animate()
        versionLabel.animate()
        aboutLabel.animate()
        plazaLabel.animate()
        aboutPlazaLabel.animate()
        hintLabel.animate()
        visitBtn.animate()
    }
    
    private func constrainUI() {
        let topSpace: CGFloat = {
            var space = CGFloat()
            space = (deviceHeight / 10)
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
        
        if deviceHeight == 768 || deviceHeight == 834 || deviceHeight > 1000 {
            
            //var height: NSLayoutDimension
            var width: CGFloat
            
            if deviceHeight > UIScreen.main.bounds.width {
                width = UIScreen.main.bounds.width
            } else {
                width = deviceHeight
                print("landscape")
            }
            
            icon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: topSpace).isActive = true
            icon.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace).isActive = true
            aboutBtn.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: (width / 6) - 20).isActive = true
            aboutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 325 + (width / 3)).isActive = true
        } else {
            icon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
            icon.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace).isActive = true
            aboutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
            aboutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
        }
        
        icon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nwLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        nwLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nwLabel.widthAnchor.constraint(equalToConstant: 103).isActive = true
        nwLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 15).isActive = true
        
        nwLabelGo.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        nwLabelGo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nwLabelGo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nwLabelGo.leadingAnchor.constraint(equalTo: nwLabel.trailingAnchor).isActive = true
        
        versionLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        versionLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        versionLabel.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10).isActive = true
        aboutLabel.heightAnchor.constraint(equalToConstant: 29).isActive = true
        aboutLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
        
        plazaLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8).isActive = true
        plazaLabel.heightAnchor.constraint(equalToConstant: 96).isActive = true
        plazaLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        plazaLabel.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
        
        aboutPlazaLabel.topAnchor.constraint(equalTo: plazaLabel.bottomAnchor, constant: 8).isActive = true
        aboutPlazaLabel.heightAnchor.constraint(equalToConstant: 74).isActive = true
        aboutPlazaLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        aboutPlazaLabel.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
        
        visitBtn.topAnchor.constraint(equalTo: aboutPlazaLabel.bottomAnchor, constant: 16).isActive = true
        visitBtn.heightAnchor.constraint(equalToConstant: 38).isActive = true
        visitBtn.widthAnchor.constraint(equalToConstant: 194).isActive = true
        visitBtn.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
        
        hintLabel.topAnchor.constraint(equalTo: visitBtn.bottomAnchor, constant: 16).isActive = true
        hintLabel.heightAnchor.constraint(equalToConstant: 29).isActive = true
        hintLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        hintLabel.leadingAnchor.constraint(equalTo: nwLabel.leadingAnchor).isActive = true
    
        aboutBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        aboutBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        aboutBtn.layer.cornerRadius = buttonSize / 2
    }

}
