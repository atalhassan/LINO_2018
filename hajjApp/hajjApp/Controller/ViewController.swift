//
//  ViewController.swift
//  hajjApp
//
//  Created by Abdullah Alhassan on 01/08/2018.
//  Copyright © 2018 Abdullah Alhassan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {

    
    let campaignInput : SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField()
        tv.placeholder = "Enter Campaign ID"
        tv.title = "Campaign ID"
        tv.selectedLineColor = Green
        tv.selectedLineHeight = 1
        tv.selectedTitleColor = Green
        
        tv.textAlignment = .center
        return tv
    }()
    
    let logo : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "Tafweej")
        return iv
    }()
    
    let phonenumberInput : SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField()
        tv.placeholder = "Number"
        tv.title = "Number"
        tv.keyboardType = .numberPad
        tv.selectedLineColor = Green
        tv.selectedLineHeight = 1
        tv.selectedTitleColor = Green
        tv.textAlignment = .center
        return tv
    }()
    
    lazy var loginBtn : UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Login", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = Green
        b.layer.cornerRadius = 10
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        return b
    }()
    
    @objc func loginHandler() {
        guard let campaign_id = campaignInput.text?.lowercased() else { return        }
        guard let number = phonenumberInput.text else { return        }
        
        if campaign_id.isEmpty || number.isEmpty {
            return
        }
        
        Database.database().reference().child("Campaign").child(campaign_id).observeSingleEvent(of: .value) { (snapashot) in
            guard let data = snapashot.value as? [String: Any] else {return}
            
            let newCampaign = Campaign(uid: snapashot.key, crowd_id: "", dictionary: data)
            
            
            if newCampaign.number == number && newCampaign.uid == campaign_id {
                
                Auth.auth().signInAnonymously(completion: { (authResult, error) in
                    if let err = error {
                        print(err)
                        return
                    }
                    
                    
                    
                    let newCrowd = Database.database().reference().child("Crowd").childByAutoId()
                    
                    let _newCampaign = Campaign(uid: snapashot.key, crowd_id: newCrowd.key, dictionary: data)
                    
                    
                    let crowdData = ["campaign_id" : newCampaign.uid]
                    newCrowd.setValue(crowdData)
                    
                    
                    let userDefaults = UserDefaults.standard
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: _newCampaign)
                    userDefaults.set(encodedData, forKey: "campaign")
                    userDefaults.synchronize()
                    
                    DispatchQueue.main.async {
                        let homeVC = HomeVC()
                        HomeVC.campaign = _newCampaign
                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    
                })
                
                
                
            } else {
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove navigation bar
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func setupViews() {
        
        
        let stackView = UIStackView(arrangedSubviews: [campaignInput, phonenumberInput, loginBtn])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(logo)
        
        view.addSubview(stackView)
        
        logo.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        stackView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: WIDTH - 16, height: 166)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
    }


}

