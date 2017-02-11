//
//  HRMSSessionConfig.swift
//  HRMS
//
//  Created by Apollo on 1/13/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
class HRMSSessionConfig: NSObject, NIMSessionConfig {

    func mediaItems() -> [NIMMediaItem]! {
        let defaultMediaItems = NIMKitUIConfig.shared().defaultMediaItems() as! [NIMMediaItem]

        let whiteBoard = NIMMediaItem("onTapMediaItemWhiteBoard:", normalImage: UIImage(named: "btn_whiteboard_invite_normal")!, selectedImage: UIImage(named: "btn_whiteboard_invite_pressed")!, title: "白板")

        let items: [NIMMediaItem] = [whiteBoard!]

        return defaultMediaItems + items
    }

    func shouldHandleReceipt() -> Bool {
        return true
    }
    
    func shouldHandleReceipt(for message: NIMMessage) -> Bool {
        //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
        let type = message.messageType

        if type == NIMMessageType.custom {
            let object: NIMCustomObject? = (message.messageObject as? NIMCustomObject)
            let attachment: Any? = object?.attachment
            if (attachment is WhiteboardAttachment) {
                return false
            }
        }

        return type == NIMMessageType.text || type == NIMMessageType.audio || type == NIMMessageType.image || type == NIMMessageType.video || type == NIMMessageType.file || type == NIMMessageType.location || type == NIMMessageType.custom
    }
}
