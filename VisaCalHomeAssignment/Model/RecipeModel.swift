//
//  RecipeModel.swift
//  VisaCalHomeAssignment
//
//  Created by Ido Ezra on 27/10/2024.
//

import Foundation

struct RecipeModel: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let headline: String
    let difficulty: Int
    let calories: String
    let carbos: String
    let fats: String
    let proteins: String
    let time: String
    let image: String
    let thumb: String
}
