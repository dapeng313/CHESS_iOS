//
//  PY200x.swift
//  HRMS
//
//  Created by Apollo on 1/30/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class PY200x: HRMSModel {
    
    var pernr: String = ""
    var begda: String = ""
    var endda: String = ""
    var filter: String = ""
    var nachn: String = ""
    var rows: String = ""
    var estua: String = ""
    var ysgz: Double = 0
    var mzse: Double = 0
    var ljsymzse: Double = 0
    var sj: Double = 0
    var comp_FLAG: String = ""
    var filter_ROWS: String = ""
    var STEXT: String = ""
    var SDATE: String = "0000-00-00"
    var ERR_FLAG: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        pernr <- map["pernr"]
        begda <- map["begda"]
        endda <- map["endda"]
        filter <- map["filter"]
        nachn <- map["nachn"]
        rows <- map["rows"]
        estua <- map["estua"]
        ysgz <- map["ysgz"]
        mzse <- map["mzse"]
        ljsymzse <- map["ljsymzse"]
        sj <- map["sj"]
        comp_FLAG <- map["comp_FLAG"]
        filter_ROWS <- map["filter_ROWS"]
        STEXT <- map["STEXT"]
        SDATE <- map["SDATE"]
        ERR_FLAG <- map["ERR_FLAG"]
    }
}

class PY2000: PY200x {
    var ljysgz: Double = 0
    var YFZJ: Double = 0
    var GRSDS: Double = 0
    var SFGZ: Double = 0
    var p1000: Double = 0
    var p1001: Double = 0
    var p1002: Double = 0
    var p1003: Double = 0
    var p1004: Double = 0
    var p1005: Double = 0
    var p1006: Double = 0
    var p1007: Double = 0
    var p1008: Double = 0
    var p1009: Double = 0
    var p1010: Double = 0
    var p3000: Double = 0
    var p3001: Double = 0
    var p3002: Double = 0
    var p3003: Double = 0
    var p3004: Double = 0
    var p3005: Double = 0
    var p3006: Double = 0
    var p3007: Double = 0
    var p3008: Double = 0
    var p3009: Double = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        ljysgz <- map["ljysgz"]
        YFZJ <- map["YFZJ"]
        GRSDS <- map["GRSDS"]
        SFGZ <- map["SFGZ"]
        p1000 <- map["p1000"]
        p1001 <- map["p1001"]
        p1002 <- map["p1002"]
        p1003 <- map["p1003"]
        p1004 <- map["p1004"]
        p1005 <- map["p1005"]
        p1006 <- map["p1006"]
        p1007 <- map["p1007"]
        p1008 <- map["p1008"]
        p1009 <- map["p1009"]
        p1010 <- map["p1010"]
        p1000 <- map["p1000"]
        p3001 <- map["p3001"]
        p3002 <- map["p3002"]
        p3003 <- map["p3003"]
        p3004 <- map["p3004"]
        p3005 <- map["p3005"]
        p3006 <- map["p3006"]
        p3007 <- map["p3007"]
        p3008 <- map["p3008"]
        p3009 <- map["p3009"]
    }
}

class PY2001: PY200x {
    var ljyfjz: Double = 0
    var ljgs: Double = 0
    var YFJZ: Double = 0
    var JJGS: Double = 0
    var SFJJ: Double = 0
    var p2000: Double = 0
    var p2001: Double = 0
    var p2002: Double = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ljyfjz <- map["ljyfjz"]
        ljgs <- map["ljgs"]
        YFJZ <- map["YFJZ"]
        JJGS <- map["JJGS"]
        SFJJ <- map["SFJJ"]
        p2000 <- map["p2000"]
        p2001 <- map["p2001"]
        p2002 <- map["p2002"]
    }
}

class PY2002: PY200x {
    
    var nzjj: Double = 0
    var ftyf: Double = 0
    var ftjj: Double = 0
    var sl: Double = 0
    var sskcs: Double = 0
    var YFJJ: Double = 0
    var JJGS: Double = 0
    var SFJJ: Double = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        nzjj <- map["nzjj"]
        ftyf <- map["ftyf"]
        ftjj <- map["ftjj"]
        sl <- map["sl"]
        sskcs <- map["sskcs"]
        YFJJ <- map["YFJJ"]
        JJGS <- map["JJGS"]
        SFJJ <- map["SFJJ"]
    }
}
