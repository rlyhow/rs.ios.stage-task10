//
//  AppDelegate.swift
//  GameCounter
//
//  Created by Mikita Shalima on 25.08.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.object(forKey: "countOfOpen") == nil ||  UserDefaults.standard.object(forKey: "countOfOpen") as! String == "Opened" {
            let arrayOfPlayers = ["You", "Me", "Mikita"]
            let arrayOfPoints = [0, 0, 0]
            
            UserDefaults.standard.setValue("Opened", forKey: "countOfOpen")
            UserDefaults.standard.setValue(arrayOfPlayers, forKey: "players")
            UserDefaults.standard.setValue(arrayOfPoints, forKey: "points")
            UserDefaults.standard.setValue(0, forKey: "currentTurn")
            
            let gameCounterController = GameCounterController()
            window?.rootViewController = CounterNavigationViewController(rootViewController: gameCounterController)
            window?.makeKeyAndVisible()
        } else {
            let gameProcessController = GameProcessViewController()
            window?.rootViewController = CounterNavigationViewController(rootViewController: gameProcessController)
            window?.makeKeyAndVisible()
        }
        
        return true
    }

}

