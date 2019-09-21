//
//  Repository.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import ObjectMapper


// MARK: - Repository info
struct Repository: Mappable {
    
    var id: Int!
    var nameOfRepository: String?
    var description: String?
    var owner: [String: Any]?
    var user: User?
    var avatarImageData: Data?
    
    var userName: String {
        return owner?["login"] as? String ?? Key.defaultName.rawValue
    }
    
    var userId: Int? {
        return user?.id
    }
    
    var userEmail: String {
        
        guard let user = user else {
            return ("\(Key.defaultName.rawValue) \(Key.owner.rawValue) ")
        }
        
        return user.userEmail
    }
    
    var userAvatarUrl: String? {
        return owner?["avatar_url"] as? String
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map[Key.id.rawValue]
        nameOfRepository <- map[Key.fullNameRepository.rawValue]
        description <- map[Key.description.rawValue]
        owner <- map[Key.owner.rawValue]
    }
}

// MARK: - Keys
private extension Repository {
    
    enum Key: String {
        
        case id = "id"
        case fullNameRepository = "name"
        case description = "description"
        case owner = "owner"
        case defaultName = "unknown"
    }
}
