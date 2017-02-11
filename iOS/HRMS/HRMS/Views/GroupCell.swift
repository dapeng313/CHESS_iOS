//
//  GroupCell.swift
//  HRMS
//
//  Created by Apollo on 1/18/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class GroupCell: UICollectionViewCell {
    
    var mainView = UIImageView()
    var overlayView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sv(
            mainView,
            overlayView.style(overlayStyle)
        )
        
        layout(
            mainView.centerInContainer().fillContainer(),
            overlayView
        )

        mainView.image = UIImage(named: "order_done")!
        overlayView.image = UIImage(named: "done")!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func overlayStyle(i: UIImageView) {
        i.height(20)
    }
    
}
