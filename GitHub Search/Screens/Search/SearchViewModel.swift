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
    
    var repositories: Driver<[Repository]> {
        return privateDataSource.asDriver()
    }
    
    override init() {
        super.init()
        subscribe()
    }
    
    private lazy var manager = RepositoriesManager()
    private var privateDataSource = BehaviorRelay<[Repository]>(value: [])
    private let bag = DisposeBag()
}

// MARK: - Public interface
extension SearchViewModel {
    
    func search() {
        findRepository(searchText.value)
    }
}

// MARK: - Pagination
extension SearchViewModel {
    
    func willDisplayCell(index: Int) {
        guard privateDataSource.value.count > 0, privateDataSource.value.count - 70 == index else { return }
        findRepository(searchText.value)
    }
}

// MARK: - Private
private extension SearchViewModel {
    
    func subscribe() {
        
        searchText
            .subscribe(onNext: { inputText in
                guard inputText.isEmpty == false else {
                    self.clearRepositories()
                    return
                }
            }).disposed(by: bag)
        
        searchText
            .distinctUntilChanged()
            .subscribe { (event) in
                //self.clearRepositories()
            }.disposed(by: bag)
        
        manager.clearList.subscribe(onNext: { _ in
            self.clearRepositories()
        }).disposed(by: bag)
    }
    
    func findRepository(_ name: String) {
        
        manager.request(repository: name)
            .subscribe(onSuccess: { repositories in
                self.privateDataSource.accept(self.privateDataSource.value + repositories)
        }) { error in
            
        }.disposed(by: bag)
    }
    
    func clearRepositories() {
        privateDataSource.accept([])
    }
}
