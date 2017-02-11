//
//  BarChartFormatter.swift
//  HRMS
//
//  Created by Apollo on 2/1/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
   
    var strings: [String]!

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return strings[Int(value)]
    }
 
}
