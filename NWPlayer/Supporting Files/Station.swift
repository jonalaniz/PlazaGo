//
//  station.swift
//  NWPlayer
//
//  Created by Jon Alaniz on 1/1/19.
//  Copyright © 2019 Jon Alaniz. All rights reserved.
//

import Foundation

import UIKit

struct Station {
    let stations: [String: URL] = [
        "High" : URL(string: "http://radio.plaza.one/mp3")!,
        "Low" : URL(string: "http://radio.plaza.one/mp3_96")!]
}
