//
//  AWSInstance.swift
//  awscontroller
//
//  Created by Kacper Debowski on 22/10/2020.
//

import Foundation

class AWSInstance {
    var name: String
    var status: AWSStatus
    var type: AWSInstanceType
    var identifer: String
    var id: Int
    var profile: String
    
    init(type: AWSInstanceType, name: String, identifier: String, status: String, profile: String) {
        id = UUID().hashValue
        print(id)
        self.name = name
        self.type = type
        self.status = AWSStatus(rawValue: status)!
        self.identifer = identifier
        self.profile = profile
    }
    
    func getTitle() -> String {
        var statusIcon: String
        
        switch status {
        case AWSStatus.Running:
            statusIcon = "🟢"
        case AWSStatus.Rebooting:
            statusIcon = "🔵"
        case AWSStatus.Stopped:
            statusIcon = "🔴"
        default:
            statusIcon = "🟠"
        }
        
        return "\(statusIcon)\t\(name)\t[\(String(describing: status))]"
    }
    
}
