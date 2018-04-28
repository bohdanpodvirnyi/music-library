//
//  SettingsViewController.swift
//  music-library
//
//  Created by Bohdan Podvirnyi on 4/21/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var sortingBy: UISegmentedControl!
    @IBOutlet weak var sortingOrder: UISegmentedControl!
    
    //MARK: - Setting UserDefaults for sorting key
    @IBAction func sortingChanged(_ sender: Any) {
        UserDefaults.standard.set(sortingBy.titleForSegment(at: sortingBy.selectedSegmentIndex), forKey: "sorting")
    }
    
    //MARK: - Setting UserDefaults for sorting order
    @IBAction func sortingOrderChanged(_ sender: Any) {
        UserDefaults.standard.set(sortingOrder.titleForSegment(at: sortingOrder.selectedSegmentIndex), forKey: "sortingOrder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSortingSettings()
    }
    
    //MARK: - Setting view to UserDefaults
    func loadSortingSettings() {
        let userSortBy = UserDefaults.standard.string(forKey: "sorting")
        var i = 0
        while true {
            if sortingBy.titleForSegment(at: i) == userSortBy {
                sortingBy.selectedSegmentIndex = i
                break
            } else {
                i += 1
            }
        }
    }
    
    //MARK: - Action for Delete button
    @IBAction func deleteButton(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestToDelete = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequestToDelete)
        do {
            try managedContext.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        UserDefaults.standard.setValue(0, forKey: "id")
        self.showAlert(title: "Delele", message: "All data deleted successfully")
        //MARK: - Performing segue to ListView
        self.tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //MARK: - Segue to ListView
        if let destinationViewController = segue.destination as? ListViewController {
            destinationViewController.table.reloadData()
        }
    }
}
