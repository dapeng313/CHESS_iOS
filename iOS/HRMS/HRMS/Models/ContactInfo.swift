//
//  ContactInfo.swift
//  HRMS
//
//  Created by Apollo on 1/31/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class ContactInfoResponse: HRMSModel {
    var total: Int = 0
    var data: [ContactInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        total <- map["total"]
        data <- map["rows"]
    }
}

class ContactInfo: HRMSModel {
    var id: Int = 0
    var accountId: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var flow_ID: Int = 0
    var cutyp: String = ""
    var cunum: String = ""

    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        accountId <- map["pernr"]
        rows <- map["rows"]
        skip <- map["skip"]
        flow_ID <- map["flow_ID"]
        cutyp <- map["cutyp"]
        cunum <- map["cunum"]
    }
    
}
