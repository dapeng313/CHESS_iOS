//
// Created by Dapeng Wang on 3/17/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation
import ObjectMapper

class ShiftInfoResponse: HRMSResponse {
    var data: ShiftInfo?

    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        data <- map["data"]
    }
}

class ShiftInfo: HRMSModel {
    var id: Int = 0
    var accountId: String = ""
    var bukrs: String = ""
    var shfno: Int = 0
    var shfna: String = ""
    var timin: String = ""
    var flxin: Int = 0
    var timou: String = ""
    var flxou: Int = 0
    var wortm: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        accountId <- map["pernr"]
        bukrs <- map["bukrs"]
        shfno <- map["shfno"]
        shfna <- map["shfna"]
        timin <- map["timin"]
        flxin <- map["flxin"]
        timou <- map["timou"]
        flxou <- map["flxou"]
        wortm <- map["wortm"]
    }
    
}
