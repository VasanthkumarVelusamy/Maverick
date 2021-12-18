//
//  SearchResult.swift
//  Maverick Movies
//
//  Created by Vasanth Kumar on 17/12/21.
//

import Foundation

struct SearchResult: Codable {
    var search: [Movie]
    var totalResults: String
    var response: String
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}
