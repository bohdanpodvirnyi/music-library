//
//  Record.swift
//  music-library
//
//  Created by hell 'n silence on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit

class Record {
    
    //Properties
    var artist: String
    var title: String
    var album: String
    var year: Int
    var info: String
    var id: Int
    
    
    //Initialization
    init?(artist: String, title: String, album: String, year: Int, info: String, id: Int)
    {
        
        self.artist = artist
        self.title = title
        self.album = album
        self.year = year
        self.info = info
        self.id = id
        
    }
}
