//
//  SearchViewModel.swift
//  GitHub Search
//
//  Created by Sergey on 05/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchViewModel: NSObject {
    
    let searchText = BehaviorRelay<String>(value: "")
    
    let pagination = BehaviorRelay<Int>(value: 0)
    
    private var privateDataSource = BehaviorRelay<[Repository]>(value: [])
    
    var repositories: Driver<[Repository]> {
        return privateDataSource.asDriver()
    }

    private let bag = DisposeBag()

    private lazy var manager = RepositoriesManager()
    
    override init() {
        super.init()
        
        manager.delegate = self
        
        searchText.subscribe(onNext: { inputText in
            guard inputText.isEmpty == false else {
                self.clearRepositoriesList()
                return
            }
            self.findRepository(inputText)
        }).disposed(by: bag)
    }
}

extension SearchViewModel {
    
    func willDisplayCell(index: Int) {
        // MARK: - Pagination
        guard privateDataSource.value.count > 0, privateDataSource.value.count - 70 == index else { return }
        findRepository(searchText.value)
    }
}

// MARK: - RepositoriesManagerDelegate
extension SearchViewModel: RepositoriesManagerDelegate {

    func repositoriesManagerDidUpdateList(_ manager: RepositoriesManager) {
        privateDataSource.accept(privateDataSource.value + manager.requestResultList)
    }
    
    func clearRepositoriesList() {
        privateDataSource.accept([])
    }
}

// MARK: - Private
private extension SearchViewModel {
    
    func findRepository(_ name: String) {
        manager.request(repository: name)
    }
    
}
