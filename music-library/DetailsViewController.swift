//
//  DetailsViewController.swift
//  music-library
//
//  Created by hell 'n silence on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var artist: String = ""
    var name: String = ""
    var album: String = ""
    var year: Int = 0
    var info: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistLabel.text = artist
        nameLabel.text = name
        albumLabel.text = album
        yearLabel.text = String(describing: year)
        infoLabel.text = info
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
