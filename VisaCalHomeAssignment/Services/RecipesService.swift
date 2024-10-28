//
//  RecipesService.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 28/10/2024.
//

import Foundation

protocol RecipesServiceProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
    func encryptRecipe(_ recipe: RecipeModel, completion: @escaping (Bool) -> Void)
    func decryptRecipe(recipeID: String, completion: @escaping (RecipeModel?) -> Void)
}

final class RecipesService: RecipesServiceProtocol {
    
    // MARK: Variables
    private lazy var apiClient = RecipesApiClient()
    private lazy var biometricAuth = BiometricAuthManager()
    
    // MARK: Method
    func fetchRecipes() async throws -> [RecipeModel] {
        do {
            let recipesData = try await apiClient.fetchRecipes()
            return recipesData
        } catch (let error) {
            throw error
        }
    }
    
    // Method to encrypt a recipe
    func encryptRecipe(_ recipe: RecipeModel, completion: @escaping (Bool) -> Void) {
        
        if let data = try? JSONEncoder().encode(recipe) {
            biometricAuth.encryptAndStore(data: data, key: recipe.id, completion: completion)
        } else {
            completion(false)
        }
    }
    
    // Method to decrypt a recipe
    func decryptRecipe(recipeID: String, completion: @escaping (RecipeModel?) -> Void) {
        biometricAuth.retrieveAndDecrypt(key: recipeID) { data in
            guard let data = data, let recipe = try? JSONDecoder().decode(RecipeModel.self, from: data) else {
                completion(nil)
                return
            }
            completion(recipe)
        }
    }
}
