//
//  EC2MenuSection.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation
import Cocoa

class EC2MenuSection : MenuSection {
    var cli: CLIExecutor
    var menu: NSMenu!
    var statusItem: NSMenuItem
    var menuItems: [NSMenuItem]
    var offset: Int
    var awsInstances: [AWSInstance] = []
    var isRefreshing = false
    var refreshingFinishedCallback = {}
    
    required init (menu: NSMenu!, offset: Int, cli: CLIExecutor) {
        self.cli = cli
        self.menu = menu
        self.menuItems = []
        self.offset = offset
        self.statusItem = NSMenuItem()
        menu.insertItem(self.statusItem, at: offset)
    }

    func refresh(_ sender: AnyObject, callback: @escaping () -> ()) {
        print("refresh...")
        refreshingFinishedCallback = callback
        isRefreshing = true
        self.cli.getProfiles(callback: continueRefreshing)
    }
    
    func continueRefreshing(profilesList: [String]) {
        let settings = Preferences.fromUserDefaults(settings: UserDefaults.standard, profileList: profilesList)
        self.statusItem.title = "EC2 (profile: " + settings.selectedProfile + ")"
        self.statusItem.isEnabled = false
        self.cli.getEC2Instances(profile: settings.selectedProfile, callback: continueWithInstances)

    }
    
    func continueWithInstances(instances: [AWSInstance]) {
        self.awsInstances = instances
        
        self.menuItems.forEach({
            item in
            self.menu.removeItem(item)
        })
        
        self.menuItems.removeAll()
        
        self.awsInstances.forEach({
            aws in
            let item = NSMenuItem(title: aws.getTitle(), action: nil, keyEquivalent: "")
            item.submenu = self.getSubmenuForInstance(aws: aws)
            self.menuItems.append(item)
            self.menu.insertItem(item, at: self.offset + self.menuItems.count)
        })
        
        isRefreshing = false
        refreshingFinishedCallback()
    }
    
    
    func getSubmenuForInstance(aws: AWSInstance) -> NSMenu? {
        let result = NSMenu()
        result.autoenablesItems = false
        
        var items: [NSMenuItem] = []
        
        if aws.status == AWSStatus.Running {
            items = [
                NSMenuItem(title: "Restart", action: #selector(restartEC2Instance), keyEquivalent: ""),
                NSMenuItem(title: "Stop", action: #selector(stopEC2Instance), keyEquivalent: "")
            ]
        } else if aws.status == AWSStatus.Stopped {
            items = [
                NSMenuItem(title: "Start", action: #selector(startEC2Instance), keyEquivalent: "")
            ]
        }
        
        for item in items {
            item.target = self
            item.tag = aws.id
            item.isEnabled = true
            result.addItem(item)
        }
       
        return items.count > 0 ? result : nil
   }
    
    @objc func startEC2Instance(_ sender: NSMenuItem) {
        let instance = awsInstances.first(where: {aws in aws.id == sender.tag})
        self.cli.startEC2Instance(instance: instance!, callback: {})
    }
    
    @objc func restartEC2Instance(_ sender: NSMenuItem) {
        let instance = awsInstances.first(where: {aws in aws.id == sender.tag})
        self.cli.restartEC2Instance(instance: instance!, callback: {})
    }
    
    @objc func stopEC2Instance(_ sender: NSMenuItem) {
        let instance = awsInstances.first(where: {aws in aws.id == sender.tag})
        self.cli.stopEC2Instance(instance: instance!, callback: {})
    }
}
