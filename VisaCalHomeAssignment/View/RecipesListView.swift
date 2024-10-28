//
//  RecipesListView.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.


import SwiftUI
import Kingfisher

struct RecipesListView: View {
    @StateObject var viewModel = RecipesViewModel()
    let biometricAuth = BiometricAuthManager()

    struct Constants {
        static let authFailedTitle = "Authentication Failed"
        static let authFailedDescription = "Unable to process the recipe."
        static let navBarTitle = "Recipes"
    }
    
    var body: some View {
        ZStack {
            if viewModel.finishLoading {
                RecipesView
            } else {
                LoadingView()
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
        .sheet(item: $viewModel.selectedRecipe) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(Constants.authFailedTitle), message: Text(Constants.authFailedDescription), dismissButton: .default(Text("OK")))
        }
    }
    
    private var RecipesView: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                Button(action: {
                    viewModel.selectRecipe(recipe)
                }) {
                    RecipeRowView(recipe: recipe)
                        .padding(.vertical, 8)
                }
            }
            .listStyle(InsetListStyle())
            .navigationTitle(Constants.navBarTitle)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
    
struct RecipeRowView: View {
    let recipe: RecipeModel
    
    struct Constants {
        static let stackSpacing: CGFloat = 16
        static let frameSize: CGFloat = 80
        static let cellRadius: CGFloat = 12
        static let noDataPlaceholder = "No data"
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.stackSpacing) {
            // Display the thumbnail using Kingfisher with a ProgressView placeholder
            KFImage(URL(string: recipe.thumb))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.frameSize, height: Constants.frameSize)
                .cornerRadius(8)
                .clipped()
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Calories: \(recipe.calories.isEmpty ? Constants.noDataPlaceholder : recipe.calories)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Carbs: \(recipe.carbos.isEmpty ? Constants.noDataPlaceholder : recipe.carbos) • Fats: \(recipe.fats.isEmpty ? Constants.noDataPlaceholder : recipe.fats)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .cornerRadius(Constants.cellRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
