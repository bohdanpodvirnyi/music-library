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
    
    @IBAction func sortingChanged(_ sender: Any) {
        
        UserDefaults.standard.set(sortingBy.titleForSegment(at: sortingBy.selectedSegmentIndex), forKey: "sorting")
        
    }
    
    @IBOutlet weak var sortingOrder: UISegmentedControl!
    
    @IBAction func sortingOrderChanged(_ sender: Any) {
        
        UserDefaults.standard.set(sortingOrder.titleForSegment(at: sortingOrder.selectedSegmentIndex), forKey: "sortingOrder")
        
    }
    
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
        
        let alert = UIAlertController(title: "Delete", message: "Data deleted successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
        
        self.tabBarController?.selectedIndex = 0
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? ListViewController {
        
            destinationViewController.table.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}
