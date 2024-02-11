import Foundation
import NICardManagementSDK
import UIKit


@available(iOS 13.0, *)
@objc(MfNiWrapperPlugin)
class MfNiWrapperPlugin: CDVPlugin {
    var cardViewController : CardViewController?
    var pluginResult : CDVPluginResult?
    private let viewModel: CardViewModel
    private var sdk: NICardManagementAPI
    

    private lazy var cardViewCallback: (CDVInvokedUrlCommand?, NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void = { [weak self] command, successResponse, errorResponse, callback in
        guard let self = self else {
            print("Unable to access plugin instance.")
            return
        }
        
        print("Success Response \(successResponse?.message ?? "-"); \nError code: \(errorResponse?.errorCode ?? "-"), Error message: \(errorResponse?.errorMessage ?? "-")")
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.dismiss(animated: true)
        } else {
            print("Unable to find the topmost view controller.")
        }
        
        let pluginResult: CDVPluginResult
        if let errorMessage = errorResponse?.errorMessage {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: errorMessage)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: successResponse?.message)
        }
        
        self.pluginResult = pluginResult
        self.commandDelegate.send(self.pluginResult, callbackId: command?.callbackId)
    }

    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        sdk = viewModel.settingsProvider.settings.buildSdk()
        super.init()
    }
    
    @objc(initializeSDK:)
    func initializeSDK(command: CDVInvokedUrlCommand) {
        
        guard let rootUrl = command.argument(at: 0) as? String,
              let cardIdentifierId = command.argument(at: 1) as? String,
              let cardIdentifierType = command.argument(at: 2) as? String,
              let bankCode = command.argument(at: 3) as? String,
              let token = command.argument(at: 4) as? String
        else {
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: "Expected five non-empty string arguments: rootUrl, cardIdentifierId, cardIdentifierType, bankCode, token."
            )
            commandDelegate.send(
                pluginResult,
                callbackId: command.callbackId
            )
            return
        }
        
        // Initialize the SDK with the provided token
        let tokenFetcher = TokenFetcherFactory.makeSimpleWrapper(tokenValue: token)
                
        self.sdk = NICardManagementAPI(
            rootUrl: rootUrl,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            bankCode: bankCode,
            tokenFetchable: tokenFetcher
        )
        
        // Consider handling initialization errors here
        pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK
        )
        
        commandDelegate.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
    
    
    @objc(setPinForm:)
    func setPinForm(command: CDVInvokedUrlCommand) {
        print("Entered the setPinForm")

        // Convert raw values to SDK types
        let pinType = NIPinFormType.fourDigits

        // Check if iOS 13.0 is available
        guard let window = UIApplication.shared.windows.first else {
            print("Unable to access the window.")
            return
        }

        // Create settings provider and card view model
        let settingsProvider = SettingsProvider()
        let cardViewModel = CardViewModel(settingsProvider: settingsProvider)

        // Create card view controller
        self.cardViewController = CardViewController(viewModel: cardViewModel)

        // Ensure that cardViewController and sdk are not nil
        if self.cardViewController != nil, self.sdk != nil {
            // Use displayAttributes directly since it's not optional
            let displayAttributes = cardViewModel.displayAttributes

            // Define the dummy view controller
            let dummyVC = UIViewController()

            let navVC = UINavigationController(rootViewController: dummyVC)
            navVC.isNavigationBarHidden = true
    
            self.sdk.setPinForm(type: pinType, viewController: dummyVC, displayAttributes: displayAttributes) { successResponse, errorResponse, callback in
                self.cardViewCallback(command, successResponse, errorResponse, callback)
            }
            // Find the topmost view controller to present from
            if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                topViewController.present(navVC, animated: true)
            } else {
                print("Unable to find the topmost view controller.")
            }
            
        } else {
            print("cardViewController or sdk is nil.")
        }
    }

    
}