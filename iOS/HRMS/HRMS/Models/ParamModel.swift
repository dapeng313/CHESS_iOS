//
//  ParamModel.swift
//  HRMS
//
//  Created by Apollo on 1/26/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class ParamModel: HRMSModel {
    
    var id: Int = 0
    var value: String = ""
    var name: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        id <- map["id"]
        value <- map["paraValue"]
        name <- map["paraName"]
    }
}
