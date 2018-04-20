//
//  AddingViewController.swift
//  music-library
//
//  Created by hell 'n silence on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class AddingViewController: UIViewController {
    
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var albumField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var infoField: UITextView!
    
    @IBAction func saveButton(_ sender: Any) {
        
        let artist = artistField.text!
        let name = nameField.text!
        let album = albumField.text!
        let year = Int(yearField.text!)!
        let info = infoField.text!
        
        let input = Record(artist: artist, title: name, album: album, year: year, info: info)!
        
        saveData(data: input)
        
        performSegue(withIdentifier: "toMainView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoField.text = ""
        infoField.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        infoField.layer.borderWidth = 0.5
        infoField.layer.cornerRadius = 7
        infoField.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveData(data: Record) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Data", in: managedContext)
        let records = NSManagedObject(entity: entity!, insertInto: managedContext)
        records.setValue(data.artist, forKey: "artist")
        records.setValue(data.title, forKey: "title")
        records.setValue(data.album, forKey: "album")
        records.setValue(data.year, forKey: "year")
        records.setValue(data.info, forKey: "info")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

}
