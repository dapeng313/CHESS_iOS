//
//  WorkFlow.swift
//  HRMS
//
//  Created by Apollo on 2/4/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class WorkFlowListResponse: HRMSResponse {
    var data: [WorkFlow]?
    var total: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["rows"]
        total <- map["total"]
    }
}

class WorkFlow: HRMSModel {
    var rows: Int = 0
    var skip: Int = 0
    var count: Int = 0
    var rowId: Int = 0
    var pernr: String = ""
    var createdAt: String = ""
    var filter: Int = 0
    var type: String = ""
    var name: String = ""
    var descript: String = ""
    var status: Int = 0
    var nachn: String = ""
    var orgehname: String = ""
    var approver: String = ""
    var read: String = ""
    var state: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {

        count <- map["count"]
        rows <- map["rows"]
        skip <- map["skip"]
        rowId <- map["rowId"]
        pernr <- map["pernr"]
        createdAt <- map["createdAt"]
        filter <- map["filter"]
        type <- map["type"]
        name <- map["name"]
        descript <- map["description"]
        status <- map["status"]
        nachn <- map["nachn"]
        orgehname <- map["orgehname"]
        read <- map["read"]
        state <- map["state"]
    }
}
