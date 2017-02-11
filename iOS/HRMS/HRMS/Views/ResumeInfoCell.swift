//
//  BaseResumeCell.swift
//  HRMS
//
//  Created by Apollo on 1/23/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class ResumeInfoCell: UITableViewCell {
    
    var mainView = UIView()
    var keyLabel = UILabel()
    var valueLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            mainView.sv(
                keyLabel,
                valueLabel
            )
        )
        
        keyLabel.style(labelStyle)
        valueLabel.style(labelStyle)
        
       
        mainView.layout(
            |-keyLabel.width(>=80).centerVertically()-10-valueLabel.width(>=150).centerVertically()
        )
        
        layout(
            mainView.fillHorizontally(m: 20).centerVertically()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 12)
        l.textAlignment = .left
        l.textColor = UIColor.darkGray
    }
    
    func updateFrame() {
        self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
}
