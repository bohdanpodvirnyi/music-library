//
//  AddingViewController.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/20/18.
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
            self.showAlert(title: "Error", message: "You cannot use letters in field \"Year\"")
            return
        }
        info = infoField.text!
        id = UserDefaults.standard.integer(forKey: "id")
        let data = Record(artist: artist, name: name, album: album, year: year, info: info, id: id)!
        saveData(data: data)
        performSegue(withIdentifier: "toMainView", sender: self)
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        definesPresentationContext = true
        //MARK: - Initializing fields
        artistField.text = artist
        nameField.text = name
        albumField.text = album
        if year == 0 {
            yearField.text = ""
        } else {
            yearField.text = String(describing: year)
        }
        infoField.text = info
        //MARK: - UITextView settings to look like UITextField
        infoField.layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor
        infoField.layer.borderWidth = 0.5
        infoField.layer.cornerRadius = 7
        infoField.clipsToBounds = true
    }
    
    //MARK: - Saving user input to CoreData
    func saveData(data: Record) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Data", in: managedContext)
        let records = NSManagedObject(entity: entity!, insertInto: managedContext)
        records.setValue(data.artist, forKey: "artist")
        records.setValue(data.name, forKey: "title")
        records.setValue(data.album, forKey: "album")
        records.setValue(data.year, forKey: "year")
        records.setValue(data.info, forKey: "info")
        records.setValue(data.id, forKey: "id")
        do {
            try managedContext.save()
            //MARK: - Setting value for next id
            UserDefaults.standard.setValue(id+1, forKey: "id")
        } catch let error as NSError {
            self.showAlert(title: "Error - Could not save", message: String(describing: error))
        }
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
