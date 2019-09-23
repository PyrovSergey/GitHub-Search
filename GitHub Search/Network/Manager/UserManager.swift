//
//  UserManager.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift

class UserManager {
    
    private let client = APIClient.shared
}

// MARK: - Public interface
extension UserManager {
    
    func getUserInfo(name: String) -> Single<User?> {
        
        return Single.create(subscribe: { single -> Disposable in
            
            guard ConnectionManager.shared.isConnected else {
                return Disposables.create()
            }
            self.client.getUserInformation(url: URL(string: "\(Keys.requestUserBaseURL.rawValue)\(name)")!, completion: { user in
                single(.success(user))
            }, failure: { error in
                single(.error(error))
            })
            return Disposables.create()
        })
    }
}

// MARK: - Keys
private extension UserManager {
    
    enum Keys: String {
        case requestUserBaseURL = "https://api.github.com/users/"
    }
}
