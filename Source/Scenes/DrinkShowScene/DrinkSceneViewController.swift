//
//  DrinkSceneViewController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 19.07.2022.
//

import UIKit
import UltraDrawerView

protocol DrinkSceneInputProtocol {
    var cocktailName: NSAttributedString? { get set }
    var cocktailDetails: NSAttributedString? { get set }
    var cocktailImageData: Data? { get set }
}

final class DrinkSceneViewController: UIViewController, DrinkSceneInputProtocol {
    
    var cocktailName: NSAttributedString? {
        didSet {
            cocktailNameLabel.attributedText = cocktailName
        }
    }
    var cocktailDetails: NSAttributedString? {
        didSet {
            textView.attributedText = cocktailDetails
        }
    }
    var cocktailImageData: Data? {
        didSet {
            drinkImage.image = UIImage(data: cocktailImageData ?? Data())
            placeholderImage.isHidden = true
        }
    }
        
    private var drawerView: DrawerView!
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        let image = UIImageView()
        headerView.addSubview(image)
        image.image = UIImage(systemName: "chevron.up")
        image.tintColor = .gray
        setupHeaderViewConstraint(for: headerView, for: image)
        return headerView
    }()
    
    private lazy var discriptionView: UIScrollView = {
        let discriptionView = UIScrollView()
        discriptionView.isScrollEnabled = false
        return discriptionView
    }()
    
    private lazy var insideView = UIView()
    
    private lazy var cocktailNameLabel: UILabel = {
        let label = UILabel()
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.backgroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)
        ]
        let placeholderText = NSAttributedString(
            string: "Placeholder",
            attributes: attributes
        )
        label.attributedText = placeholderText
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    
    private lazy var textView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 0
        textView.adjustsFontSizeToFitWidth = true
        textView.sizeToFit()
        return textView
    }()
    
    private lazy var drinkImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .placeholderText
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        setupDrawView()
        view.addSubview(drinkImage)
        drinkImage.addSubview(placeholderImage)
        view.addSubview(drawerView)
        discriptionView.addSubview(insideView)
        insideView.addSubview(cocktailNameLabel)
        insideView.addSubview(textView)
        setupConstraint()
        setupLayout()
        setupScrollConstraints()
        setupImageConstraint()
    }
    
    private func setupDrawView() {
        drawerView = DrawerView(scrollView: discriptionView, headerView: headerView)
        drawerView.availableStates = [.middle, .top]
        drawerView.middlePosition = .fromBottom(70)
        drawerView.topPosition = .fromBottom(400)
        drawerView.cornerRadius = 16
        drawerView.containerView.backgroundColor = .white
        drawerView.setState(.middle, animated: false)
    }
}

// MARK: - Setup constraints
extension DrinkSceneViewController {
    private func setupLayout() {
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            drawerView.topAnchor.constraint(equalTo: view.topAnchor),
            drawerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            drawerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    private func setupHeaderViewConstraint(for headerView: UIView, for imageView: UIImageView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupConstraint() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        discriptionView.translatesAutoresizingMaskIntoConstraints = false
        discriptionView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        discriptionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupScrollConstraints() {
        insideView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        cocktailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            insideView.topAnchor.constraint(equalTo: discriptionView.topAnchor),
            insideView.leftAnchor.constraint(equalTo: discriptionView.leftAnchor),
            insideView.bottomAnchor.constraint(equalTo: discriptionView.bottomAnchor),
            insideView.rightAnchor.constraint(equalTo: discriptionView.rightAnchor),
            insideView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cocktailNameLabel.topAnchor.constraint(equalTo: insideView.topAnchor),
            cocktailNameLabel.leftAnchor.constraint(equalTo: insideView.leftAnchor, constant: 16),
            cocktailNameLabel.rightAnchor.constraint(equalTo: insideView.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: cocktailNameLabel.bottomAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo: insideView.leftAnchor, constant: 16),
            textView.rightAnchor.constraint(equalTo: insideView.rightAnchor, constant: -16),
            textView.heightAnchor.constraint(lessThanOrEqualToConstant: 350)
        ])
        
        
    }
    
    private func setupImageConstraint() {
        drinkImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            drinkImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drinkImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height * -0.1),
            drinkImage.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            drinkImage.heightAnchor.constraint(equalTo: drinkImage.widthAnchor)
        ])
        
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: drinkImage.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: drinkImage.centerYAnchor),
            placeholderImage.heightAnchor.constraint(equalToConstant: 150),
            placeholderImage.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
