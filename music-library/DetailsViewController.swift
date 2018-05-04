//
//  DetailsViewController.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var records: [NSManagedObject] = []
    
    //MARK: - Action for Edit button
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "toEditRecord", sender: self)
    }
    
    //MARK: - Properties
    var artist: String = ""
    var name: String = ""
    var album: String = ""
    var year: Int = 0
    var info: String = ""
    var id: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Initializing labels
        artistLabel.text = artist
        nameLabel.text = name
        albumLabel.text = album
        yearLabel.text = String(describing: year)
        infoLabel.text = info
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: - Segue to EditingViewController
        if let destinationViewController = segue.destination as? EditingViewController {
            destinationViewController.artist = artistLabel.text!
            destinationViewController.name = nameLabel.text!
            destinationViewController.album = albumLabel.text!
            destinationViewController.year = Int(yearLabel.text!)!
            destinationViewController.info = infoLabel.text!
            destinationViewController.edit = true
            destinationViewController.editingId = id
        }
    }
}
