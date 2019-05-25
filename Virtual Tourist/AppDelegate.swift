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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkIfFirstLaunch()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("Application Will Terminate")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Applcion entered background")
    }
    func checkIfFirstLaunch() {
        let appHasLaunchedBefore = UserDefaults.standard.bool(forKey: Constants.FIRST_LAUNCH)
        if !appHasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: Constants.FIRST_LAUNCH)
            UserDefaults.standard.synchronize()
        }
    }
}

