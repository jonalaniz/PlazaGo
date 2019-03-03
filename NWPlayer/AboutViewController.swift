//
//  AboutViewController.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 3/3/19.
//  Copyright © 2019 Jon Alaniz. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let aboutBtn: SpringButton = {
        let button = SpringButton()
        button.setImage(UIImage(named: "about"), for: .normal)
        button.style()
        button.setupAnimation()
        button.delay = 0.4
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(aboutBtn)
        
        let deviceHeight = UIScreen.main.bounds.height
        
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
            if deviceHeight > 736 {
                size = 50
            } else {
                size = 40
            }
            return size
        }()
        
        aboutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        aboutBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace).isActive = true
        aboutBtn.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        aboutBtn.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        aboutBtn.layer.cornerRadius = buttonSize / 2
        
        
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

}
