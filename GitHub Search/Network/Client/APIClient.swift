//
//  APIClient.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper


class APIClient {
    
    public static let shared = APIClient()
    
    private init() {}
}

// MARK: - Public interface
extension APIClient {

    func getRepositories(url: URL, params: [String: String],
                     completion: @escaping (RepositoriesResponse) -> Void,
                     failure: @escaping (Error) -> Void) {
        
    Alamofire.request(url, method: .get, parameters: params).responseObject { (response: DataResponse<RepositoriesResponse>) in
        
        switch response.result {
            
            case .success(let value):
                completion(value)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func getUserInformation(url: URL,
                            completion: @escaping (User) -> Void,
                            failure: @escaping (Error) -> Void) {
        
        Alamofire.request(url).responseObject { (response: DataResponse<User>) in
            
            switch response.result {
                
            case .success(let value):
                completion(value)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
