//
//  AWSParser.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation

protocol AWSParser {
    func parse(json: String, profile: String) -> [AWSInstance]
}
