//
//  WorkFlowDetail.swift
//  HRMS
//
//  Created by Apollo on 2/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class AppealParams: HRMSModel {
    var par035: [ParamModel]?
    var par036: [ParamModel]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        par035 <- map["par035"]
        par036 <- map["par036"]
    }
}



class BaseAppealResponse: HRMSResponse {
    var workFlow: WorkFlow?
    var approvalList: [ApprovalInfo]?
    
    //AppealAbesnceResponse && AppealOvertimeResponse
    var params: AppealParams?

    //AppealAbesnceResponse
    var pt1001: PT1001?

    //AppealTravelResponse
    var pt1002: PT1002?
    
    //AppealOvertimeResponse
    var pt1003: PT1003?
    
    //AppealPunchResponse
    var pt1005: PT1005?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        workFlow <- map["workFlow"]
        approvalList <- map["approvalList"]
        
        pt1001 <- map["pt1001"]

        params <- map["paramMap"]
        
        pt1002 <- map["pt1002"]
        
        pt1003 <- map["pt1003"]

        pt1005 <- map["pt1005"]
    }
}
