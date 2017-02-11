//
// Created by Dapeng Wang on 3/17/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation
import ObjectMapper

class HRMSError: HRMSModel {
    var code: Int = 0
    var message: String = ""
    var statusCode: Int = 500
    
    required init?(map: Map) { super.init(map: map) }

    init(message: String) {
        super.init()

        self.message = message
    }
    
    init(code: Int){
        super.init()
        self.code = code

        if code == -1 {
            self.message = "Failed"
        }
    }
    override func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        statusCode <- map["statusCode"]
    }
}
