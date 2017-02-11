//
//  PA100x.swift
//  HRMS
//
//  Created by Apollo on 1/26/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper

class PA100x: HRMSModel {
    
    var id: Int = 0
    var filter: String = ""
    var pernr: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        id <- map["id"]
        filter <- map["filter"]
        pernr <- map["pernr"]
    }

}

class PA1001: PA100x {

    var begda: String = "0000-00-00"
    var ranks: String = ""
    var plans: String = ""
    var plansname: String = ""
    var orgeh: String = ""
    var orgehname: String = ""
    var bukrs: String = ""
    var kostl: String = ""
    var werks: String = ""
    var btrtl: String = ""
    var persg: String = ""
    var persk: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        begda <- map["begda"]
        ranks <- map["ranks"]
        plans <- map["plans"]
        plansname <- map["plansname"]
        orgeh <- map["orgeh"]
        orgehname <- map["orgehname"]
        bukrs <- map["bukrs"]
        kostl <- map["kostl"]
        werks <- map["werks"]
        btrtl <- map["btrtl"]
        persg <- map["persg"]
        persk <- map["persk"]
    }
}

class PA1002: PA100x {
    
    var nachn: String = ""
    var endat: String = "0000-00-00"
    var jwdat: String = "0000-00-00"
    var gesch: String = ""
    var vorna: String = ""
    var perid: String = ""
    var gbdat: String = "0000-00-00"
    var natio: String = ""
    var racky: String = ""
    var gbdep: String = ""
    var gbort: String = ""
    var fatxt: String = ""
    var pcode: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        nachn <- map["nachn"]
        endat <- map["endat"]
        jwdat <- map["jwdat"]
        gesch <- map["gesch"]
        vorna <- map["vorna"]
        perid <- map["perid"]
        gbdat <- map["gbdat"]
        natio <- map["natio"]
        racky <- map["racky"]
        gbdep <- map["gbdep"]
        gbort <- map["gbort"]
        fatxt <- map["fatxt"]
        pcode <- map["pcode"]
    }
}
