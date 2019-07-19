//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/18/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import CoreData

// This is a class instead of a struct since we don't want to make multiple copies
// 1. hold persistent container
// 2. Load the persistent store
// 3. help us access the context
class DataController {
    // the container
    let persistentContainer: NSPersistentContainer
    
    // convenience property to access the context
    var viewContext: NSManagedObjectContext {
        // this will be associated with the main queue
        return persistentContainer.viewContext
    }
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    // use the completion here to do something once we've loaded data
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
