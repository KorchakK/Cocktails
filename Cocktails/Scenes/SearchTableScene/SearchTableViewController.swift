//
//  SearchTableViewController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 28.07.2022.
//

import UIKit

protocol SearchTableInputProtocol: AnyObject {
    func reloadTable()
}

final class SearchTableViewController: TableViewController, SearchTableInputProtocol, UISearchBarDelegate {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width * 0.9,
            height: 20
        ))
        searchBar.placeholder = "Enter cocktail name"
        searchBar.barStyle = UIBarStyle.black
        searchBar.searchTextField.leftView?.tintColor = .white
        searchBar.searchTextField.textColor = .white
        return searchBar
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.layer.opacity = 0.2
        return imageView
    }()
    
    weak var searchViewModel: SearchViewModelProtocol! {
        didSet {
            tableViewModel = searchViewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(placeholderImage)
        placeholderImageConstraintSetup()
        searchBar.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = ""
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = searchBarItem
        tableView.keyboardDismissMode = .onDrag
    }
    
    func reloadTable() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        searchBar.endEditing(true)
    }
}
// MARK: - SearchBar setup
extension SearchTableViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        searchViewModel.searchBarTextDidChange(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: - SearchBar setup
extension SearchTableViewController {
    private func placeholderImageConstraintSetup() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            placeholderImage.heightAnchor.constraint(equalTo: placeholderImage.widthAnchor)
        ])
    }
}
