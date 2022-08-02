//
//  CocktailListViewController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 12.07.2022.
//

import UIKit

class CocktailListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2.35
        let height = width * 1.25
        let insets = width / 8.2
        layout.sectionInset = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.contentInset.bottom = tabBarController?.tabBar.frame.height ?? 0
        collectionView.register(CocktailCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .purple
        return collectionView
    }()
    private lazy var activityIndicator: CustomActivityIndicator = {
        return CustomActivityIndicator(view: view)
    }()
    
    var cocktailListViewModel: CocktailListViewModelProtocol! {
        didSet {
            cocktailListViewModel.fetchCocktailList { [unowned self] in
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = cocktailListViewModel.category
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
}

// MARK: DataSource, Delegate
extension CocktailListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cocktailListViewModel.getNumberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CocktailCollectionViewCell
        cell.setupCollectionCell()
        cell.coctailNameLabel.text = cocktailListViewModel.getDrinkCellName(at: indexPath)
        cell.task = cocktailListViewModel.getImageForCell(at: indexPath) { image in
            cell.activityIndicator.stopAnimating()
            cell.coctailImageView.image = UIImage(data: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        cocktailListViewModel.cellDidTap(at: indexPath)
        return true
    }
}
