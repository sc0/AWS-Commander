//
//  Preferences.swift
//  awscontroller
//
//  Created by Kacper Debowski on 22/10/2020.
//

import Foundation

class Preferences {
    var selectedProfile: String
    var profileList: [String]
    
    init(selectedProfile: String, profileList: [String]) {
        self.selectedProfile = selectedProfile
        self.profileList = profileList
    }
    
    static func fromUserDefaults(settings: UserDefaults, profileList: [String]) -> Preferences {
        return Preferences(selectedProfile: settings.string(forKey: "AWSProfile") ?? "default", profileList: profileList)
    }
}
