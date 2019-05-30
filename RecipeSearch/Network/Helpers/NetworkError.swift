//
//  NetworkError.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case encodingFailed
    case decodingFailed
    case noData
    case serverError(description: String)
    case connectionError(error: Error)
}
