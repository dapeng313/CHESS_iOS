//
//  EducationInfo.swift
//  HRMS
//
//  Created by Apollo on 1/27/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class EducationParams: HRMSModel {
    var par007: [ParamModel]?
    var par008: [ParamModel]?
    var par009: [ParamModel]?
    var par013: [ParamModel]?
    var par029: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par007 <- map["par007"]
        par008 <- map["par008"]
        par009 <- map["par009"]
        par013 <- map["par013"]
        par029 <- map["par029"]
    }
}

class EducationInfo: HRMSModel {
    var id: Int = 0
    var begda: String = "0000-00-00"
    var filter: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var pernr: String = ""
    var acdeg: String = ""
    var insti: String = ""
    var prbeh: String = ""
    var endda: String = "0000-00-00"
    var etype: String = ""
    var etypename: String = ""
    var hetyp: String = ""
    var hacde: String = ""
    var dacde: String = ""
    var actur: String = ""
    var spec1: String = ""
    var spec2: String = ""
    var etype1: String = ""
    var flow_ID: Int = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        begda <- map["begda"]
        filter <- map["filter"]
        rows <- map["rows"]
        skip <- map["skip"]
        pernr <- map["pernr"]
        acdeg <- map["acdeg"]
        prbeh <- map["prbeh"]
        insti <- map["insti"]
        endda <- map["endda"]
        etype <- map["etype"]
        etypename <- map["etypename"]
        hetyp <- map["hetyp"]
        hacde <- map["hacde"]
        dacde <- map["dacde"]
        actur <- map["actur"]
        spec1 <- map["spec1"]
        spec2 <- map["spec2"]
        etype1 <- map["etype1"]
        flow_ID <- map["flow_ID"]
    }
}

class EducationInfoResponse: HRMSResponse {
    var paramList: EducationParams? //[String: [ParamModel]] = [:]
    var educations: [EducationInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        paramList <- map["params"]
        educations <- map["educations"]
    }
}
