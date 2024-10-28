//
//  RecipesApiClient.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import Foundation

protocol RecipesApiClientProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
}

final class RecipesApiClient: RecipesApiClientProtocol {
    
    struct Constants {
        static let path = "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json"
        static let errorMessage = "Error decoding JSON"
    }
    
    enum UserApiError: Error {
        case invalidUrl
        case errorParsingData
    }
    
    func fetchRecipes() async throws -> [RecipeModel] {
        
        guard let url = URL(string: Constants.path) else {
            throw UserApiError.invalidUrl
        }
        
        let session = URLSession.shared
        let (data, _ ) = try await session.data(from: url)
        
        do {
            let recipesData = try JSONDecoder().decode([RecipeModel].self, from: data)
            return recipesData

        } catch {
            print("\(Constants.errorMessage): \(error)") // For log purpose
            throw UserApiError.errorParsingData
        }
    }
}




