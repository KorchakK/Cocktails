//
//  TableViewModel.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 12.07.2022.
//

import Foundation

protocol TableViewModelProtocol: AnyObject {
    func fetchDrinks(completion: @escaping () -> Void)
    func getNavBarTitle() -> String
    func getNumberOfRows() -> Int
    func getDrinkCellCategory(at indexPath: IndexPath) -> String
    func cellDidSelect(at indexPath: IndexPath)
}

class TableViewModel: TableViewModelProtocol {
    
    enum TypeOfTable {
        case categories
        case ingredients
    }
    
    weak var coordinator: CoordinatorProtocol?
    private var categories: Categories?
    private var ingredients: Ingredients?
    private let typeOfTable: TypeOfTable
    
    init(typeOfTable: TypeOfTable) {
        self.typeOfTable = typeOfTable
    }
    
    func fetchDrinks(completion: @escaping () -> Void) {
        switch typeOfTable {
        case .categories:
            NetworkManager.shared.fetchCategories { drinks in
                self.categories = self.sortedCategory(from: drinks)
                completion()
            }
        case .ingredients:
            NetworkManager.shared.fetchIngredients { drinks in
                self.ingredients = self.sortedIngredient(from: drinks)
                completion()
            }
        }
    }
    
    func getNavBarTitle() -> String {
        switch typeOfTable {
        case .categories:
            return "Categories"
        case .ingredients:
            return "Ingredients"
        }
    }
    
    func getNumberOfRows() -> Int {
        var numberOfRows = 0
        switch typeOfTable {
        case .categories:
            numberOfRows = categories?.drinks.count ?? 0
        case .ingredients:
            numberOfRows = ingredients?.drinks.count ?? 0
        }
        return numberOfRows
    }
    
    func getDrinkCellCategory(at indexPath: IndexPath) -> String {
        var cellCategory = ""
        switch typeOfTable {
        case .categories:
            cellCategory = categories?.drinks[indexPath.row].strCategory ?? ""
        case .ingredients:
            cellCategory = ingredients?.drinks[indexPath.row].strIngredient1 ?? ""
        }
        return cellCategory
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        switch typeOfTable {
        case .categories:
            coordinator?.openCoctailList(for: categories?.drinks[indexPath.row].strCategory ?? "Cocktail", typeOfCocktailList: .category)
        case .ingredients:
            coordinator?.openCoctailList(for: ingredients?.drinks[indexPath.row].strIngredient1 ?? "Vodka", typeOfCocktailList: .ingredient)
        }
    }
    
    private func sortedCategory(from categories: Categories) -> Categories {
        let drinks = categories.drinks.sorted { $0.strCategory < $1.strCategory }
        return Categories(drinks: drinks)
    }
    private func sortedIngredient(from ingredients: Ingredients) -> Ingredients {
        let drinks = ingredients.drinks.sorted { $0.strIngredient1 < $1.strIngredient1 }
        return Ingredients(drinks: drinks)
    }
}
