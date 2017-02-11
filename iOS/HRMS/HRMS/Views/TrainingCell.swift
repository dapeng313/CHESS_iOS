//
//  TrainingCell.swift
//  HRMS
//
//  Created by Apollo on 2/7/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class TrainingCell: UITableViewCell {
    
    var typeView = UIView()
    var typeIcon = UIImageView()
    var typeLabel = UILabel()
    var mainView = UIView()
    var nameLabel = UILabel()
    var dateLabel = UILabel()
    var stateLabel = UILabel()
    var arrowIcon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            typeView.sv(
                typeIcon,
                typeLabel
            ),
            mainView.sv(
                nameLabel,
                dateLabel
            ),
            stateLabel,
            arrowIcon
        )
        
        typeView.layout(
            10,
            typeIcon.size(20).centerHorizontally(),
            10,
            typeLabel.width(80).centerHorizontally(),
            10
        )
        alignVertically(typeIcon, typeLabel)
        typeLabel.style(titleStyle)

        mainView.layout(
            10,
            nameLabel.fillHorizontally(),
            10,
            dateLabel.fillHorizontally(),
            10
        )
        alignVertically(nameLabel, dateLabel)
       
        nameLabel.style(labelStyle)
        dateLabel.style(labelStyle)
        stateLabel.style(labelStyle)

        arrowIcon.image = UIImage(named: "right")!
        layout(
            |-typeView.width(80).centerVertically()-20-mainView.width(>=120).centerVertically()-10-stateLabel.centerVertically()-10-arrowIcon.width(5).height(10).centerVertically()-|
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func labelStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 11)
        l.textAlignment = .left
        l.textColor = UIColor.darkGray
    }
    
    func titleStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 13)
        l.textAlignment = .center
        l.textColor = UIColor.darkGray
    }
}
