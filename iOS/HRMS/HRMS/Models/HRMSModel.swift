//
// Created by Dapeng Wang on 3/16/16.
// Copyright (c) 2016 Dapeng Wang. All rights reserved.
//

import Foundation
import EVReflection
import ObjectMapper

let intToString = TransformOf<String, Int>(fromJSON: { $0.map { String($0) } }, toJSON: { Int($0!) })
let doubleToDecimal = TransformOf<NSDecimalNumber, Double>(fromJSON: { $0.map { NSDecimalNumber(value: $0 as Double) } }, toJSON: { $0!.doubleValue })

class HRMSModel: NSObject, Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {}

    override init() {}
    
    override var description: String {
        return self.toJSONString(prettyPrint: true) ?? super.description
    }
    
    override var debugDescription: String {
        return self.toJSONString(prettyPrint: true) ?? super.debugDescription
    }
}
