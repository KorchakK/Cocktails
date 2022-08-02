//
//  DrinkRootVIewController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 15.07.2022.
//

import UIKit

class DrinkRootVIewController: UIViewController {
    
    private let transition = PanelTransition()
    private var sheetVC: SheetViewController?
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("OpenSecondVC", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.addSubview(testButton)
        navigationItem.title = "Drink"
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sheetVC?.dismiss(animated: true)
    }
    
    @objc private func buttonDidTap() {
        sheetVC = SheetViewController()
        if let sheetVC = sheetVC {
            sheetVC.transitioningDelegate = transition
            sheetVC.modalPresentationStyle = .custom
            
            present(sheetVC, animated: true)
        }
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            testButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 150)
        ])
    }
}
