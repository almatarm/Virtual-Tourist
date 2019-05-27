//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 2019-05-13.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "Model")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkIfFirstLaunch()
        
        dataController.load()
        
        let mapViewController = getMainViewController() as! MapViewController
        mapViewController.dataController = dataController
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        persistData()
    }

    func checkIfFirstLaunch() {
        let appHasLaunchedBefore = UserDefaults.standard.bool(forKey: Constants.FIRST_LAUNCH)
        if !appHasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: Constants.FIRST_LAUNCH)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getMainViewController() -> UIViewController? {
        let navigationController = window?.rootViewController as! UINavigationController
        let viewController = navigationController.topViewController
        return viewController
    }
    
    func persistData() {
        try? dataController.viewContext.save()
    }
}

