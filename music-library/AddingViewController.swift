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
    
    var artist: String = ""
    var name: String = ""
    var album: String = ""
    var year: Int = 0
    var info: String = ""
    var id: Int = 0
    
    var edit: Bool = false
    
    var records: [NSManagedObject] = []
    
    var editingId: Int = 0
    
    @IBAction func saveButton(_ sender: Any) {
        
        let artistF = artistField.text!
        let nameF = nameField.text!
        let albumF = albumField.text!
        let yearF = Int(yearField.text!)!
        let infoF = infoField.text!
        
        if edit {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Data")
            do {
                records = try managedContext.fetch(fetchRequest)
                
                for record in records {
                    
                    if (record.value(forKey: "id") as! Int == editingId) {
                    
                        record.setValue(artistF, forKey: "artist")
                        record.setValue(nameF, forKey: "title")
                        record.setValue(albumF, forKey: "album")
                        record.setValue(yearF, forKey: "year")
                        record.setValue(infoF, forKey: "info")
                        
                    }
                    
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            performSegue(withIdentifier: "toDetails", sender: self)
            
        } else {
            
            
            id = UserDefaults.standard.integer(forKey: "id")
            
            let data = Record(artist: artistF, title: nameF, album: albumF, year: yearF, info: infoF, id: id)!
            
            saveData(data: data)
            
            performSegue(withIdentifier: "toMainView", sender: self)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistField.text = artist
        nameField.text = name
        albumField.text = album
        yearField.text = String(describing: year)
        infoField.text = info
        
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
        records.setValue(data.id, forKey: "id")
        
        UserDefaults.standard.setValue(id+1, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

}
