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
    
    static var campaign : Campaign?
    static var currentLocation : CLLocation?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.backgroundColor = Green
        navigationController?.navigationBar.barTintColor = Green
        
        //Setup Location
        checkLocationState()
        
        setupViews()
        
        //Check Status
        checkStatus()
        
    }
    
    let numberOfCrowd : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 30)
        l.textAlignment = .center
        
        return l
    }()
    
    let crowdTitle : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textAlignment = .center
        
        l.numberOfLines = 0
        l.text = "Add number of people following you"
        
        return l
    }()
    
    lazy var addBtn : UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("+", for: .normal)
        b.setTitleColor(Green, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        b.addTarget(self, action: #selector(incrementHandler), for: .touchUpInside)
        return b
    }()
    
    lazy var subtractBtn : UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("-", for: .normal)
        b.setTitleColor(Red, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        b.addTarget(self, action: #selector(decrementHandler), for: .touchUpInside)
        return b
    }()
    
    lazy var startBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Green
        button.addTarget(self, action: #selector(startBtnHandler), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    let statusLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.textAlignment = .center
        l.text = "Disconnected"
        l.textColor = Red
        return l
    }()
    
    lazy var stopBtn : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Red.withAlphaComponent(0.5)
        button.isEnabled = false
        button.addTarget(self, action: #selector(stopBtnHandler), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func checkStatus() {
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        Database.database().reference().child("Crowd").child(crowd_id).observe(.value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {return}
            if let status = data["status"] as? String {
                self.toggleStatus(status: status == "Active")
            } else {
                self.toggleStatus(status: false)
            }
            
            if let total = data["numberOfPeople"] as? String {
                self.numberOfCrowd.text = total
            } else {
                self.numberOfCrowd.text = "0"
            }
        }
    }
    
    func checkLocationState() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("authorizedAlways")

            locationManager.requestAlwaysAuthorization()
            locationManager.activityType = .fitness
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
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
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        
        Database.database().reference().child("Crowd").child(crowd_id).child("location").updateChildValues(data)
    }
    
    func updateDatabaseHeading(heading: CLHeading)  {
        
        let data : [String: Any] = ["heading": Int(heading.trueHeading)]
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        
        Database.database().reference().child("Crowd").child(crowd_id).child("location").updateChildValues(data)
    }
    
    @objc func startBtnHandler() {
        toggleStatus(status: true)
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        Database.database().reference().child("Crowd").child(crowd_id).child("status").setValue("Active")
    }
    
    func toggleStatus(status: Bool) {
        switch status {
        case true:
            
            startBtn.isEnabled = false
            stopBtn.isEnabled = true
            
            startBtn.backgroundColor = Green.withAlphaComponent(0.5)
            stopBtn.backgroundColor = Red
            
            statusLabel.text = "Connected"
            statusLabel.textColor =  Green
            return
        default:
            
            startBtn.isEnabled = true
            stopBtn.isEnabled = false
            
            stopBtn.backgroundColor = Red.withAlphaComponent(0.5)
            startBtn.backgroundColor = Green
            
            statusLabel.text = "Disconnected"
            statusLabel.textColor =  Red
        }
    }
    
    @objc func stopBtnHandler() {
        toggleStatus(status: false)
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        Database.database().reference().child("Crowd").child(crowd_id).child("status").setValue("inActive")
    }
    
    @objc func incrementHandler() {
        guard let number = numberOfCrowd.text else {return}
        guard let IntNumber = Int(number) else {return}
        
        let total = IntNumber + 10
        guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
        if crowd_id.isEmpty {
            return
        }
        
        Database.database().reference().child("Crowd").child(crowd_id).child("numberOfPeople").setValue("\(total)")
        
        numberOfCrowd.text = "\(total)"
        
        
    }
    
    @objc func decrementHandler() {
        guard let number = numberOfCrowd.text else {return}
        guard let IntNumber = Int(number) else {return}
        
        let total = IntNumber - 10
        if total >= 0 {
            
            guard let crowd_id = HomeVC.campaign?.crowd_id else {return}
            if crowd_id.isEmpty {
                return
            }
            
            Database.database().reference().child("Crowd").child(crowd_id).child("numberOfPeople").setValue("\(total)")
            
            numberOfCrowd.text = "\(total)"
        }
        
    }
    
    fileprivate func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [startBtn, stopBtn])
        let crowdStackView = UIStackView(arrangedSubviews: [subtractBtn, numberOfCrowd, addBtn])
        
        view.addSubview(stackView)
        view.addSubview(crowdStackView)
        view.addSubview(statusLabel)
        view.addSubview(crowdTitle)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        crowdStackView.axis = .horizontal
        crowdStackView.distribution = .fillEqually
        crowdStackView.spacing = 8
        
        stackView.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: WIDTH - 16, height: 116)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        crowdStackView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: WIDTH / 2, height: 40)
        crowdStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        crowdStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        crowdTitle.anchor(top: nil, left: view.leftAnchor, bottom: numberOfCrowd.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 60)
        
        statusLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 60)
        
    }
}


extension HomeVC : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for newLocation in locations {
//            
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 1000 && abs(howRecent) < 10  else { continue }
//            
//            if let oldLocation = currentLocation  {
//                let distance = newLocation.distance(from: oldLocation)
//                if distance > 10 {
//                    updateDatabaseLocation(location: newLocation)
//                }
//                print(distance)
//            } else {
//                
//                updateDatabaseLocation(location: newLocation)
//            }
//
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//
//        let howRecent = newHeading.timestamp.timeIntervalSinceNow
//        guard newHeading.headingAccuracy < 30 && abs(howRecent) < 10  else { return }
//        updateDatabaseHeading(heading: newHeading)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
}








