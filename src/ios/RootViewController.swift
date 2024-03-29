//
//  RootViewController.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 16.11.2023.
//

import UIKit
import NICardManagementSDK
import Combine

class RootViewController: UITabBarController {
    private let viewModel: RootViewModel
    private var bag = Set<AnyCancellable>()
    
    init() {
        viewModel = RootViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        let cardVc = CardViewController(viewModel: CardViewModel(settingsProvider: viewModel.settingsProvider))
        cardVc.tabBarItem = UITabBarItem(title: "Card", image: UIImage(systemName: "creditcard.and.123"), tag: 0)
        
        
        viewControllers = [cardVc]
        
        viewModel.settingsProvider.$theme
            .receive(on: RunLoop.main)
            .sink { theme in
                UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .map(\.windows)
                    .flatMap({ $0 })
                    .forEach({ $0.overrideUserInterfaceStyle = theme == .dark ? .dark : .light })
            }
            .store(in: &bag)
    }
}
