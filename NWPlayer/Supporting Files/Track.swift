//
//  Track.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 12/31/18.
//  Copyright © 2018 Jon Alaniz. All rights reserved.
//

import UIKit

struct Track {
    var artist: String?
    var name: String?
    var image: UIImage?
    var artistInfo: String?
    var space = " "
    var artworkURL: String?
    
    init(artist: String? = nil, name: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.artist = artist
        self.image = image
    }
    
    mutating func getSongInfo() -> String {
        if let name = name, let artist = artist {
            artistInfo = artist + space + name
            return artistInfo!
        } else {
            return "no song playing"
        }
        
    }
}

struct trackInfo: Codable {
    struct track: Codable {
        struct album: Codable {
            struct images: Codable {
                let text: String?
                let size: String?
            }
            let image: [images]
        }
        
    }
    
}
