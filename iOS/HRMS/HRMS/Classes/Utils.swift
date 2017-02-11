//
//  Utils.swift
//  HRMS
//
//  Created by Apollo on 1/20/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

import Foundation

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}

extension Date {
    func getNextMonth() -> Date?{
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getPreviousMonth() -> Date?{
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
}

func throwEmpty (_ string: String?) -> String? {
    if string?.isEmpty == true || string == nil {
        return "-"
    }
    return string
}

func localFromUTCDate (_ date: Date) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    dateFormat.timeZone = TimeZone.current

    return dateFormat.date(from: dateFormat.string(from: date))!
}
