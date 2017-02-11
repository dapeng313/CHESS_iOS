//
//  HRMSSessionUtil.h
//
//  Created by ght on 15-1-27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

import Foundation
import AVFoundation

class HRMSSessionUtil: NSObject {
    
    var OnedayTimeIntervalValue: Double = 24 * 60 * 60


//    class func getImageSize(withImageOriginSize originSize: CGSize, minSize imageMinSize: CGSize, maxSize imageMaxSiz: CGSize) -> CGSize {
//        var size: CGSize
//        var imageWidth = originSize.width
//        var imageHeight = originSize.height
//        var imageMinWidth = imageMinSize.width
//        var imageMinHeight = imageMinSize.height
//        var imageMaxWidth = imageMaxSiz.width
//        var imageMaxHeight = imageMaxSiz.height
//        if imageWidth > imageHeight {
//            size.height = imageMinHeight
//            //高度取最小高度
//            size.width = imageWidth * imageMinHeight / imageHeight
//            if size.width > imageMaxWidth {
//                size.width = imageMaxWidth
//            }
//        }
//        else if imageWidth < imageHeight {
//            size.width = imageMinWidth
//            size.height = imageHeight * imageMinWidth / imageWidth
//            if size.height > imageMaxHeight {
//                size.height = imageMaxHeight
//            }
//        }
//        else {
//            if imageWidth > imageMaxWidth {
//                size.width = imageMaxWidth
//                size.height = imageMaxHeight
//            }
//            else if imageWidth > imageMinWidth {
//                size.width = imageWidth
//                size.height = imageHeight
//            }
//            else {
//                size.width = imageMinWidth
//                size.height = imageMinHeight
//            }
//        }
//
//        return size
//    }
//
//    class func showNick(_ uid: String, in session: NIMSession) -> String {
//        var nickname: String? = nil
//        if session.sessionType == NIMSessionTypeTeam {
//            var member = NIMSDK.shared().teamManager.teamMember(uid, inTeam: session.sessionId)
//            nickname = member.nickname
//        }
//        if !nickname!.characters.count {
//            var info = NIMKit.shared().info(byUser: uid, option: nil)
//            nickname = info.showName()
//        }
//        return nickname
//    }
//    //接收时间格式化
//
//    class func showTime(_ msglastTime: TimeInterval, showDetail: Bool) -> String {
//            //今天的时间
//        var nowDate = Date()
//        var msgDate = Date(timeIntervalSince1970: msglastTime)
//        var result: String? = nil
//        var components = (([.year, .month, .day, .weekday, .hour, .minute]) as! NSCalendar.Unit)
//        var nowDateComponents = Calendar.current.dateComponents(components, from: nowDate)
//        var msgDateComponents = Calendar.current.dateComponents(components, from: msgDate)
//        var hour = msgDateComponents.hour!
//        result = HRMSSessionUtil.getPeriodOfTime(hour, withMinute: msgDateComponents.minute!)
//        if hour > 12 {
//            hour = hour - 12
//        }
//        if nowDateComponents.day! == msgDateComponents.day! {
//            result = "\(result) \(hour):%02d"
//        }
//        else if nowDateComponents.day! == (msgDateComponents.day! + 1) {
//            result = showDetail ? "昨天\(result) \(hour):%02d" : "昨天"
//        }
//        else if nowDateComponents.day! == (msgDateComponents.day! + 2) {
//            result = showDetail ? "前天\(result) \(hour):%02d" : "前天"
//        }
//        else if nowDate.timeIntervalSince(msgDate) < 7 * OnedayTimeIntervalValue {
//            var weekDay = HRMSSessionUtil.weekdayStr(msgDateComponents.weekday!)
//            result = showDetail ? weekDay.appendingFormat("%@ %zd:%02d", result, hour, Int(msgDateComponents.minute!)) : weekDay
//        }
//        else {
//            var day = "\(msgDateComponents.year!)-\(msgDateComponents.month!)-\(msgDateComponents.day!)"
//            result = showDetail ? day.appendingFormat("%@ %zd:%02d", result, hour, Int(msgDateComponents.minute!)) : day
//        }
//
//        return result
//    }

    class func session(withInputURL inputURL: URL, outputURL: URL, blockHandler handler: @escaping (_: AVAssetExportSession) -> Void) {
        let asset = AVURLAsset(url: inputURL, options: nil)
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        session?.outputURL = outputURL
        session?.outputFileType = AVFileTypeMPEG4
        // 支持安卓某些机器的视频播放
        session?.shouldOptimizeForNetworkUse = true
        session?.exportAsynchronously(completionHandler: {(_: Void) -> Void in
            handler(session!)
        })
    }

    class func dict(byJsonData data: Data) -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any]? = nil
        if (data is Data) {
            var error: Error? = nil
            do {
//                dict = try JSONSerialization.jsonObject(withData: data, options: [])!
            }
            catch {
            }
            if error != nil {
//                DDLogError("dictByJsonData failed %@ error %@", data, error)
            }
        }
        return ((dict! is [AnyHashable: Any]) ? dict : nil)!
    }

    class func dict(byJsonString jsonString: String) -> [AnyHashable: Any] {
        if jsonString.characters.count == 0 {
//            return nil
        }
        var data = jsonString.data(using: String.Encoding.utf8)
        return HRMSSessionUtil.dict(byJsonData: data!)
    }

    class func canMessageBeForwarded(_ message: NIMMessage) -> Bool {
        if !message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryState.failed {
            return false
        }
        let messageobject = message.messageObject
        if ((messageobject as! NIMCustomObject).attachment is WhiteboardAttachment) {
            return false
        }

        if (messageobject is NIMNotificationObject) {
            return false
        }
        if (messageobject is NIMTipObject) {
            return false
        }
        return true
    }

    class func canMessageBeRevoked(_ message: NIMMessage) -> Bool {
        var isFromMe = (message.from == NIMSDK.shared().loginManager.currentAccount())
        var isToMe = (message.session?.sessionId == NIMSDK.shared().loginManager.currentAccount())

        var isDeliverFailed = !message.isReceivedMsg && message.deliveryState == NIMMessageDeliveryState.failed
        if !isFromMe || isToMe || isDeliverFailed {
            return false
        }

        var messageobject = message.messageObject
        if (messageobject is NIMTipObject) || (messageobject is NIMNotificationObject) {
            return false
        }

        if (messageobject is NIMCustomObject) && ((messageobject as! NIMCustomObject).attachment is WhiteboardAttachment) {
            return false
        }
        return true
    }

    class func tip(onMessageRevoked message: Any) -> String {
        var fromUid: String? = nil
        var session: NIMSession? = nil
        if (message is NIMMessage) {
            fromUid = (message as! NIMMessage).from
            session = (message as! NIMMessage).session
        }
        else if (message is NIMRevokeMessageNotification) {
            fromUid = (message as! NIMRevokeMessageNotification).fromUserId
            session = (message as! NIMRevokeMessageNotification).session
        }
//        else {
//            assert(0)
//        }

        var isFromMe = (fromUid! == NIMSDK.shared().loginManager.currentAccount())
        var tip = "你"
        if !isFromMe {
            switch session!.sessionType {
                case NIMSessionType.P2P:
                    tip = "对方"
                case NIMSessionType.team:
                    var option = NIMKitInfoFetchOption()
                    option.session = session
                    var info = NIMKit.shared().info(byUser: fromUid, option: option)
                    tip = info!.showName
                default:
                    break
            }
        }
        return "\(tip)撤回了一条消息"
    }

    class func addRecentSession(atMark session: NIMSession) {
        let recents = NIMSDK.shared().conversationManager.allRecentSessions()
        var recent: NIMRecentSession?
        for recent in recents! {
            if (recent.session?.isEqual(session))! {
                break
            }
        }
        let localExt: [AnyHashable: Any] = recent!.localExt ?? [:]
        var dict: [AnyHashable: Any] = localExt
//        let localExt = recent!.localExt ?? [:]
//        var dict = localExt
        dict["NIMRecentSessionAtMark"] = (true)
        NIMSDK.shared().conversationManager.updateRecentLocalExt(dict, recentSession: recent!)
    }

    class func removeRecentSession(atMark session: NIMSession) {
        let recents = NIMSDK.shared().conversationManager.allRecentSessions()
        var recent: NIMRecentSession?
        for recent in recents!{
            if (recent.session?.isEqual(session))! {
                break
            }
        }

        if recent != nil {
            var localExt: [AnyHashable: Any]? = recent?.localExt
            localExt?.removeValue(forKey: "NIMRecentSessionAtMark")
            NIMSDK.shared().conversationManager.updateRecentLocalExt(localExt, recentSession: recent!)
        }
    }

    class func recentSessionIs(atMark recent: NIMRecentSession) -> Bool {
        var localExt: [AnyHashable: Any]? = recent.localExt
        return (localExt!["NIMRecentSessionAtMark"] != nil)//.bool == true
    }

//
//    class func isTheSameDay(_ currentTime: TimeInterval, compareTime older: DateComponents) -> Bool {
//        var currentComponents = (([.year, .month, .day, .hour, .minute]) as! NSCalendar.Unit)
//        var current = Calendar.current.dateComponents(currentComponents, from: Date(timeIntervalSinceNow: currentTime))
//        return current.year! == older.year! && current.month! == older.month! && current.day! == older.day!
//    }
//
//    class func weekdayStr(_ dayOfWeek: Int) -> String {
//        var daysOfWeekDict: [AnyHashable: Any]? = nil
//        daysOfWeekDict = [(1): "星期日", (2): "星期一", (3): "星期二", (4): "星期三", (5): "星期四", (6): "星期五", (7): "星期六"]
//        return (daysOfWeekDict![(dayOfWeek)] as! String)
//    }
//
//    class func string(from messageTime: TimeInterval, components: NSCalendar.Unit) -> DateComponents {
//        var dateComponents = Calendar.current.dateComponents(components, from: Date(timeIntervalSince1970: messageTime))
//        return dateComponents
//    }
//
//    class func getPeriodOfTime(_ time: Int, withMinute minute: Int) -> String {
//        var totalMin = time * 60 + minute
//        var showPeriodOfTime = ""
//        if totalMin > 0 && totalMin <= 5 * 60 {
//            showPeriodOfTime = "凌晨"
//        }
//        else if totalMin > 5 * 60 && totalMin < 12 * 60 {
//            showPeriodOfTime = "上午"
//        }
//        else if totalMin >= 12 * 60 && totalMin <= 18 * 60 {
//            showPeriodOfTime = "下午"
//        }
//        else if (totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0 {
//            showPeriodOfTime = "晚上"
//        }
//
//        return showPeriodOfTime
//    }
}

