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
    
    let phonenumberInput : SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField()
        tv.placeholder = "Number"
        tv.title = "Number"
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
            
            let newCampaign = Campaign(uid: snapashot.key, dictionary: data)
            print(newCampaign)
            if newCampaign.number == number && newCampaign.uid == campaign_id {
                
                Auth.auth().signInAnonymously(completion: { (authResult, error) in
                    if let err = error {
                        print(err)
                        return
                    }
                    
                    
                    var userDefaults = UserDefaults.standard
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newCampaign)
                    userDefaults.set(encodedData, forKey: "campaign")
                    userDefaults.synchronize()
                    
                    DispatchQueue.main.async {
                        let homeVC = HomeVC()
                        homeVC.campaign = newCampaign
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
        
        setupViews()
    }
    
    
    fileprivate func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [campaignInput, phonenumberInput, loginBtn])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(stackView)
        
        stackView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: WIDTH - 16, height: 166)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
    }


}

