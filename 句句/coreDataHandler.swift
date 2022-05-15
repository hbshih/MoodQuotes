//
//  coreDataHandler.swift
//  句句
//
//  Created by Ben on 2022/5/15.
//

import Foundation
import CoreData
import AVFoundation
import UIKit

struct coreDataHandler
{
    
    var entityName = ""
    /*
    func saveData(name: String)
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
          // 1
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          // 2
          let entity =
            NSEntityDescription.entity(forEntityName: "Quotes",
                                       in: managedContext)!
          
          let person = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
          
          // 3
          person.setValue(name, forKeyPath: "name")
          
          // 4
          do {
            try managedContext.save()
            people.append(person)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    func loadData (name: String) -> [NSManagedObject]
    {
        //1
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    */
}
