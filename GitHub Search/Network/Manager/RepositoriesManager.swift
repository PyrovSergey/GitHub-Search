//
//  RepositoryManager.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Foundation


protocol RepositoriesManagerDelegate: class {
    
    func repositoriesManagerDidUpdateList(_ manager: RepositoriesManager)
    
    func clearRepositoriesList()
    
}

class RepositoriesManager {
    
    var requestResultList: [Repository] = [] {
        
        didSet {
            delegate?.repositoriesManagerDidUpdateList(self)
            AlertController.shared.hideToast()
        }
    }
    
    weak var delegate: RepositoriesManagerDelegate?
    
    private var currentRequest: String = "" {
        
        willSet {
            
            guard currentRequest != newValue else { return }
            numberOfpage = 1
            total = 0
            self.delegate?.clearRepositoriesList()
        }
    }
    
    private var numberOfpage: Int = 1
    private var total: Int = 0
    private let client = APIClient.shared
    
    private var isLastPage: Bool {
        
        guard total < Constants.maxTotalRepositories.rawValue else { return true }
        
        return false
    }
    
    private var params: [String: String] {
        
        return [
            Keys.request.rawValue : currentRequest,
            Keys.perPage.rawValue: String(Constants.perRequest.rawValue),
            Keys.page.rawValue : String(numberOfpage)]
    }
    
}

// MARK: - Public interface
extension RepositoriesManager {
    
    func request(repository name: String) {
        
        currentRequest = name
        
        guard isLastPage == false, ConnectionManager.shared.isConnected else { return }
        
        AlertController.shared.showProgress()
        
        client.getRepositories(url: URL(string: Keys.requestRepositoryBaseURL.rawValue)!, params: params,
                               completion: { result in
                                
            guard let repositories = result.repositories, let count = result.repositories?.count else { return }
                                
            self.requestResultList = repositories
            self.total += count
            self.numberOfpage += 1
                                
            AlertController.shared.hideProgress()
            
        }, failure: { error in
            print(error.localizedDescription)
            AlertController.shared.hideProgress()
        })
        
//        guard total == 0 else { return }
//
//        AlertController.shared.hideProgress()
    }
}

// MARK: - Keys
private extension RepositoriesManager {
    
    enum Keys: String {
        
        case requestRepositoryBaseURL = "https://api.github.com/search/repositories"
        case requestUserBaseURL = "https://api.github.com/users/"
        case request = "q"
        case perPage = "per_page"
        case page = "page"
    }
    
    enum Constants: Int {
        case perRequest = 100
        case maxTotalRepositories = 1000
    }
    
}
