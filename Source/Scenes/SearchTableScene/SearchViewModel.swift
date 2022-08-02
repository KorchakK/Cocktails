//
//  SearchViewModel.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 28.07.2022.
//

import Foundation

protocol SearchViewModelProtocol: TableViewModelProtocol {
    func searchBarTextDidChange(text: String)
}

class SearchViewModel: SearchViewModelProtocol {
    
    private var cocktailsList: CocktailSearch?
    
    weak var coordinator: CoordinatorProtocol?
    weak var searchVC: SearchTableInputProtocol?
    
    func fetchDrinks(completion: @escaping () -> Void) {
        completion()
    }
    
    func getNavBarTitle() -> String {
        ""
    }
    
    func getNumberOfRows() -> Int {
        cocktailsList?.drinks?.count ?? 0
    }
    
    func getDrinkCellCategory(at indexPath: IndexPath) -> String {
        cocktailsList?.drinks?[indexPath.row].strDrink ?? ""
    }
    
    func cellDidSelect(at indexPath: IndexPath) {
        if let coctailId = cocktailsList?.drinks?[indexPath.row].idDrink {
            coordinator?.openDrinkView(for: coctailId)
        }
    }
    
    func searchBarTextDidChange(text: String) {
        let searchText = getSearchText(from: text)
        if text.isEmpty {
            cocktailsList = nil
            searchVC?.reloadTable()
        } else {
            if text.count == 1 {
                NetworkManager.shared.fetchSearchText(for: searchText, from: .searchOneSymbol) { list in
                    self.cocktailsList = list
                    self.searchVC?.reloadTable()
                }
            } else {
                NetworkManager.shared.fetchSearchText(for: searchText, from: .searchTwoAndMoreSymbols) { list in
                    self.cocktailsList = list
                    self.searchVC?.reloadTable()
                }
            }
        }
    }
    
    private func getSearchText(from text: String) -> String {
        return text
            .replacingOccurrences(of: " ", with: "+")
            .lowercased()
            .applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false) ?? ""
    }
}
