//
//  TableViewController.swift
//  MVVM-C App
//  Created by Konstantin Korchak on 11.07.2022.
//

import UIKit

class TableViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.contentInset.bottom = tabBarController?.tabBar.frame.height ?? 0
        tableView.backgroundColor = .purple
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorColor = .black
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        return CustomActivityIndicator(view: view)
    }()
    
    var tableViewModel: TableViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tableViewModel.getNavBarTitle()
        tableView.delegate = self
        tableView.dataSource = self
        view.insetsLayoutMarginsFromSafeArea = true
        view.backgroundColor = .purple
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableViewModel.fetchDrinks { [unowned self] in
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: UITableViewDataSource & Delegate

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = tableViewModel.getDrinkCellCategory(at: indexPath)
        
        content.textProperties.color = .white
        content.textProperties.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        cell.contentConfiguration = content
        cell.backgroundColor = .purple
        let bgColor = UIView()
        bgColor.backgroundColor = .black
        cell.selectedBackgroundView = bgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableViewModel.cellDidSelect(at: indexPath)
    }
}
