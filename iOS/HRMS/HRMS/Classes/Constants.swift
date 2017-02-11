//
// Created by Dapeng Wang on 3/16/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation


let NIM_SDK_APP_KEY   = "e2ba05df65fe219cf77637b01bc56930"
let NIM_SDK_CER_NAME   = "DEVELOPER"//"ENTERPRISE"

let AMAP_API_KEY   = "06dd66788c968643758a0a732784a1c7"

let API_URL   = "http://www.chess-top.com:8080/sys/"

let API_LOGIN                   = "member/mobile/memberLogin.do"
let API_GET_MEMBER              = "member/mobile/getMember.do"
let API_PHOTO                   = "photoimage/downloadPhoto.do?PERNR="
let API_PERSON_BASE             = "hrmanage/mobile/getPersonBaseInfo.do"
let API_SAVE_PERSON_BASE        = "hrmanage/mobile/savePersonBaseInfo.do"
let API_CONTACT_INFO            = "hrmanage/mobile/getContactInfo.do"
let API_SAVE_CONTACT_INFO       = "hrmanage/mobile/saveContractInfo.do"
let API_REMOVE_CONTACT_INFO     = "hrmanage/mobile/removeContractInfo.do"
let API_EVENT_INFO              = "hrmanage/mobile/getEventInfo.do"
let API_SAVE_EVENT_INFO         = "hrmanage/employee/savePersonEvent.do"
let API_REMOVE_EVENT_INFO       = "hrmanage/employee/removePersonEvent.do"
let API_EDUCATION_INFO          = "hrmanage/mobile/getEducationInfo.do"
let API_SAVE_EDUCATION_INFO     = "hrmanage/mobile/saveEducationInfo.do"
let API_REMOVE_EDUCATION_INFO   = "hrmanage/mobile/removeEducationInfo.do"

let API_WORKEXP_INFO            = "hrmanage/mobile/getWorkExpInfo.do"
let API_SAVE_WORKEXP_INFO       = "hrmanage/mobile/saveWorkExperienceInfo.do"
let API_REMOVE_WORKEXP_INFO     = "hrmanage/mobile/removeWorkExperienceInfo.do"
let API_TRAIN_INFO              = "hrmanage/mobile/getTrainInfo.do"
let API_SAVE_TRAIN_INFO         = "hrmanage/mobile/saveTrainInfo.do"
let API_REMOVE_TRAIN_INFO       = "hrmanage/mobile/removeTrainInfo.do"
let API_TITLE_INFO              = "hrmanage/mobile/getTitleInfo.do"
let API_SAVE_TITLE_INFO         = "hrmanage/mobile/saveTitleInfo.do"
let API_REMOVE_TITLE_INFO       = "hrmanage/mobile/removeTitleInfo.do"
let API_SKILL_INFO              = "hrmanage/mobile/getSkillInfo.do"
let API_UPLOAD_PHOTO            = "photoimage/mobile/uploadPhoto.do"

let API_SEARCH_COURSE           = "training/mobile/searchCourse.do"

// Attendance
let API_PUNCH_INFO_FOR_MONTH    = "attendance/mobile/getPunchListForMonth.do"
let API_GET_SHIFT_INFO          = "attendance/punch/mobile/getShiftInfo.do"
let API_SAVE_PUNCH_INFO         = "attendance/punch/mobile/savePunchInfo.do"

// Salary
let API_SALARY_DETAILS          = "salary/mobile/salaryDetails.do"

// Performance
let API_PERFORMANCE_INFO        = "hrmanage/mobile/getPerformanceList.do"

// Training
let API_PERSON_EVENT_LIST       = "hrmanage/mobile/listPersonEvent.do"
let API_COURSE_LIST_INFO        = "training/mobile/courseStatusList.do"
let API_COURSE_SAVE_INFO        = "training/mobile/saveCourse.do"
let API_COURSE_UPDATE_INFO      = "training/mobile/updateCourseStatus.do"

// Log
let API_LOG_LIST_INFO           = "log/mobile/logList.do"
let API_LOG_SAVE_INFO           = "log/mobile/saveLog.do"
let API_LOG_REMOVE              = "log/mobile/removeLog.do"

// WorkFlow
let API_WORKFLOW_01             = "workflow/mobile/workFlowList.do?STATUS=01"
let API_WORKFLOW_02             = "workflow/mobile/appliedAppealList.do?STATUS=01"
let API_WORKFLOW_03             = "workflow/mobile/handledAppealList.do"
let API_WORKFLOW_04             = "workflow/mobile/passedAppealList.do"
let API_WORKFLOW_05             = "workflow/mobile/rejectedAppealList.do"
let API_WORKFLOW_06             = "workflow/mobile/totalAppealList.do"

let API_WORKFLOW_11             = "workflow/mobile/approvalList.do?STATUS=02"
let API_WORKFLOW_12             = "workflow/mobile/processedApprovalList.do"
let API_WORKFLOW_13             = "workflow/mobile/finishedApprovalList.do"
let API_WORKFLOW_14             = "workflow/mobile/totalApprovalList.do"

let API_WORKFLOW_DETAILS_01     = "workflow/mobile/dailyDetailsApproval.do"
let API_WORKFLOW_DETAILS_02     = "workflow/mobile/leaveDetailsApproval.do"
let API_WORKFLOW_DETAILS_03     = "workflow/mobile/travelDetailsApproval.do"
let API_WORKFLOW_DETAILS_04     = "workflow/mobile/overtimeDetailsApproval.do"
let API_WORKFLOW_DETAILS_05     = "workflow/mobile/punchDetailsApproval.do"
let API_GET_OLD_CLODA_INFO      = "workflow/mobile/getOldClodaInfo.do"

let API_TASK_LIST               = "workflow/mobile/taskList.do"
let API_NEW_TASK                = "workflow/mobile/newTask.do"
let API_SAVE_TASK               = "workflow/mobile/saveTask.do"

let API_SAVE_APPEAL_DAILY       = "workflow/mobile/saveDailyAppeal.do"
let API_SAVE_APPEAL_LEAVE       = "workflow/mobile/saveLeaveAppeal.do"
let API_SAVE_APPEAL_TRAVEL      = "workflow/mobile/saveTravelAppeal.do"
let API_SAVE_APPEAL_OVERTIME    = "workflow/mobile/saveOvertimeAppeal.do"
let API_SAVE_APPEAL_PUNCH       = "workflow/mobile/savePunchAppeal.do"

let API_SAVE_APPROVAL           = "workflow/mobile/saveApproval.do"

// subordinate
let API_ACADEMIC_WEBVIEW     = "hrmanage/manager/mobile/webview/employinfo.do?memberID="
let API_ATTENDANCE_WEBVIEW   = "hrmanage/manager/mobile/webview/attendance.do?memberID="
let API_SALARY_WEBVIEW       = "hrmanage/manager/mobile/webview/salary.do?memberID="
let API_ASSESS_WEBVIEW       = "hrmanage/manager/mobile/webview/assess.do?memberID="
let API_TASK_WEBVIEW         = "hrmanage/manager/mobile/subordinates/taskWebView.do?memberID="
let API_TRAINING_WEBVIEW     = "hrmanage/manager/mobile/webview/training.do?memberID="

let API_SUBORDINATES_LIST    = "hrmanage/manager/mobile/subordinates/list.do"
let API_ACADEMIC_CHART       = "hrmanage/manager/mobile/subordinates/academicChart.do"
let API_ATTENDANCE_CHART     = "hrmanage/manager/mobile/subordinates/attendanceChart.do"
let API_SALARY_CHART         = "hrmanage/manager/mobile/subordinates/salaryChart.do"
let API_TASK_CHART           = "hrmanage/manager/mobile/subordinates/taskChart.do"
let API_ASSESS_CHART         = "hrmanage/manager/mobile/subordinates/assessChart.do"
let API_SURBO_EVENT_LIST     = "hrmanage/manager/mobile/subordinates/listTrainingEvent.do"

let API_TRAINING_CHART       = "hrmanage/manager/mobile/subordinates/trainingChart.do"

let API_PERSON_EVENT_STATUS   = "hrmanage/mobile/listPersonEvent.do?type=PA1008&page=1&rows=10"
let API_SAVE_PHONE_NUMBER     = "hrmanage/employee/mobile/saveCommunicationInfo.do"

let API_ORG_UNIT_TREE        = "organize/mobile/listOrgUnitTreeJsonData.do"

let API_SEND_EMAIL           = "member/mobile/sendSystemEmail.do"

