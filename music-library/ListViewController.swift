//
//  ListViewController.swift
//  music-library
//
//  Created by hell 'n silence on 4/20/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var records: [NSManagedObject] = []
    var chosenRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListViewCell else {
            fatalError("The dequeued cell is not an instance of ListViewCell.")
        }
        
        let record = records[indexPath.row]
        
        cell.artistLabel.text = record.value(forKey: "artist") as? String
        cell.titleLabel.text = record.value(forKey: "title") as? String
        cell.albumLabel.text = record.value(forKey: "album") as? String
        cell.yearLabel.text = record.value(forKey: "year") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow = indexPath.row
        performSegue(withIdentifier: "recordInfo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destinationViewController = segue.destination as? DetailsViewController {
            print(records[chosenRow])
            destinationViewController.artist = String(describing: records[chosenRow].value(forKey: "artist")!)
            destinationViewController.name = String(describing: records[chosenRow].value(forKey: "title")!)
            destinationViewController.album = String(describing: records[chosenRow].value(forKey: "album")!)
            destinationViewController.year = records[chosenRow].value(forKey: "year") as! Int
            destinationViewController.info = String(describing: records[chosenRow].value(forKey: "info")!)
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
