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
        self.hideKeyboardWhenTappedAround()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    //MARK: - Cells appearance
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListViewCell else {
            self.showAlert(title: "Fatal Error", message: "The dequeued cell is not an instance of ListViewCell.")
            fatalError("The dequeued cell is not an instance of ListViewCell.")
        }
        let result = results[indexPath.row]
        cell.artistLabel.text = result.value(forKey: "artist") as? String
        cell.nameLabel.text = result.value(forKey: "title") as? String
        cell.albumLabel.text = String(describing: result.value(forKey: "album")!) + " (" + String(describing: result.value(forKey: "year")!) + ")"
        return cell
    }
    
    //MARK: - Tapping on specific row in TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenRow = indexPath.row
        performSegue(withIdentifier: "recordInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: - Segue to DetailsViewController
        if let destinationViewController = segue.destination as? DetailsViewController {
            destinationViewController.artist = String(describing: results[chosenRow].value(forKey: "artist")!)
            destinationViewController.name = String(describing: results[chosenRow].value(forKey: "title")!)
            destinationViewController.album = String(describing: results[chosenRow].value(forKey: "album")!)
            destinationViewController.year = results[chosenRow].value(forKey: "year") as! Int
            destinationViewController.info = String(describing: results[chosenRow].value(forKey: "info")!)
        }
    }

    //MARK: - Action when text in SearchBar did change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBar.showsCancelButton = true
        }
        search(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    //MARK: - Searching in CoreData
    func search(text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Data")
        //MARK: - Setting predicates
        var predicateList = [NSPredicate]()
        let artistPredicate = NSPredicate(format: "artist contains[c] %@", text)
        let namePredicate = NSPredicate(format: "title contains[c] %@", text)
        let albumPredicate = NSPredicate(format: "album contains[c] %@", text)
        let yearPredicate = NSPredicate(format: "year contains[c] %@", text.description)
        let infoPredicate = NSPredicate(format: "info contains[c] %@", text)
        let orCompoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: [artistPredicate, namePredicate, albumPredicate, yearPredicate, infoPredicate])
        predicateList.append(orCompoundPredicate)
        //MARK: - Performing search
        fetchRequest.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicateList)
        do {
            results = try managedContext.fetch(fetchRequest)
            table.reloadData()
        } catch let error as NSError {
            self.showAlert(title: "Error - Could not fetch.", message: String(describing: error))
        }
    }
}
