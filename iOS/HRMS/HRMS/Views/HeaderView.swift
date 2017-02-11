//
//  MenuCell.swift
//  HRMS
//
//  Created by Apollo on 1/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class HeaderView: UICollectionReusableView {

    var titleView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        sv(
            titleView.style(titleStyle)
        )

        layout(
            6,
            titleView.fillHorizontally(),
            2
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func titleStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 12)
        l.textAlignment = .center
        l.textColor = Colors.textColor
    }
}
