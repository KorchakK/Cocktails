//
//  CocktailCollectionViewCell.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 13.07.2022.
//

import UIKit

class CocktailCollectionViewCell: UICollectionViewCell {
    
    lazy var coctailImageView: UIImageView = {
        let coctailImageView = UIImageView()
        coctailImageView.layer.cornerRadius = 7
        coctailImageView.clipsToBounds = true
        return coctailImageView
    }()
    
    lazy var coctailNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        let font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 15)
        textLabel.font = font
        return textLabel
    }()
    
    lazy var activityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(view: coctailImageView)
    }()
    
    var task: URLSessionDataTask?
    
    override func prepareForReuse() {
        coctailImageView.image = nil
        coctailNameLabel.text = ""
        activityIndicator.startAnimating()
        if let task = task {
            task.cancel()
        }
        task = nil
    }
    
    func setupCollectionCell() {
        addSubview(coctailImageView)
        addSubview(coctailNameLabel)
        addSubview(activityIndicator)
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 1.3
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        coctailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coctailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            coctailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            coctailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            coctailImageView.heightAnchor.constraint(equalTo: coctailImageView.widthAnchor)
        ])
        
        coctailNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coctailNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.layer.bounds.height * -0.045),
            coctailNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            coctailNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.layer.bounds.width * 0.9)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: coctailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: coctailImageView.centerYAnchor)
        ])
    }
}
