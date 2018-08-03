//
//  AppDelegate.swift
//  hajjApp
//
//  Created by Abdullah Alhassan on 01/08/2018.
//  Copyright © 2018 Abdullah Alhassan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.makeKeyAndVisible()
        
        let homeVC = HomeVC()
        let vc = ViewController()
        
        if let decoded = UserDefaults.standard.object(forKey: "campaign") as? Data {
            let decodedCampaign = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Campaign
            HomeVC.campaign = decodedCampaign
        }
        
        if let _  = Auth.auth().currentUser?.uid {
             window?.rootViewController = UINavigationController(rootViewController: homeVC)
        } else {
             window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingHeading()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingHeading()
    }
    
    func updateDatabaseHeading(heading: CLHeading)  {
        
        let data : [String: Any] = ["heading": Int(heading.trueHeading)]
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        
        Database.database().reference().child("Crowd").child(crowd_id).child("location").updateChildValues(data)
    }
    
    func updateDatabaseLocation(location: CLLocation, distance: CLLocationSpeed = 0)  {
        
        let data : [String: Any] = ["lat": location.coordinate.latitude, "lng": location.coordinate.longitude, "timestamp": ServerValue.timestamp(), "distanceMoved": distance]
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        
        Database.database().reference().child("Crowd").child(crowd_id).child("location").updateChildValues(data)
    }
    
    
}

extension AppDelegate : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 1000 && abs(howRecent) < 10  else { continue }
            
            if let oldLocation = HomeVC.currentLocation  {
                
                let distance = newLocation.distance(from: oldLocation)
                updateDatabaseLocation(location: newLocation, distance: distance)
                HomeVC.currentLocation = newLocation
                
            } else {
                
                updateDatabaseLocation(location: newLocation)
                HomeVC.currentLocation = newLocation
            }

        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let howRecent = newHeading.timestamp.timeIntervalSinceNow
        guard newHeading.headingAccuracy < 30 && abs(howRecent) < 10  else { return }
        updateDatabaseHeading(heading: newHeading)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}









