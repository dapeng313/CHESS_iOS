//
//  PT100x.swift
//  HRMS
//
//  Created by Apollo on 1/21/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class PT100x: HRMSModel {

    var PERNR: String = ""
    var BEGDA: String = ""
    var ENDDA: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        PERNR <- map["pernr"]
        BEGDA <- map["begda"]
        ENDDA <- map["endda"]
    }

    func getDate() -> String {
        return BEGDA
    }
}

class PT1004: PT100x {
    
    var ROW_ID: UInt64 = 0
    var CLODA: String = ""
    var CLOIN: String = "00:00:00"
    var CINAD: String = ""
    var CLOOU: String = "00:00:00"
    var COUAD: String = ""
    var CLORM: String = ""
    var EXTIM: Double = 0
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        CLODA <- map["nodeId"]
        CLOIN <- map["nodeType"]
        CINAD <- map["text"]
        CLOOU <- map["nodeId"]
        COUAD <- map["nodeType"]
        CLORM <- map["text"]
        EXTIM <- map["nodeId"]
    }
}

class PT1001: PT100x {
    
    var abtyp: String = ""
    var abday: String = ""
    var abtim: String = "00:00:00"
    var abren: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        abtyp <- map["abtyp"]
        abday <- map["abday"]
        abtim <- map["abtim"]
        abren <- map["abren"]
    }
}

class PT1002: PT100x {

    var trtim: String = ""
    var trday: String = "00:00:00"
    var trsta: String = ""
    var trdes: String = "00:00:00"
    var trbud: String = ""
    var trren: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        trtim <- map["trtim"]
        trday <- map["trday"]
        trsta <- map["trsta"]
        trdes <- map["trdes"]
        trbud <- map["trbud"]
        trren <- map["trren"]
    }
}

class PT1003: PT100x {

    var ottyp: String = ""
    var otday: String = "00:00:00"
    var ottim: String = ""
    var otren: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ottyp <- map["ottyp"]
        otday <- map["otday"]
        ottim <- map["ottim"]
        otren <- map["otren"]
    }
}

class PT1005: PT100x {
    
    var oloin: String = ""
    var cloda: String = "00:00:00"
    var mloin: String = ""
    var oinad: String = ""
    var minad: String = ""
    var oloou: String = ""
    var mloou: String = ""
    var oouad: String = ""
    var mouad: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        cloda <- map["cloda"]
        oloin <- map["oloin"]
        mloin <- map["mloin"]
        oinad <- map["oinad"]
        minad <- map["minad"]
        oloou <- map["oloou"]
        mloou <- map["mloou"]
        oouad <- map["oouad"]
        mouad <- map["mouad"]
    }
}
