//
//  HRMSResponse.swift
//  HRMS
//
//  Created by Apollo on 1/21/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class HRMSResponse: HRMSModel {
    var success: Int = 0

    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {        
        success <- map["success"]
    }
    
}
