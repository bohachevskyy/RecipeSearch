//
//  RecipeAPIRouter.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

enum RecipeAPIRouter: NetworkRoutable {
    case find(keyword: String, page: Int)
    case getDetail(id: String)
    
    var host: String { return "www.food2fork.com" }
    
    var path: String {
        switch self {
        case .find(_, _):
            return "/api/search"
        case .getDetail(_):
            return "/api/get"
        }
    }
    
    var httpMethod: String { return "GET" }
    
    var authenticationQueryParameterers: Parameters? {
        return ["key": "89c02993d2e0332cef8ed69318e73abb"]
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .find(let keyword, let page):
            return ["q": keyword, "page": "\(page)"]
        case .getDetail(let id):
            return ["rId": id]
        }
    }
    
    var bodyParameters: Parameters? { return nil }
    
    var headers: Headers? { return nil }
}
