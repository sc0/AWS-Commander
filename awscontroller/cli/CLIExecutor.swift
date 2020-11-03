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
    
    func getProfiles(callback: @escaping ([String]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            do {
                let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["configure", "list-profiles"])
                let profiles = output.components(separatedBy: "\n")
                callback(profiles)
            } catch {
                let error = error as! ShellOutError
                print(error.message)
                print(error.output)
                callback([])
            }
        }
    }
    
    func getEC2Instances(profile: String, callback: @escaping ([AWSInstance]) -> ()) {
        DispatchQueue.global(qos: .background).async {
            do {
                let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "describe-instances", "--profile", profile] + self.standardFlags)
                let instances = self.ec2Parser.parse(json: output, profile: profile)
                callback(instances)
            } catch {
                let error = error as! ShellOutError
                print(error.message)
                print(error.output)
                callback([])
            }
        }
        
    }
    
    func startEC2Instance(instance: AWSInstance, callback: @escaping () -> ()) {
        print("Starting \(instance.name)...")
        DispatchQueue.global(qos: .background).async {
            do {
                let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "start-instances", "--profile", instance.profile] + self.standardFlags + [ "--instance-ids", instance.identifer])
                print(output)
                callback()
            } catch {
                let error = error as! ShellOutError
                print(error.message)
                print(error.output)
                callback()
            }
        }
    }
    
    func restartEC2Instance(instance: AWSInstance, callback: @escaping () -> ()) {
        print("Restarting \(instance.name)...")
        DispatchQueue.global(qos: .background).async {
            do {
                let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "reboot-instances", "--profile", instance.profile] + self.standardFlags + [ "--instance-ids", instance.identifer])
                print(output)
                callback()
            } catch {
                let error = error as! ShellOutError
                print(error.message)
                print(error.output)
                callback()
            }
        }
    }
    
    func stopEC2Instance(instance: AWSInstance, callback: @escaping () -> ()) {
        print("Stopping \(instance.name)...")
        DispatchQueue.global(qos: .background).async {
            do {
                let output = try shellOut(to: "/usr/local/bin/aws", arguments: ["ec2", "stop-instances", "--profile", instance.profile] + self.standardFlags + [ "--instance-ids", instance.identifer])
                print(output)
                callback()
            } catch {
                let error = error as! ShellOutError
                print(error.message)
                print(error.output)
                callback()
            }
        }
    }
}
