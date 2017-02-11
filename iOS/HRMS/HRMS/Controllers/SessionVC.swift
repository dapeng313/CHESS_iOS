//
//  SessionVC.swift
//  HRMS
//
//  Created by Apollo on 1/9/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Stevia
import Toast


class SessionVC: NIMSessionViewController, UINavigationControllerDelegate, NIMMediaManagerDelgate {

    var isDisableCommandTyping = false
    
    var config = HRMSSessionConfig()
    var mediaFetcher = NIMKitMediaFetcher()

    override func viewDidLoad() {
        super.viewDidLoad()

        //删除最近会话列表中有人@你的标记
        HRMSSessionUtil.removeRecentSession(atMark: self.session)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let enterTeamCard = UIButton(type: .custom)
        enterTeamCard.addTarget(self, action: #selector(self.enterTeamCard), for: .touchUpInside)
        enterTeamCard.setImage(UIImage(named: "icon_session_info_pressed"), for: .normal)
        enterTeamCard.setImage(UIImage(named: "icon_session_info_pressed"), for: .highlighted)
        enterTeamCard.sizeToFit()
        let enterTeamCardItem = UIBarButtonItem(customView: enterTeamCard)

        let infoBtn = UIButton(type: .custom)
        infoBtn.addTarget(self, action: #selector(self.onTouchUpInfoBtn), for: .touchUpInside)
        infoBtn.setImage(UIImage(named: "icon_session_info_pressed"), for: .normal)
        infoBtn.setImage(UIImage(named: "icon_session_info_pressed"), for: .highlighted)
        infoBtn.sizeToFit()
        let enterUInfoItem = UIBarButtonItem(customView: infoBtn)

        if self.session.sessionType == NIMSessionType.team {
            self.navigationItem.rightBarButtonItem = enterTeamCardItem
        } else if self.session.sessionType == NIMSessionType.P2P {
            self.navigationItem.rightBarButtonItem = enterUInfoItem
        }
        
        self.navigationItem.title = NSLocalizedString("chat", comment: "")
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: 75)
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NIMSDK.shared().mediaManager.stopRecord()
        NIMSDK.shared().mediaManager.stopPlay()
    }

    override func sessionConfig() -> NIMSessionConfig {
        if self.config == nil {
            self.config = HRMSSessionConfig()
        }
        return self.config
    }

    override func onSelectChartlet(_ chartletId: String, catalog catalogId: String) {
        let attachment = ChartletAttachment()
        attachment.chartletId = chartletId
        attachment.chartletCatalog = catalogId
        self.send(SessionMsgConverter.msg(with: attachment))
    }

// MARK: - 白板
    func onTapMediaItemWhiteBoard(_ item: NIMMediaItem) {
        let vc = WhiteboardViewController(sessionID: self.session.sessionId, info: "白板演示")
        self.navigationController?.pushViewController(vc!, animated: false)
    }

// MARK: - 录音事件
    override func onRecordFailed(_ error: Error?) {
        self.view.makeToast("录音失败", duration: 2, position: CSToastPositionCenter)
    }
    
    override func recordFileCanBeSend(_ filepath: String) -> Bool {
        let url = URL(fileURLWithPath: filepath)
        let urlAsset = AVURLAsset(url: url, options: nil)
        let time = urlAsset.duration
        let mediaLength: CGFloat = CGFloat(CMTimeGetSeconds(time))
        return mediaLength > 2
    }
    
    override func showRecordFileNotSendReason() {
        self.view.makeToast("录音时间太短", duration: 0.2, position: CSToastPositionCenter)
    }

// MARK: - Cell事件
    override func onTapCell(_ event: NIMKitEvent) {
        var handled = false
        let eventName = event.eventName
        if (eventName == NIMKitEventNameTapContent) {
            let message = event.messageModel.message
            var actions = self.cellActions()
            let value = actions[(message?.messageType)!] as! String
            if !value.isEmpty {
                if let selector = NSSelectorFromString(value) as? Selector, self.responds(to: selector) {
                    self.perform(selector, with: message)
                    handled = true
                }
            }
        } else if (eventName == NIMKitEventNameTapLabelLink) {
            let link = event.data
            self.view.makeToast("tap link : \(link)", duration: 2, position: CSToastPositionCenter)
            handled = true
        }
        
        if !handled {
            assert(false, "invalid event")
        }
    }

// MARK: - Cell Actions
    
    func showImage(_ message: NIMMessage) {
        let object = message.messageObject as! NIMImageObject
        
        let item = GalleryItem()
        item.thumbPath = object.thumbPath
        item.imageURL = object.url
        item.name = object.displayName
        let vc = GalleryViewController(item: item)
        self.navigationController!.pushViewController(vc!, animated: true)
        if !FileManager.default.fileExists(atPath: object.thumbPath!) {
            //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
            weak var wself = self
            NIMSDK.shared().resourceManager.download(object.thumbUrl!, filepath: object.thumbPath!, progress: nil, completion: {(_ error: Error?) -> Void in
                if error == nil {
                    wself?.uiUpdate(message)
                }
            })
        }
    }
    
    func showVideo(_ message: NIMMessage) {
        let object = message.messageObject as! NIMVideoObject!
        let playerViewController = VideoViewController(videoObject: object)
        self.navigationController!.pushViewController(playerViewController!, animated: true)
        if !FileManager.default.fileExists(atPath: (object?.coverPath)!) {
            //如果封面图下跪了，点进视频的时候再去下一把封面图
            weak var wself = self
            NIMSDK.shared().resourceManager.download((object?.coverUrl!)!, filepath: (object?.coverPath!)!, progress: nil, completion: {(_ error: Error?) -> Void in
                if error == nil {
                    wself?.uiUpdate(message)
                }
            })
        }
    }
    
    func showLocation(_ message: NIMMessage) {
        let object = message.messageObject
        let locationPoint = NIMKitLocationPoint(locationObject: object as! NIMLocationObject!)
        let vc = NIMLocationViewController(locationPoint: locationPoint)
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func showFile(_ message: NIMMessage) {
//        let object = message.messageObject
//        var vc = NTESFilePreViewController(fileObject: object)
//        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func showCustom(_ message: NIMMessage) {
        //普通的自定义消息点击事件可以在这里做哦~
    }

// MARK: - 导航按钮
    
    func onTouchUpInfoBtn(_ sender: Any) {
//        var vc = NTESSessionCardViewController(session: self.session)
//        self.navigationController!.pushViewController(vc, animated: true)
    }

    func enterTeamCard(_ sender: Any) {
        let team = NIMSDK.shared().teamManager.team(byId: self.session.sessionId)
        var vc: UIViewController
        if team?.type == NIMTeamType.normal {
            vc = NIMNormalTeamCardViewController(team: team)
            self.navigationController!.pushViewController(vc, animated: true)
        } else if team?.type == NIMTeamType.advanced {
            vc = NIMAdvancedTeamCardViewController(team: team)
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }

// MARK: - 菜单
    
    override func menusItems(_ message: NIMMessage) -> [Any] {
        var items = [Any]()
        let defaultItems: [Any] = super.menusItems(message)
        if !defaultItems.isEmpty {
            items += defaultItems
        }
//        if HRMSSessionUtil.canMessageBeForwarded(message) {
//            items.append(UIMenuItem(title: "转发", action: #selector(self.forwardMessage as (Void) -> Void)))
//        }
//        if HRMSSessionUtil.canMessageBeRevoked(message) {
//            items.append(UIMenuItem(title: "撤回", action: #selector(self.revokeMessage)))
//        }
        if message.messageType == NIMMessageType.audio {
            items.append(UIMenuItem(title: "转文字", action: #selector(self.audio2Text)))
        }
        return items
    }
    
    func audio2Text(_ sender: Any) {
        let message = self.messageForMenu
        weak var wself = self
        let vc = Audio2TextViewController(message: message)
        vc?.completeHandler = {(_: Void) -> Void in
            wself?.uiUpdate(message)
        }
        self.present(vc!, animated: true, completion: { _ in })
    }

    func forwardMessage(_ sender: Any) {
//        var message = self.messageForMenu
//        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        var btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//            //  UIAlertController will automatically dismiss the view
//        })
//
//        var btnForward = UIAlertAction(title: "Choose Existing", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            var config = NIMContactTeamSelectConfig()
//            var vc = EmployeeTreeVC(config)
//            vc.finshBlock = {(_ array: [Any]) -> Void in
//                var teamId = array.first!
//                var session = NIMSession.session(teamId, type: NIMSessionTypeTeam)
//                weakSelf.forwardMessage(message, to: session)
//            }
//            vc.show()
//        })
//        alert.addAction(btnCancel)
//        alert.addAction(btnForward)
//
//        self.present(alert, animated: true, completion: { _ in })
    }
   
    func revokeMessage(_ sender: Any) {
//        var message = self.messageForMenu
//        weak var weakSelf = self
//        NIMSDK.shared().chatManager.revokeMessage(message!, completion: {(_ error: Error?) -> Void in
//            if error != nil {
//                if error!.code == NIMRemoteErrorCodeDomainExpireOld {
//                    var alert = UIAlertView(title: "", message: "发送时间超过2分钟的消息，不能被撤回", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "")
//                    alert.show()
//                }
//                else {
//                    weakSelf?.view.makeToast("消息撤回失败，请重试", duration: 2.0, position: CSToastPositionCenter)
//                }
//            } else {
//                var model = self.uiDelete(message)
//                var tip = SessionMsgConverter.msg(withTip: SessionUtil.tip(onMessageRevoked: message))
//                tip.timestamp = model.messageTime
//                self.uiInsertMessages([tip])
//                tip.timestamp = message.timestamp
//                // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
//                NIMSDK.shared().conversationManager.save(tip, for: message.session, completion: nil)
//            }
//        })
    }
    
    func forwardMessage(_ message: NIMMessage, to session: NIMSession) {
//        var name: String
//        if session.sessionType == NIMSessionType.P2P {
//            let option = NIMKitInfoFetchOption()
//            option.session = session
//            name = NIMKit.shared().info(byUser: session.sessionId, option: option).showName
//        }
//        else {
//            name = NIMKit.shared().info(byTeam: session.sessionId, option: nil).showName
//        }
//        var tip = "确认转发给 \(name) ?"
//
//        let alertController = UIAlertController(title: "确认转发", message: "Do you want to remove user?", preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) {
//            (result : UIAlertAction) -> Void in
//        }
//
//        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default) {
//            (result : UIAlertAction) -> Void in
////            weak var weakSelf = self
//            do {
//                try NIMSDK.shared().chatManager.forwardMessage(message, to: session)
//            } catch {
//            }
//            self.view?.makeToast("已发送", duration: 2.0, position: CSToastPositionCenter)
//        }
    }

    func cellActions() -> [AnyHashable: Any] {
        var actions: [AnyHashable: Any]? = nil
//        var onceToken: dispatch_once_t
//        dispatch_once(onceToken, {() -> Void in
            actions = [(NIMMessageType.image): "showImage:",
                       (NIMMessageType.video): "showVideo:",
                       (NIMMessageType.location): "showLocation:",
                       (NIMMessageType.file): "showFile:",
                       (NIMMessageType.custom): "showCustom:"]
//        })
        return actions!
    }

}
