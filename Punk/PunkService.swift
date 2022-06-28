//
//  PunkService.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import Foundation

class PunkService {
    
    enum APIError: Error {
        case failedToBuildUrl
        case responseStatusError
    }
    
    private let baseUrlString = "https://api.punkapi.com"
    
    func fetchBeers(page: Int, pageSize: Int) async throws -> [Beer] {
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.path = "/v2/beers"
        var queryItems = [URLQueryItem(name: "per_page", value: String(pageSize))]
        if page > 0 {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            throw APIError.failedToBuildUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse,
              (200...299).contains(response.statusCode) else {
            throw APIError.responseStatusError
        }
        return try JSONDecoder().decode([Beer].self, from: data)
    }
    
}
