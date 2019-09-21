//
//  User.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import ObjectMapper


// MARK: - User info
struct User: Mappable {
    
    var id: Int?
    var avatarUrl: String?
    var email: String?
    
    var userEmail: String {
        
        guard let email = email, email.isEmpty == false else {
            return "unknown email"
        }
        
        return email
    }
    
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map[Key.id.rawValue]
        avatarUrl <- map[Key.avatarUrl.rawValue]
        email <- map[Key.email.rawValue]
    }
}

// MARK: - Keys
private extension User {
    
    enum Key: String {
        
        case id = "id"
        case avatarUrl = "avatar_url"
        case email = "email"
    }
}
