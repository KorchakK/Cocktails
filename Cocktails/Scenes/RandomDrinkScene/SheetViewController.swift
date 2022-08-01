//
//  SheetViewController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 19.07.2022.
//

import UIKit

class SheetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
}
