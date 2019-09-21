//
//  UserManager.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Foundation


protocol UserManagerDelegate: class {
    
    func updateUserInfo(_ manager: UserManager)
    
}

class UserManager {
    
    weak var delegate: UserManagerDelegate?
    
    var user: User? {
        
        didSet {
            delegate?.updateUserInfo(self)
        }
    }
    
    private let client = APIClient.shared
}

// MARK: - Public interface
extension UserManager {
    
    func getUserInfo(name: String) {
        
        guard ConnectionManager.shared.isConnected else { return }
        
        client.getUserInformation(url: URL(string: "\(Keys.requestUserBaseURL.rawValue)\(name)")!, completion: { user in
            self.user = user
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}

// MARK: - Keys
private extension UserManager {
    
    enum Keys: String {
        
        case requestUserBaseURL = "https://api.github.com/users/"
    }
}
