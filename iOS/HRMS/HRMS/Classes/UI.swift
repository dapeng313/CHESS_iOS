//
//  UI.swift
//  HRMS
//
//  Created by Apollo on 1/13/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation
import AvatarImageView

struct Colors {

    static let primary: UIColor = UIColor(red: 16.0 / 255.0, green: 128.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0) //(hex: "#1080c0")
    static let backColor: UIColor = UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0) //(hex: "#e9e9e9")
    static let textColor: UIColor = UIColor(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0) //(hex: "#505050")
}

struct AvatarConfig: AvatarImageViewConfiguration {
    var shape: Shape = .circle
}

struct AvatarDataSource: AvatarImageViewDataSource {
    var name: String
    var avatar: UIImage?
    
    init() {
        name = ""
    }
}

let MAIN_COLORS: [UIColor] = [UIColor(red: 238.0 / 255.0, green: 148.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0),
                            UIColor(red: 219.0 / 255.0, green: 99.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0),
                            UIColor(red: 98.0 / 255.0, green: 218.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0),
                            UIColor(red: 250.0 / 255.0, green: 167.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0),
                            UIColor(red: 107.0 / 255.0, green: 204.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0),
                            UIColor(red: 255.0 / 255.0, green: 65.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0),
                            UIColor(red: 77.0 / 255.0, green: 109.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0),
                            Colors.primary]

let APP_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let APP_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

func cellLabelStyle(l: UILabel) {
    l.font = .systemFont(ofSize: 12)
    l.numberOfLines = 1
    l.textAlignment = .center
    l.textColor = Colors.textColor
}

func leftLabelStyle(l: UILabel) {
    l.font = .systemFont(ofSize: 14)
    l.textAlignment = .left
    l.textColor = Colors.textColor
}

func leftLabelStyleBlue(l: UILabel) {
    l.font = .systemFont(ofSize: 14)
    l.textAlignment = .left
    l.textColor = Colors.primary
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func roundCorners(corners:UIRectCorner, boundRect: CGRect, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: boundRect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
