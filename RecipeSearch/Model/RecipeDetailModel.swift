//
//  RecipeDetailModel.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

struct RecipeDetailModel: Codable {
    let imageURL: String
    let sourceURL: String
    let f2fURL: String
    let title: String
    let publisher: String
    let publisherURL: String
    let socialRank: Float
    let ingredients: [String]
    
    private enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case sourceURL = "source_url"
        case f2fURL = "f2f_url"
        case title
        case publisher
        case publisherURL = "publisher_url"
        case socialRank = "social_rank"
        case ingredients
    }
}
