//
//  CardViewController.swift
//  CardManagementSDKSwiftSample
//
//  Created by Paula Radu on 25.11.2022.
//

import UIKit
import NICardManagementSDK
import Combine

@available(iOS 13.0, *)
class CardViewController: UIViewController {
     let viewModel: CardViewModel
     var bag = Set<AnyCancellable>()
     let stackView = UIStackView()
     let pinViewHolder = UIView()
     let cardViewHolder = UIView()
    
     var sdk: NICardManagementAPI
    
     lazy var cardViewCallback: (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void = { [weak self] successResponse, errorResponse, callback  in
        print("Success Response \(successResponse?.message ?? "-"); \nError code: \(errorResponse?.errorCode ?? "-"), Error message: \(errorResponse?.errorMessage ?? "-")")
        self?.presentedViewController?.dismiss(animated: true)
        guard let error = errorResponse else { return }
        let alert = UIAlertController(title: "Fail", message: error.errorMessage, preferredStyle: .alert)
        
        if let attributedString = try? NSAttributedString(data: Data(error.errorMessage.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            alert.title = nil
            alert.setValue(attributedString, forKey: "attributedMessage")
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self?.present(alert, animated: true)
    }
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        sdk = viewModel.settingsProvider.settings.buildSdk()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.settingsProvider.$settings
            .receive(on: RunLoop.main)
            .sink { [weak self] settings in
                self?.sdk = settings.buildSdk()
                // refresh UI
                self?.fillContent()
            }
            .store(in: &bag)
    }
}

@available(iOS 13.0, *)
 extension CardViewController {
    func setupView() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        cardViewHolder.layer.masksToBounds = true
        cardViewHolder.layer.cornerRadius = 20
        cardViewHolder.layer.borderWidth = 1
        cardViewHolder.layer.borderColor = UIColor.white.cgColor
        
        cardViewHolder.heightAnchor.constraint(equalToConstant: 182).isActive = true
        cardViewHolder.translatesAutoresizingMaskIntoConstraints = false
        
        pinViewHolder.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pinViewHolder.translatesAutoresizingMaskIntoConstraints = false
        pinViewHolder.layer.masksToBounds = true
        pinViewHolder.layer.cornerRadius = 15
        pinViewHolder.layer.borderWidth = 1
        pinViewHolder.layer.borderColor = UIColor.white.cgColor
    }
    
    func fillContent() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(cardViewHolder)
            
        
        stackView.addArrangedSubview(makeHeader("PIN Management"))
        
    
    
        stackView.addArrangedSubview(pinViewHolder)
    }
    

    
    func makeHeader(_ text: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        label.text = text
        return view
    }
}

@available(iOS 13.0, *)
 extension CardViewModel {
    var displayAttributes: NIDisplayAttributes {
        NIDisplayAttributes(
            theme: settingsProvider.theme,
            language: settingsProvider.currentLanguage, // can be nil
            fonts: settingsProvider.fonts, // can be omitted
            cardAttributes: cardAttributes // can be nil
        )
    }
    
    var cardAttributes: NICardAttributes {
        NICardAttributes(
            shouldHide: true,
            textPositioning: settingsProvider.textPosition.sdkValue
        )
    }
}

 extension SettingsModel {
    var tokenFetchableSimple: NICardManagementTokenFetchable {
        TokenFetcherFactory.makeSimpleWrapper(tokenValue:"a8xkm4c4zhmxqs6j536y9wqg")
    }
    
    var tokenFetchableRepository: NICardManagementTokenFetchable {
        TokenFetcherFactory.makeNetworkWithCache(
            urlString: credentials.tokenUrl,
            credentials: .init(
                clientId: credentials.clientId,
                clientSecret: credentials.clientSecret
            )
        )
    }
    
    
    func buildSdk() -> NICardManagementAPI {
        NICardManagementAPI(
            rootUrl: connection.baseUrl,
            cardIdentifierId: cardIdentifier.Id,
            cardIdentifierType: cardIdentifier.type,
            bankCode: connection.bankCode,
            tokenFetchable: tokenFetchableRepository
        )
    }
}
