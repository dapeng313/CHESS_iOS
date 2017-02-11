//
//  SubordinateInfo.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

struct Member {
    var id: String!
    var name: String!
    var orgname: String!
    var plansname: String!
    var email: String!
    
    init(id: String, name: String, orgname: String, plansname: String, email: String) {
        self.id = id
        self.name = name
        self.orgname = orgname
        self.plansname = plansname
        self.email = email
    }
}


class SubordinateInfo: HRMSModel {

    var pernr: String = ""
    var plansname: String = ""
    var nachn: String = ""
    var orgehname: String = ""
    var email: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        pernr <- map["pernr"]
        nachn <- map["nachn"]
        plansname <- map["plansname"]
        orgehname <- map["orgehname"]
        email <- map["email"]

    }
}

class CompanyInfo: HRMSModel {
    
    var name: String = ""
    var children: [SubordinateInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        name <- map["stext"]
        children <- map["childrens"]        
    }
}

class SubordinateInfoResponse: HRMSResponse {
    var data: [CompanyInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
}
