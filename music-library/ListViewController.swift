//
//  ListViewController.swift
//  music-library
//
//  Created by hell 'n silence on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var records: [NSManagedObject] = []
    
    var chosenRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading()
        
        if !isAppAlreadyLaunchedOnce() {
            
            UserDefaults.standard.setValue(0, forKey: "id")
            
        }
    }
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        
        if UserDefaults.standard.bool(forKey: "isAppAlreadyLaunchedOnce") {
            print("true")
            return true
            
        } else {
            
            UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("false")
            return false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListViewCell else {
            fatalError("The dequeued cell is not an instance of ListViewCell.")
        }
        
        let record = records[indexPath.row]
        
        cell.artistLabel.text = record.value(forKey: "artist") as? String
        cell.titleLabel.text = record.value(forKey: "title") as? String
        cell.albumLabel.text = String(describing: record.value(forKey: "album")!) + " (" + String(describing: record.value(forKey: "year")!) + ")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow = indexPath.row
        performSegue(withIdentifier: "toRecordInfo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destinationViewController = segue.destination as? DetailsViewController {
            
            destinationViewController.artist = String(describing: records[chosenRow].value(forKey: "artist")!)
            destinationViewController.name = String(describing: records[chosenRow].value(forKey: "title")!)
            destinationViewController.album = String(describing: records[chosenRow].value(forKey: "album")!)
            destinationViewController.year = records[chosenRow].value(forKey: "year") as! Int
            destinationViewController.info = String(describing: records[chosenRow].value(forKey: "info")!)
            destinationViewController.id = records[chosenRow].value(forKey: "id") as! Int
            
        }
        
    }
    
    func loading() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Data")
        do {
            records = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

}
