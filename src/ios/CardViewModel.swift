//
//  CardViewModel.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import Foundation

@available(iOS 13.0, *)
class CardViewModel {
    let settingsProvider: SettingsProvider    
    init(settingsProvider: SettingsProvider) {
        self.settingsProvider = settingsProvider
    }
}
