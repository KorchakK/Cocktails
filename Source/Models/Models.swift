//
//  Models.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 11.07.2022.
//

import Foundation

enum ApiUrl: String {
    case categories = "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list"
    case list = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c="
    case listForIngredient = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i="
    case ingredients = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
    case random = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
    case detail = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i="
    case searchOneSymbol = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f="
    case searchTwoAndMoreSymbols = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
}
// MARK: - Categories model
struct Categories: Decodable {
    let drinks: [Category]
}

struct Category: Decodable {
    let strCategory: String
}

// MARK: - Ingredents list model

struct Ingredients: Decodable {
    let drinks: [Ingredient]
}

struct Ingredient: Decodable {
    let strIngredient1: String
}

// MARK: - Cocktail Cell list model
struct CocktailsList: Decodable {
    var drinks: [Cocktails]
    
    static func mokList() -> CocktailsList {
        return CocktailsList(drinks: [Cocktails(strDrink: "", strDrinkThumb: "", idDrink: "")])
    }
}

struct Cocktails: Decodable {
    let strDrink: String
    let strDrinkThumb: String
    let idDrink: String
}

// MARK: - Cocktail detail model
struct CocktailDetails: Decodable {
    let drinks: [Details]
}

struct Details: Decodable {
    let idDrink: String
    let strDrink: String
    let strCategory: String
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
    let strDrinkThumb: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
}

// MARK: - Today Top Model
struct DayTop: Codable {
    let date: Date
    let id: [Int]
}

// MARK: - Cocktail detail model
struct CocktailSearch: Decodable {
    let drinks: [Details]?
}
