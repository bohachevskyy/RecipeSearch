//
//  HTTPClient.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

final class HTTPClient {
    static let session = URLSession(configuration: .default)
    
    static func request<T: Decodable>(requestConvertible: URLRequestCovertible, completion: @escaping (Result<T, Error>) -> ()) {
        let urlRequest: URLRequest
        
        do {
            try urlRequest = requestConvertible.asURLRequest()
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            let result: Result<T, Error>
            
            if let error = error {
                result = .failure(error)
            } else if let response = response as? HTTPURLResponse {
                if !isResponseCodeValid(response.statusCode) {
                    result = .failure(errorForCode(response.statusCode))
                } else if let data = data {
                    if let responseObject = try? JSONDecoder().decode(T.self, from: data) {
                        result = .success(responseObject)
                    } else if let responseString = String(data: data, encoding: .utf8) {
                        result = .failure(NetworkError.serverError(description: responseString))
                    } else {
                        result = .failure(NetworkError.decodingFailed)
                    }
                } else {
                    result = .failure(NetworkError.noData)
                }
            } else {
                result = .failure(NetworkError.noData)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        dataTask.resume()
    }
}

private extension HTTPClient {
    static func isResponseCodeValid(_ code: Int) -> Bool {
        return (200...299).contains(code)
    }
    
    static func errorForCode(_ code: Int) -> NetworkError {
        let description = HTTPURLResponse.localizedString(forStatusCode: code)
        return NetworkError.serverError(description: description)
    }
}
