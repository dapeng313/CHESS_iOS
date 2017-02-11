//
//  AccordionHeaderView.swift
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 10/5/15.
//  Copyright © 2015 Fuzz. All rights reserved.
//

import UIKit
import FZAccordionTableView
import Stevia


class ResumeInfoHeader: FZAccordionTableViewHeaderView {
    static let kDefaultResumeInfoHeaderHeight: CGFloat = 50.0;
    static let kResumeInfoHeaderReuseId = "ResumeInfoHeaderReuseId";

    var titleView = UIView()
    var titleLabel = UILabel()
    var btnUpDown = UIButton()
    
    let mainInfoGradientLayer = CAGradientLayer()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        sv(
            titleView.sv(
                titleLabel,
                btnUpDown
            )
        )

        titleLabel.style(titleStyle)
        
        btnUpDown.setImage(UIImage(named: "down"), for: .normal)
        
        titleView.layout(
            |titleLabel.width(>=200).centerInContainer()-btnUpDown.size(30).centerVertically()-10-|
        )
        
        mainInfoGradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 50)
        mainInfoGradientLayer.colors = [UIColor(white: 0, alpha: 0).cgColor, UIColor(white:0, alpha:0.2).cgColor]
        mainInfoGradientLayer.locations = [0.6, 0.9]
        //self.layer.insertSublayer(mainInfoGradientLayer, at: 0)
        
        layout(
            titleView.fillHorizontally(m: 20).fillVertically().centerHorizontally()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func titleStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 15)
        l.textAlignment = .center
        l.textColor = UIColor.white
    }

    func updateFrame() {
        self.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
}
