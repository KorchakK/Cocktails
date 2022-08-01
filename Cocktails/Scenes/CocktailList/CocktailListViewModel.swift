//
//  CocktailListViewModel.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 13.07.2022.
//

import UIKit

enum TypeOfCocktailsList {
    case category
    case ingredient
    case top
}

protocol CocktailListViewModelProtocol {
    var category: String { get }
    func fetchCocktailList(completion: @escaping () -> Void)
    func getImageForCell(at indexPath: IndexPath, completion: @escaping (_ image: Data) -> Void) -> URLSessionDataTask?
    func getNumberOfCells() -> Int
    func getDrinkCellName(at indexPath: IndexPath) -> String
    func cellDidTap(at indexPath: IndexPath)
}

class CocktailListViewModel: CocktailListViewModelProtocol {
    
    let category: String
    weak var coordinator: CoordinatorProtocol?
    private var cocktailsList: CocktailsList?
    private let typeOfList: TypeOfCocktailsList
    
    init(for category: String, typeOfList: TypeOfCocktailsList) {
        self.category = category
        self.typeOfList = typeOfList
    }
    
    func fetchCocktailList(completion: @escaping () -> Void) {
        switch typeOfList {
        case .category:
            NetworkManager.shared.fetchList(for: category) { list in
                self.cocktailsList = list
                completion()
            }
        case .ingredient:
            NetworkManager.shared.fetchIngredientList(for: category) { list in
                self.cocktailsList = list
                completion()
            }
        case .top:
            StorageManager.shared.getTodayTop { top in
                NetworkManager.shared.fetchDrinksByIds(from: top) { drinks in
                    var cocktailsList = CocktailsList.mokList()
                    for cocktail in drinks {
                        cocktailsList.drinks.append(
                            Cocktails(
                                strDrink: cocktail.drinks.first?.strDrink ?? "",
                                strDrinkThumb: cocktail.drinks.first?.strDrinkThumb ?? "",
                                idDrink: cocktail.drinks.first?.idDrink ?? ""
                            )
                        )
                    }
                    cocktailsList.drinks.remove(at: 0)
                    cocktailsList.drinks.sort {
                        $0.idDrink < $1.idDrink
                    }
                    self.cocktailsList = cocktailsList
                    completion()
                }
            }
        }
    }
    
    func getImageForCell(at indexPath: IndexPath, completion: @escaping (_ image: Data) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: ((cocktailsList?.drinks[indexPath.row].strDrinkThumb) ?? "") + "/preview") else {
            print("No URL")
            return nil
        }
        let task = NetworkManager.shared.fetchImage(from: url) { data in
            completion(data)
        }
        return task
    }
    
    func getNumberOfCells() -> Int {
        cocktailsList?.drinks.count ?? 0
    }
    
    func getDrinkCellName(at indexPath: IndexPath) -> String {
        cocktailsList?.drinks[indexPath.row].strDrink ?? ""
    }
    
    func cellDidTap(at indexPath: IndexPath) {
        coordinator?.openDrinkView(for: cocktailsList?.drinks[indexPath.row].idDrink ?? "1")
    }
}
