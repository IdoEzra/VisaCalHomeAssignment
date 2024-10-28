//
//  RecipesViewModel.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import Foundation
import Combine

final class RecipesViewModel: ObservableObject {
    
    // MARK: Variables
    @Published var finishLoading = false
    @Published var selectedRecipe: RecipeModel?
    @Published var showAlert = false
    
    private lazy var service = RecipesService()
    var recipes: [RecipeModel] = [RecipeModel]()

    // MARK: Method
    
    // Method to load recipes data
    func loadRecipes() async {
        
        guard let recipesData = try? await service.fetchRecipes() else {
            return
        }
        self.recipes = recipesData

        await MainActor.run {
            finishLoading = true
        }
    }
    
    // Method to encrypt a recipe when selected
    func selectRecipe(_ recipe: RecipeModel) {
        service.encryptRecipe(recipe) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Attempt to decrypt after successful encryption
                    self?.decryptRecipe(recipeID: recipe.id)
                } else {
                    self?.showAlert = true
                }
            }
        }
    }
    
    // Method to decrypt a recipe using its ID
    func decryptRecipe(recipeID: String) {
        service.decryptRecipe(recipeID: recipeID) { [weak self] recipe in
            DispatchQueue.main.async {
                if let recipe = recipe {
                    self?.selectedRecipe = recipe
                } else {
                    self?.showAlert = true
                }
            }
        }
    }
}
