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
import Firebase

class HomeVC: UIViewController {
    
    var campaign : Campaign?
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        //Setup Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationState()
    }
    
    func checkLocationState() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("authorizedAlways")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            alert(message: "Please Change Location to Always")
        case .denied:
            alert(message: "Please Change Location to Always")
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default:
            return
        }
    }

    func updateDatabaseLocation(location: CLLocation)  {
        
        let data : [String: Any] = ["lat": location.coordinate.latitude, "lng": location.coordinate.longitude, "timestamp": ServerValue.timestamp()]
        guard let crowd_id = campaign?.crowd_id else {return}
        print(crowd_id)
        if crowd_id.isEmpty {
            return
        }
        print(location.coordinate)
        Database.database().reference().child("Crowd").child(crowd_id).child("location").updateChildValues(data)
    }
    
    
}


extension HomeVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10  else { continue }
            
            updateDatabaseLocation(location: newLocation)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}








