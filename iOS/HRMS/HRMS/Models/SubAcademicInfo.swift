//
//  SubAcademicInfo.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import Foundation
import ObjectMapper

class SubAcademicInfoResponse: HRMSResponse {
    var masterList: [EducationInfo]?
    var universityList: [EducationInfo]?
    var collegeList: [EducationInfo]?
    var highSchoolList: [EducationInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        masterList <- map["masterList"]
        universityList <- map["universityList"]
        collegeList <- map["collegeList"]
        highSchoolList <- map["highSchoolList"]
    }
}
