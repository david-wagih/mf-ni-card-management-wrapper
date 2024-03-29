//
//  SettingsProvider.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import Foundation
import Combine
import NICardManagementSDK

@available(iOS 13.0, *)
class SettingsProvider {
    @Published private(set) var settings: SettingsModel
    // UI Settings
    @Published private(set) var currentLanguage: NILanguage
    @Published private(set) var theme: NITheme
    @Published private(set) var textPosition: TextPositioning

    @Published private(set) var fonts: [NIFontLabelPair]
    
    init() {
        settings = Self.readSettings()
        currentLanguage = .initial
        theme = .initial
        textPosition = .initial
        fonts = Self.initialFonts
    }
    
    func updateLanguage(_ language: NILanguage) {
        currentLanguage = language
    }
    
    func updateSettings(_ settings: SettingsModel) {
        self.settings = settings
    }
    
    func updateTheme(_ theme: NITheme) {
        self.theme = theme
    }
    
    func updateTextPosition(_ textPosition: TextPositioning) {
        self.textPosition = textPosition
    }
}

@available(iOS 13.0, *)
private extension SettingsProvider {
    static func readSettings() -> SettingsModel {
        let plistData: (_ path: String) -> Data? = { path in
            let url: URL
            if #available(iOS 16.0, *) {
                url = URL(filePath: path)
            } else {
                url = URL(fileURLWithPath: path)
            }
            return try? Data(contentsOf: url)
        }
        
        guard
            let path = Bundle.main.path(forResource: "Settings", ofType: "plist"),
            let data = plistData(path),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let dict = plist?["CardView"] as? [String: Any],
            let settings = SettingsModel.decode(from: dict)
        else { return .zero }
        
        return settings
    }
    
    static var initialFonts: [NIFontLabelPair] {
        // Example of setting of a specific fonts (this is optional)
        let fonts = [
            NIFontLabelPair(
                font: UIFont(name: "Helvetica", size: 18)!, // System font
                label: .setPinDescriptionLabel
            ),
            NIFontLabelPair(
                font: UIFont(name: "Helvetica", size: 18)!, // System font
                label: .verifyPinDescriptionLabel
            )
        ]
//        fonts = [
//             (font: UIFont(name: "Arial", size: 14.0)!, label: .cardNumberLabel),
//            NIFontLabelPair(font: valueFont, label: .cardNumberValueLabel),
//            NIFontLabelPair(font: labelFont, label: .expiryDateLabel),
//            NIFontLabelPair(font: valueFont, label: .expiryDateValueLabel),
//            NIFontLabelPair(font: labelFont, label: .cvvLabel),
//            NIFontLabelPair(font: valueFont, label: .cvvValueLabel),
//            NIFontLabelPair(font: labelFont, label: .cardholderNameLabel),
//            NIFontLabelPair(font: labelFont, label: .cardholderNameTagLabel)
//        ]
        return fonts
    }
}

fileprivate extension SettingsModel {
    static var zero: SettingsModel {
        .init(
            connection: .init(baseUrl: "", bankCode: ""),
            cardIdentifier: .init(Id: "", type: ""),
            pinType: .initial, 
            credentials: .init(tokenUrl: "", clientId: "", clientSecret: "")
        )
    }
}
extension NILanguage {
    static var initial: Self {
        let isArabicLang = Locale.preferredLanguages.first?.hasPrefix("ar") ?? false
        return isArabicLang ? .arabic : .english
    }
}
extension NITheme {
    static var initial: Self {
        UIScreen.main.traitCollection.userInterfaceStyle == .light ? .light : .dark
    }
}
// Have to use proxy, as NICardDetailsTextPositioning's fields has internal access level
struct TextPositioning {
    static var initial: TextPositioning {
        TextPositioning(
            leftAlignment: 0.1,
            cardNumberGroupTopAlignment: 0.1,
            dateCvvGroupTopAlignment: 0.4,
            cardHolderNameGroupTopAlignment: 0.7
        )
    }
    
    var leftAlignment: Double
    var cardNumberGroupTopAlignment: Double
    var dateCvvGroupTopAlignment: Double
    var cardHolderNameGroupTopAlignment: Double
    
    var sdkValue: NICardDetailsTextPositioning {
        NICardDetailsTextPositioning(
            leftAlignment: leftAlignment,
            cardNumberGroupTopAlignment: cardNumberGroupTopAlignment,
            dateCvvGroupTopAlignment: dateCvvGroupTopAlignment,
            cardHolderNameGroupTopAlignment: cardHolderNameGroupTopAlignment
        )
    }
}
