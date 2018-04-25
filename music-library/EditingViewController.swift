//
//  EditingViewController.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/25/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class EditingViewController: UIViewController {
    
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
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func blockingButton(_ sender: Any) {
        
        if artistField.text == "" || nameField.text == "" || albumField.text == "" || yearField.text == ""
        {
            button.isEnabled = false
        }
        else
        {
            button.isEnabled = true
        }
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let artistF = artistField.text!
        let nameF = nameField.text!
        let albumF = albumField.text!
        let yearF = Int(yearField.text!)!
        let infoF = infoField.text!
        
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
                    break
                    
                }
                
            }
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
        performSegue(withIdentifier: "toDetails", sender: self)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        artistField.text = artist
        nameField.text = name
        albumField.text = album
        yearField.text = String(describing: year)        
        infoField.text = info
        
        infoField.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        infoField.layer.borderWidth = 0.5
        infoField.layer.cornerRadius = 7
        infoField.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? DetailsViewController {
            
            destinationViewController.artist = artistField.text!
            destinationViewController.name = nameField.text!
            destinationViewController.album = albumField.text!
            destinationViewController.year = Int(yearField.text!)!
            destinationViewController.info = infoField.text!
            destinationViewController.id = editingId
            
        }
        
    }
    
}
