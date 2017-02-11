//
//  ContractInfo.swift
//  HRMS
//
//  Created by Apollo on 1/26/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class ContractParams: HRMSModel {
    var par026: [ParamModel]?
    var par027: [ParamModel]?
    var par049: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par026 <- map["par026"]
        par027 <- map["par027"]
        par049 <- map["par049"]
    }
}

class ContractInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var cttyp: String = ""
    var prbzt: String = ""
    var prbeh: String = ""
    var ctedt: String = "0000-00-00"
    var ctnum: String = ""
    var sidat: String = "0000-00-00"
    var ctsel: String = ""
    var flow_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        begda <- map["begda"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        cttyp <- map["cttyp"]
        prbzt <- map["prbzt"]
        prbeh <- map["prbeh"]
        ctedt <- map["ctedt"]
        ctnum <- map["ctnum"]
        sidat <- map["sidat"]
        ctsel <- map["ctsel"]
        flow_ID <- map["flow_ID"]
    }
}

class ContractInfoResponse: HRMSResponse {
    var paramList: ContractParams? //[String: [ParamModel]] = [:]
    var contracts: [ContractInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        paramList <- map["params"]
        contracts <- map["contacts"]
    }
}
