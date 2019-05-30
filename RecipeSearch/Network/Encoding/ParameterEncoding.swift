//
//  ParameterEncoding.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

class ParameterEncoding {
    static func encode(urlRequest: inout URLRequest, urlAuthParameters: Parameters?, urlParameters: Parameters?, bodyParameters: Parameters?) throws {
        if let urlAuthParams = urlAuthParameters {
            try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlAuthParams)
        }
        
        if let urlParams = urlParameters {
            try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParams)
        }
        
        if let bodyParams = bodyParameters {
            try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParams)
        }
    }
}
