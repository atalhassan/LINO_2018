//
//  HomeVC.swift
//  hajjApp
//
//  Created by Abdullah Alhassan on 01/08/2018.
//  Copyright © 2018 Abdullah Alhassan. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class HomeVC: UIViewController {
    
    var campaign : Campaign?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        //Setup Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
    }
    
    

}


extension HomeVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}








