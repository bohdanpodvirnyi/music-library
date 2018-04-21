//
//  SearchViewController.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/21/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var table: UITableView!
    
    var results: [NSManagedObject] = []
    
    var chosenRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListViewCell else {
            fatalError("The dequeued cell is not an instance of ListViewCell.")
        }
        
        let result = results[indexPath.row]
        
        cell.artistLabel.text = result.value(forKey: "artist") as? String
        cell.nameLabel.text = result.value(forKey: "title") as? String
        cell.albumLabel.text = String(describing: result.value(forKey: "album")!) + " (" + String(describing: result.value(forKey: "year")!) + ")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow = indexPath.row
        performSegue(withIdentifier: "recordInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? DetailsViewController {
            print(results[chosenRow])
            destinationViewController.artist = String(describing: results[chosenRow].value(forKey: "artist")!)
            destinationViewController.name = String(describing: results[chosenRow].value(forKey: "title")!)
            destinationViewController.album = String(describing: results[chosenRow].value(forKey: "album")!)
            destinationViewController.year = results[chosenRow].value(forKey: "year") as! Int
            destinationViewController.info = String(describing: results[chosenRow].value(forKey: "info")!)
        }
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(text: searchBar.text!)
    }
    
    func search(text: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Data")
        
        var predicateList = [NSPredicate]()
        
        let artistPredicate = NSPredicate(format: "artist contains[c] %@", text)
        let namePredicate = NSPredicate(format: "title contains[c] %@", text)
        let albumPredicate = NSPredicate(format: "album contains[c] %@", text)
        let yearPredicate = NSPredicate(format: "year contains[c] %@", text.description)
        let infoPredicate = NSPredicate(format: "info contains[c] %@", text)
        
        let orCompoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [artistPredicate, namePredicate, albumPredicate, yearPredicate, infoPredicate])
        
        predicateList.append(orCompoundPredicate)
        
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateList)
        
        do{
            results = try managedContext.fetch(fetchRequest)
            table.reloadData()
            
        }catch{
            print("error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
