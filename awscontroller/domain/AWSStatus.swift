//
//  AWSStatus.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation

enum AWSStatus: String {
    case Running = "running"
    case Stopped = "stopped"
    case Rebooting = "rebooting"
    case Stopping = "stopping"
    case Pending = "pending"
    case ShuttingDown = "shutting-down"
    case Terminated = "terminated"
}
