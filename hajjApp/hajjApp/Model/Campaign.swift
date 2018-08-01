//
//  Campaign.swift
//  hajjApp
//
//  Created by Abdullah Alhassan on 01/08/2018.
//  Copyright © 2018 Abdullah Alhassan. All rights reserved.
//

import UIKit


class Campaign: NSObject, NSCoding {
    let uid : String
    let number : String
    let email : String
    let Total_Hajji : String
    let name : String
    
    
    init(uid :String, dictionary: [String:Any]) {
        self.uid  = uid
        
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.Total_Hajji = dictionary["Total_Hajji"] as? String ?? ""
        self.number = dictionary["phone"] as? String ?? ""
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let Total_Hajji = aDecoder.decodeObject(forKey: "Total_Hajji") as! String
        let number = aDecoder.decodeObject(forKey: "number") as! String
        let dictionary = ["uid":uid, "name":name, "email":email, "Total_Hajji" : Total_Hajji, "number": number]
        self.init(uid: uid, dictionary: dictionary)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(Total_Hajji, forKey: "Total_Hajji")
        aCoder.encode(number, forKey: "number")
        
    }
}
