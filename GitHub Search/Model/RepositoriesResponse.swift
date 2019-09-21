//
//  RepositoriesResponse.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import ObjectMapper


// MARK: - RepositoriesResponse info
struct RepositoriesResponse: Mappable {
    
    var totalCount: Int!
    var repositories: [Repository]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        totalCount <- map[Key.totalCount.rawValue]
        repositories <- map[Key.repositories.rawValue]
    }
    
}

// MARK: - Keys
private extension RepositoriesResponse {
    
    enum Key: String {
        
        case totalCount = "total_count"
        case repositories = "items"
    }
}
