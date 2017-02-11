//
//  OrgUnitItem.swift
//  HRMS
//
//  Created by Apollo on 1/17/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class OrgUnitItem: HRMSModel {

    var nodeId: String = ""
    var nodeType: String = ""
    var nodeName: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        nodeId <- map["nodeId"]
        nodeType <- map["nodeType"]
        nodeName <- map["text"]
    }
}
