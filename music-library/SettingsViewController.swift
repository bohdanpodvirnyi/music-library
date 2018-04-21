//
//  SettingsViewController.swift
//  music-library
//
//  Created by hell 'n silence on 4/21/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
