//
//  SalaryInfo.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class SalaryInfoResponse: HRMSResponse {
    var py2002: PY2002?
    var py2001: PY2001?
    var py2000: PY2000?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        py2002 <- map["py2002"]
        py2001 <- map["py2001"]
        py2000 <- map["py2000"]
    }
}
