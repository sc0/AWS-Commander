//
//  AWSCommunicator.swift
//  awscontroller
//
//  Created by Kacper Debowski on 22/10/2020.
//

import Foundation
import ShellOut

class CLIExecutor {
    let ec2Parser = EC2Parser()
    
    let standardFlags = ["--output", "json", "--no-cli-pager"]
    
    func getProfiles() -> [String] {
        do {
            let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["configure", "list-profiles"])
            let profiles = output.components(separatedBy: "\n")
            return profiles
        } catch {
            let error = error as! ShellOutError
            print(error.message)
            print(error.output)
            return []
        }
    }
    
    func getEC2Instances(profile: String) -> [AWSInstance] {
        do {
            let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "describe-instances", "--profile", profile] + standardFlags)
            let instances = ec2Parser.parse(json: output, profile: profile)
            return instances
        } catch {
            let error = error as! ShellOutError
            print(error.message)
            print(error.output)
            return []
        }
    }
    
    func startEC2Instance(instance: AWSInstance) -> Bool {
        print("Starting \(instance.name)...")
        
        do {
            let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "start-instances", "--profile", instance.profile] + standardFlags + [ "--instance-ids", instance.identifer])
            print(output)
            return true
        } catch {
            let error = error as! ShellOutError
            print(error.message)
            print(error.output)
            return false
        }
    }
    
    func restartEC2Instance(instance: AWSInstance) -> Bool {
        print("Restarting \(instance.name)...")
        
        do {
            let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "reboot-instances", "--profile", instance.profile] + standardFlags + [ "--instance-ids", instance.identifer])
            print(output)
            return true
        } catch {
            let error = error as! ShellOutError
            print(error.message)
            print(error.output)
            return false
        }
        
    }
    
    func stopEC2Instance(instance: AWSInstance) -> Bool {
        print("Stopping \(instance.name)...")
        
        do {
            let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "stop-instances", "--profile", instance.profile] + standardFlags + [ "--instance-ids", instance.identifer])
            print(output)
            return true
        } catch {
            let error = error as! ShellOutError
            print(error.message)
            print(error.output)
            return false
        }
    }
}
