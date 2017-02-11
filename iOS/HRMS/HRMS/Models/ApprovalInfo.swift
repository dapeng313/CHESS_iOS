//
//  ApprovalInfo.swift
//  HRMS
//
//  Created by Apollo on 2/6/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class ApprovalInfo: HRMSModel {
    var pernr: String?
    var approverna: String?
    var approver: String?
    var read: String?
    var state: String?
    var remark: String?
    var rowId: Int = 0
    var flowId: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        pernr <- map["pernr"]
        approverna <- map["approverna"]
        approver <- map["approver"]
        read <- map["read"]
        state <- map["state"]
        remark <- map["remark"]
        rowId <- map["rowId"]
        flowId <- map["flowId"]
    }
}



