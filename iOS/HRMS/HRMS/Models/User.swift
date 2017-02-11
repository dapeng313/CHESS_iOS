//
// Created by Dapeng Wang on 3/17/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation
import ObjectMapper

class User: HRMSResponse {

    var id: String = ""
    var token: String = ""
    var email: String = ""
    var coname: String = ""
    var orgehname: String = ""
    var coobjid: String = ""
    var plansname: String = ""
    var nachn: String = "" //name

    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        id <- (map["pernr"])
        token <- map["wtoken"]
        email <- map["email"]
        coname <- map["coname"]
        orgehname <- map["orgehname"]
        coobjid <- map["coobjid"]
        plansname <- map["plansname"]
        nachn <- map["nachn"]
    }
    
    func saveUser() {
        UserDefaults.standard.set(id, forKey: "account_id")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(coname, forKey: "coname")
        UserDefaults.standard.set(orgehname, forKey: "orgehname")
        UserDefaults.standard.set(coobjid, forKey: "coobjid")
        UserDefaults.standard.set(plansname, forKey: "plansname")
        UserDefaults.standard.set(nachn, forKey: "nachn")
    }

    class func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: "account_id")
    }
    
    class func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
    
    class func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: "email")
    }
    
    class func getUserConame() -> String? {
        return UserDefaults.standard.string(forKey: "coname")
    }
    
    class func getUserOrgehname() -> String? {
        return UserDefaults.standard.string(forKey: "orgehname")
    }
    
    class func getUserCoobjid() -> String? {
        return UserDefaults.standard.string(forKey: "coobjid")
    }
    
    class func getUserPlansname() -> String? {
        return UserDefaults.standard.string(forKey: "plansname")
    }
    
    
    class func getUserNachn() -> String? {
        return UserDefaults.standard.string(forKey: "nachn")
    }   

}
