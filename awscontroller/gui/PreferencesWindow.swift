//
//  SwiftUIView.swift
//  awscontroller
//
//  Created by Kacper Debowski on 21/10/2020.
//

import SwiftUI

struct PreferencesWindow: View {
    @State private var profile: String = "default"
    var settings: Preferences
    let saveAction: (_ settings: Preferences) -> Void
    
    var body: some View {
        
        return HStack(alignment: .center, spacing: .some(100), content: {
            VStack(alignment: .center, spacing: .some(10), content: {
                if settings.profileList.count > 0 && !settings.profileList[0].isEmpty {
                    Picker(selection: $profile, label: Text("Profile:"), content: {
                        ForEach(settings.profileList, id: \.self) {
                            profile in
                            Text(profile)
                        }
                    })
                } else {
                    Text("No AWS CLI profiles found.\nPlease configure AWS CLI before using AWS Commander.")
                }
                Divider().padding(.vertical, 10)
                HStack(alignment: .center, spacing: .some(10), content: {
                    Button("Cancel", action: {
                        saveAction(self.settings)
                    })
                    Button("Save", action: {
                        self.settings.selectedProfile = profile;
                        print(profile)
                        saveAction(self.settings)
                    })
                })
            }).frame(width: 400, height: 100, alignment: .center)
        }).padding(.all, 20)
        .onAppear {
            profile = settings.selectedProfile
        }
        
    }
}
