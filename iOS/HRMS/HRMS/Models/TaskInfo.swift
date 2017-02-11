//
//  TaskInfo.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import ObjectMapper


class TaskInfo: HRMSModel {
    var id: String = ""
    var rows: Int = 0
    var skip: Int = 0
    var count: Int = 0
    var completeState: String = ""
    var excuteDetail: String = ""
    var excuteMember: String = ""
    var excuteName: String = ""
    var excutePlanState: String = ""
    var excuteState: String = ""
    var fromMember: String = ""
    var fromName: String = ""
    var taskCompleteDate: String = ""
    var taskDetails: String = ""
    var taskId: String = ""
    var taskRegulationDate: String = ""
    var taskStartDate: String = ""
    var taskTheme: String = ""
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        count <- map["count"]
        rows <- map["rows"]
        skip <- map["skip"]
        fromMember <- map["fromMember"]
        fromName <- map["fromName"]
        excuteMember <- map["excuteMember"]
        excuteName <- map["excuteName"]
        excuteDetail <- map["excuteDetail"]
        excutePlanState <- map["excutePlanState"]
        excuteState <- map["excuteState"]
        completeState <- map["completeState"]
        taskCompleteDate <- map["taskCompleteDate"]
        taskDetails <- map["taskDetails"]
        taskId <- map["taskId"]
        taskRegulationDate <- map["taskRegulationDate"]
        taskStartDate <- map["taskStartDate"]
        taskTheme <- map["taskTheme"]
    }
}

class NewTaskResponse: HRMSResponse {
    var taskInfo: TaskInfo?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        taskInfo <- map["taskProcess"]
    }
}

class TaskInfoResponse: HRMSResponse {
    var taskList: [TaskInfo]?
    
    required init?(map: Map) { super.init(map: map) }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        taskList <- map["rows"]
    }
}
