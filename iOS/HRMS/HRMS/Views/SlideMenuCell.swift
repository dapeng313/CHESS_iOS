//
//  SlideMenuCell.swift
//  HRMS
//
//  Created by Apollo on 2/2/17.
//  Copyright © 2017 Apollo. All rights reserved.
//


import UIKit
import Stevia

class SlideMenuCell: UITableViewCell {
    
    var mainView = UIView()
    var iconView = UIImageView()
    var titleLabel = UILabel()
    var rightView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            mainView.sv(
                iconView,
                titleLabel,
                rightView
            )
        )
        
        titleLabel.style(labelStyle)
    
        rightView.image = UIImage(named: "right")
        
        mainView.layout(
            |-iconView.size(30).centerVertically()-20-titleLabel.width(>=80).centerVertically()-rightView.width(10).height(20).centerVertically()-|
        )
        
        layout(
            mainView.height(50).fillHorizontally(m: 10).centerVertically()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 14)
        l.textAlignment = .left
        l.textColor = UIColor.darkGray
    }
    
    func updateFrame() {
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
}
