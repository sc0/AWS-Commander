//
//  MenuSection.swift
//  awscontroller
//
//  Created by Kacper Debowski on 23/10/2020.
//

import Foundation
import Cocoa

protocol MenuSection {
    var cli: CLIExecutor { get }
    var menu: NSMenu! { get }
    var statusItem: NSMenuItem { get }
    var menuItems: [NSMenuItem] { get }
    var offset: Int { get set }
    var isRefreshing: Bool { get }
    
    init(menu: NSMenu!, offset: Int, cli: CLIExecutor)
    
    func refresh(_ sender: AnyObject, callback: @escaping () -> ()) -> Void
}
