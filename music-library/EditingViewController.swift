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
    @IBOutlet weak var button: UIButton!
    
    //MARK: - Properties
    var artist: String = ""
    var name: String = ""
    var album: String = ""
    var year: Int = 0
    var info: String = ""
    var id: Int = 0
    var edit: Bool = false
    var records: [NSManagedObject] = []
    var editingId: Int = 0
    
    //MARK: - Disabling Save button if any text field is empty
    @IBAction func blockingButton(_ sender: Any) {
        if artistField.text == "" || nameField.text == "" || albumField.text == "" || yearField.text == "" {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    //MARK: - Action for Save button
    @IBAction func saveButton(_ sender: Any) {
        artist = artistField.text!
        name = nameField.text!
        album = albumField.text!
        if (Int(yearField.text!) != nil) {
            year = Int(yearField.text!)!
        } else {
            yearField.layer.borderColor = UIColor.red.cgColor
            infoField.layer.borderWidth = 0.5
            infoField.layer.cornerRadius = 7
            infoField.clipsToBounds = true
            self.showAlert(title: "Error", message: "You cannot use letters in the field \"Year\"")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Data")
        do {
            records = try managedContext.fetch(fetchRequest)
            for record in records {
                if (record.value(forKey: "id") as! Int == editingId) {
                    record.setValue(artist, forKey: "artist")
                    record.setValue(name, forKey: "title")
                    record.setValue(album, forKey: "album")
                    record.setValue(year, forKey: "year")
                    record.setValue(info, forKey: "info")
                    break
                }
            }
            performSegue(withIdentifier: "toDetails", sender: self)
        } catch let error as NSError {
            self.showAlert(title: "Error - Could not fetch", message: String(describing: error))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //MARK: - Initializing fields
        artistField.text = artist
        nameField.text = name
        albumField.text = album
        yearField.text = String(describing: year)        
        infoField.text = info
        
        //MARK: - UITextView settings to look like UITextField
        infoField.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        infoField.layer.borderWidth = 0.5
        infoField.layer.cornerRadius = 7
        infoField.clipsToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: - Segue to DetailsViewController
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
