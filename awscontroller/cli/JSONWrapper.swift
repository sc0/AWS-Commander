//
//  JSONWrapper.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation

class JSONWrapper {
    var val: [String: Any]
    
    init(val: [String: Any]) {
        self.val = val
    }
    
    func getArrayForKey(key: String) -> [JSONWrapper] {
        let ar = val[key] as! [Any]
        var res: [JSONWrapper] = []
        ar.forEach({
            v in
            res.append(JSONWrapper(val: v as! [String: Any]))
        })
        return res
    }
    
    func getDictForKey(key: String) -> JSONWrapper {
        let v = val[key] as! [String: Any]
        return JSONWrapper(val: v)
    }
}
