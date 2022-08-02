//
//  CustomNavigationController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 12.07.2022.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.barTintColor = .purple
        navigationBar.tintColor = .white
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
