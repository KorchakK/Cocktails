//
//  DrinkSceneViewModel.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 25.07.2022.
//

import UIKit

final class DrinkSceneViewModel {
    
    weak var coordinator: CoordinatorProtocol!
    
    var drinkSceneVC: DrinkSceneInputProtocol!
    
    private let drinkId: String
    private var cocktailDetailModel: CocktailDetails?
    private var urlImageSession: URLSessionDataTask?
    
    init(for drinkId: String) {
        self.drinkId = drinkId
        fetchCocktailDetails()
    }
    
    private func fetchCocktailDetails() {
        NetworkManager.shared.fetchDrinkDetails(for: drinkId) { list in
            self.cocktailDetailModel = list
            self.getAttributedStrings()
            self.fetchDrinkImage()
        }
    }
    
    private func getAttributedStrings() {
        guard let cocktailDetailModel = cocktailDetailModel?.drinks.first as? Details else {
            print("Don't have a model")
            return
        }
        getAttributedName(from: cocktailDetailModel)
        getAttribibutedDiscription(from: cocktailDetailModel)
        
    }
    
    private func fetchDrinkImage() {
        guard let url = URL(string: cocktailDetailModel?.drinks.first?.strDrinkThumb ?? "") else {
            print("No image URL")
            return
        }
        urlImageSession = NetworkManager.shared.fetchImage(from: url) { data in
            self.drinkSceneVC.cocktailImageData = data
            self.urlImageSession = nil
        }
    }
    
    private func getAttributedName(from cocktail: Details) {
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
        ]
        drinkSceneVC.cocktailName = NSAttributedString(
            string: cocktail.strDrink,
            attributes: attributes
        )
    }
    
    private func getAttribibutedDiscription(from cocktail: Details) {
        var details = NSAttributedString()
        details = getRow(from: "Category: ", from: cocktail.strCategory)
        if let alcoholic = cocktail.strAlcoholic {
            details = attributedStringWorker(
                left: details,
                right: getRow(from: "Alcoholic: ", from: alcoholic)
            )
        }
        if let glass = cocktail.strGlass {
            details = attributedStringWorker(
                left: details,
                right: getRow(from: "Glass: ", from: glass)
            )
        }
        if let instruction = cocktail.strInstructions {
            details = attributedStringWorker(
                left: details,
                right: getRow(from: "Instructions: ", from: instruction)
            )
        }
        if let ingredients = getIngredients() {
            details = attributedStringWorker(
                left: details,
                right: getRow(from: "Ingredients:\n", from: ingredients)
            )
        }
        drinkSceneVC.cocktailDetails = details
    }
    
    private func getRow(from name: String, from detail: String) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ]
        let boldAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let nameAttributedString = NSAttributedString(string: name, attributes: boldAttributes)
        let detailAttribute = NSAttributedString(string: detail + "\n", attributes: attributes)
        return attributedStringWorker(left: nameAttributedString, right: detailAttribute)
    }
    
    private func getIngredients() -> String? {
        guard let cocktailDetailModel = cocktailDetailModel?.drinks.first as? Details else {
            print("Don't have a model")
            return nil
        }
        var ingredientWithMeasure = ""
        let ingredients = [
            cocktailDetailModel.strIngredient1,
            cocktailDetailModel.strIngredient2,
            cocktailDetailModel.strIngredient3,
            cocktailDetailModel.strIngredient4,
            cocktailDetailModel.strIngredient5,
            cocktailDetailModel.strIngredient6,
            cocktailDetailModel.strIngredient7,
            cocktailDetailModel.strIngredient8,
            cocktailDetailModel.strIngredient9,
            cocktailDetailModel.strIngredient10,
            cocktailDetailModel.strIngredient11,
            cocktailDetailModel.strIngredient12,
            cocktailDetailModel.strIngredient13,
            cocktailDetailModel.strIngredient14,
            cocktailDetailModel.strIngredient15
        ]
        let measure = [
            cocktailDetailModel.strMeasure1,
            cocktailDetailModel.strMeasure2,
            cocktailDetailModel.strMeasure3,
            cocktailDetailModel.strMeasure4,
            cocktailDetailModel.strMeasure5,
            cocktailDetailModel.strMeasure6,
            cocktailDetailModel.strMeasure7,
            cocktailDetailModel.strMeasure8,
            cocktailDetailModel.strMeasure9,
            cocktailDetailModel.strMeasure10,
            cocktailDetailModel.strMeasure11,
            cocktailDetailModel.strMeasure12,
            cocktailDetailModel.strMeasure13,
            cocktailDetailModel.strMeasure14,
            cocktailDetailModel.strMeasure15
        ]

        let result: [String?] = zip(ingredients, measure).map { ingredient, measure in
            if let ingredient = ingredient, let measure = measure {
                return "• \(ingredient) - \(measure)"
            } else if let ingredient = ingredient {
                return "• \(ingredient)"
            }
            return nil
        }
        result.compactMap { $0 }.forEach {
            if $0 == result.last {
                ingredientWithMeasure += $0
            } else {
                ingredientWithMeasure += "\($0)\n"
            }
        }
        return ingredientWithMeasure
    }
    
    private func attributedStringWorker (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    deinit {
        if let urlImageSession = urlImageSession {
            urlImageSession.cancel()
        }
    }
}
