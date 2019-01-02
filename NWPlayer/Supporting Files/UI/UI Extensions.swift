//
//  UI Extensions.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 1/1/19.
//  Copyright © 2019 Jon Alaniz. All rights reserved.
//

import UIKit

extension UILabel {
    func style() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .white
    }
}

extension UIButton {
    func style() {
        let layer = self.layer
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addGlow() {
        let layer = self.layer
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 70
        layer.shadowRadius = 10
    }
    
    func removeGlow() {
        let layer = self.layer
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
}
