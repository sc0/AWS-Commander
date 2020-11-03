//
//  AppDelegate.swift
//  awscontroller
//
//  Created by Kacper Debowski on 21/10/2020.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var menu: NSMenu!
    @IBOutlet weak var lastSyncMenuItem: NSMenuItem!
    
    @objc var lastSyncFontSize = 10
    @objc var lastSyncEnabled = false
    
    var statusBarItem: NSStatusItem!
    var preferenceWindow: NSWindow?
    
    let cli = CLIExecutor()
    var menuSections: [MenuSection] = []

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "💣"
        statusBarItem.menu = menu
        
        menuSections = initMenuSections()
        refresh(self)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func initMenuSections() -> [MenuSection] {
        var result: [MenuSection] = []
        
        result.append(EC2MenuSection(menu: menu, offset: 0, cli: cli))
        
        return result
    }
    
    
    @IBAction func refresh(_ sender: AnyObject) {
        setRefreshingAnimation()
        menuSections.forEach({
            section in
            section.refresh(self, callback: refreshFinished)
        })
        
        
    }
    
    func setRefreshingAnimation() {
        statusBarItem.button?.title = "🔃"
        statusBarItem.menu = nil
    }
    
    func unsetRefreshingAnimation() {
        statusBarItem.button?.title = "💣"
        statusBarItem.menu = menu
    }
    
    func refreshFinished() {
        var allRefreshed = true
        menuSections.forEach({ section in allRefreshed = allRefreshed && !section.isRefreshing })
        
        if allRefreshed {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            lastSyncMenuItem.title = "Last sync: \(formatter.string(from: NSDate.now))"
            
            unsetRefreshingAnimation()
        }
    }
    
    
    @IBAction func openPreferences(_ sender: Any) {
        if self.preferenceWindow != nil {
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        if self.statusBarItem.button != nil {
            let prefWindow = NSWindow()
            
            let saveAction: (_ settings: Preferences) -> Void = {
                (settings) in
                UserDefaults.standard.set(settings.selectedProfile, forKey: "AWSProfile")
                prefWindow.orderOut(self)
                self.preferenceWindow = nil
                self.refresh(self)
            }
            self.cli.getProfiles(callback: {
                profiles in
                prefWindow.contentViewController =
                    NSHostingController(rootView: PreferencesWindow(settings:
                                                                        Preferences.fromUserDefaults(
                                                                            settings: UserDefaults.standard,
                                                                            profileList: profiles),
                                                                    saveAction: saveAction))
                
                prefWindow.makeKeyAndOrderFront(self)
                self.preferenceWindow = prefWindow
            })
        }
    }
    
    
    @IBAction func killApp(sender: AnyObject) {
        NSApplication.shared.terminate(self)
    }
}
