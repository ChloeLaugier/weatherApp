//
//  StoredCities.swift
//  WeatherToday
//
//  Created by Chloé Laugier on 03/06/2015.
//  Copyright (c) 2015 Chloé Laugier. All rights reserved.
//

import UIKit
import CoreData

class StoredCities: NSObject {
    
    static func getStoredCities() -> [City]{
        
        var storedCities = [City]()
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:"City")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        if let results = fetchedResults {
            for  cities:NSManagedObject in results {
                var cityName = cities.valueForKey("name") as! String
                var city : City  = City(name : cityName)
                storedCities.insert(city, atIndex: 0)
            }
           
        }
        return storedCities;
    }
    
    static func saveCity(name: String) {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("City",inManagedObjectContext:
            managedContext)
        
        let city = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        city.setValue(name, forKey: "name")
        var error: NSError?
        
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        
        
    }
    
    static func deleteFirstIfMoreThan10() {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        
        let fetchRequest = NSFetchRequest(entityName:"City")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        if let results = fetchedResults {
            if (results.count > 10) {
                managedContext.deleteObject(results.first!)
            }
            
        }
        
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
    }

   
}
