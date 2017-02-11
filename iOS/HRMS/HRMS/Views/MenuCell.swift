//
//  MenuCell.swift
//  HRMS
//
//  Created by Apollo on 1/5/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Stevia

class MenuCell: UICollectionViewCell {

    var iconView = UIImageView()
    var titleView = UILabel()
    var btnView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        sv(
            iconView,
            titleView.style(titleStyle),
            btnView
        )

        layout(
            >=17,
            iconView.size(20),
            12,
            titleView.fillHorizontally(),
            >=7
        )

        btnView.size(10).right(10).top(10)
        alignVertically(iconView, titleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func titleStyle(l: UILabel) {
        l.font = .systemFont(ofSize: 9)
        l.textAlignment = .center
        l.textColor = Colors.primary
    }

}
