//
//  ActivityIndicatorView.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 12.07.2022.
//

import UIKit

class CustomActivityIndicator: UIActivityIndicatorView {
    private var view: UIView?
    
    init(view: UIView) {
        self.view = view
        super.init(style: .large)
        hidesWhenStopped = true
        color = .white
        startAnimating()
        center = view.center
    }
    
    init() {
        super.init(style: .large)
        hidesWhenStopped = true
        color = .white
        startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
