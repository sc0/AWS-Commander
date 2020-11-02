//
//  AWSEC2Parser.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation

class EC2Parser : AWSParser {
    func parse(json: String, profile: String) -> [AWSInstance] {
        do {
            if let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8), options: []) as? [String: Any] {
                let wrapper = JSONWrapper(val: parsed)
                let instances = wrapper.getArrayForKey(key: "Reservations")[0]
                    .getArrayForKey(key: "Instances")
                
                var awsInstances: [AWSInstance] = []
                
                instances.forEach({
                    instance in
                    let name = instance.val["KeyName"] as! String
                    let status = instance.getDictForKey(key: "State").val["Name"] as! String
                    let identifier = instance.val["InstanceId"] as! String
                    let awsInstance = AWSInstance(type: AWSInstanceType.EC2, name: name, identifier: identifier, status: status, profile: profile)
                    
                    awsInstances.append(awsInstance)
                })
            
                return awsInstances
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return []
        }
        
        return []
    }
}
