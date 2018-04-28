//
//  Record.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit

class Record {
    
    //MARK: - Properties
    var artist: String
    var name: String
    var album: String
    var year: Int
    var info: String
    var id: Int
    
    //MARK: - Initialization
    init?(artist: String, name: String, album: String, year: Int, info: String, id: Int) {
        self.artist = artist
        self.name = name
        self.album = album
        self.year = year
        self.info = info
        self.id = id
    }
}
