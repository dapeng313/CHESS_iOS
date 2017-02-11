//
//  BaseMemberCell.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class BaseMemberCell: UITableViewCell {
    
    var mainView = UIView()
    var avatarView = UIImageView()
    var nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            mainView.sv(
                avatarView,
                nameLabel
            )
        )
        
        nameLabel.style(labelStyle)
        avatarView.layer.cornerRadius = 20
        avatarView.layer.masksToBounds = true
        
        mainView.layout(
            |-10-avatarView.size(40).centerVertically()-20-nameLabel.width(>=150).centerVertically()
        )
        
        layout(
            mainView.height(80).fillHorizontally(m: 20).centerVertically()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 13)
        l.textAlignment = .left
        l.textColor = UIColor.darkGray
    }
}
