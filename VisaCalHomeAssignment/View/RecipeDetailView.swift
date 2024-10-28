//
//  RecipeDetailView.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import SwiftUI
import Kingfisher

struct RecipeDetailView: View {
    let recipe: RecipeModel
    
    struct Constants {
        static let stackSpacing: CGFloat = 16
        static let frameHeight: CGFloat = 300
        static let imageRadius: CGFloat = 12
        static let noDataPlaceholder = "No data"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.stackSpacing) {
                
                KFImage(URL(string: recipe.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight:  Constants.frameHeight)
                    .cornerRadius(Constants.imageRadius)
                    .padding(.top, Constants.stackSpacing)
                    .padding(.horizontal)
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text("Calories: \(recipe.calories.isEmpty ? Constants.noDataPlaceholder : recipe.calories)")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                Text("Carbs: \(recipe.carbos.isEmpty ? Constants.noDataPlaceholder : recipe.carbos)")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                Text("Fats: \(recipe.fats.isEmpty ? Constants.noDataPlaceholder : recipe.fats)")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                Text(recipe.description)
                    .font(.body)
                    .padding(.horizontal)
            }
        }
    }
}
