//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 25/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController(modelName: "Model")
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
