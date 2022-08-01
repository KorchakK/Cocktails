//
//  MainCoordinator.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 12.07.2022.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var tabBarController: UITabBarController? { get set }
    func start()
    func openCoctailList(for category: String, typeOfCocktailList: TypeOfCocktailsList)
    func openDrinkView(for id: String)
}

class MainCoordinator: CoordinatorProtocol {
    
    var tabBarController: UITabBarController?
    
    func start() {
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = .purple
        tabBarController?.tabBar.isTranslucent = false
        let topVC = returnTopList()
        topVC.tabBarItem = UITabBarItem(title: "TOP 25", image: UIImage(systemName: "flame"), tag: 0)
        let categoryVC = returnCategoryList()
        categoryVC.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "list.dash"), tag: 1)
        let alcoVC = returnAlcoList()
        alcoVC.tabBarItem = UITabBarItem(title: "Ingredients", image: UIImage(systemName: "drop"), tag: 2)
        
        let searchVC = returnSearchVC()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 3)
        
        tabBarController?.viewControllers = [topVC, categoryVC, alcoVC, searchVC]
    }
    
    private func returnTopList() -> UIViewController {
        let navigationController = CustomNavigationController()
        let cellsVC = CocktailListViewController()
        let cellsVM = CocktailListViewModel(for: "Day's TOP 25", typeOfList: .top)
        cellsVM.coordinator = self
        cellsVC.cocktailListViewModel = cellsVM
        navigationController.viewControllers = [cellsVC]
        return navigationController
    }
    
    private func returnCategoryList() -> UIViewController {
        let navigationController = CustomNavigationController()
        let tableVC = TableViewController()
        let tableViewModel = TableViewModel(typeOfTable: .categories)
        tableViewModel.coordinator = self
        tableVC.tableViewModel = tableViewModel
        navigationController.viewControllers = [tableVC]
        return navigationController
    }
    
    private func returnAlcoList() -> UIViewController {
        let navigationController = CustomNavigationController()
        let tableVC = TableViewController()
        let tableViewModel = TableViewModel(typeOfTable: .ingredients)
        tableViewModel.coordinator = self
        tableVC.tableViewModel = tableViewModel
        navigationController.viewControllers = [tableVC]
        return navigationController
    }
    
    private func returnSearchVC() -> UIViewController {
        let navigationController = CustomNavigationController()
        let searchVC = SearchTableViewController()
        let tableViewModel = SearchViewModel()
        tableViewModel.coordinator = self
        tableViewModel.searchVC = searchVC
        searchVC.searchViewModel = tableViewModel
        navigationController.viewControllers = [searchVC]
        return navigationController
    }
    
    func openCoctailList(for category: String, typeOfCocktailList: TypeOfCocktailsList) {
        let coctailListVC = CocktailListViewController()
        let cocktailListVM = CocktailListViewModel(for: category, typeOfList: typeOfCocktailList)
        cocktailListVM.coordinator = self
        coctailListVC.cocktailListViewModel = cocktailListVM
        let selectedVC = tabBarController?.selectedViewController
        guard let selectedVC = selectedVC as? CustomNavigationController else { return }
        selectedVC.pushViewController(coctailListVC, animated: true)
    }
    
    func openDrinkView(for id: String) {
        let drinkVC = DrinkSceneViewController()
        let drinkVM = DrinkSceneViewModel(for: id)
        drinkVM.coordinator = self
        drinkVM.drinkSceneVC = drinkVC
        let selectedVC = tabBarController?.selectedViewController
        guard let selectedVC = selectedVC as? CustomNavigationController else { return }
        selectedVC.pushViewController(drinkVC, animated: true)
    }
}
