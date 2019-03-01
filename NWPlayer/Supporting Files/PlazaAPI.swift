//
//  LastFM.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 12/31/18.
//  Copyright © 2018 Jon Alaniz. All rights reserved.
//

import Foundation
import UIKit

struct Stream: Codable {
    let maintenance: Bool?
    let playback: Song?
    let listeners: Int?
    
    init(maintenance: Bool? = nil, playback: Song? = nil, listeners: Int? = nil) {
        self.maintenance = maintenance
        self.playback = playback
        self.listeners = listeners
    }
    
    struct Song: Codable {
        let artist: String?
        let title: String?
        let album: String?
        let length: Int?
        let position: Int?
        let updated: Int?
        let artwork: String?
        let artwork_s: String?
        let likes: Int?
        let hates: Int?
        
        init(artist: String? = nil, title: String? = nil, album: String? = nil, length: Int? = nil, position: Int? = nil, updated: Int? = nil, artwork: String? = nil, artwork_s: String? = nil, likes: Int? = nil, hates: Int? = nil) {
            self.artist = artist
            self.title = title
            self.album = album
            self.length = length
            self.position = position
            self.updated = updated
            self.artwork = artwork
            self.artwork_s = artwork_s
            self.likes = likes
            self.hates = hates
        }
    }
}
