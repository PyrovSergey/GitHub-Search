//
//  ViewController.swift
//  GitHub Search
//
//  Created by Sergey on 21/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var searchViewModel: SearchViewModel!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    private let bag = DisposeBag()
}

// MARK: - Override
extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private
private extension SearchViewController {
    
    func setupView() {
        
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        title = "Search"
        
        bind()
    }
    
    func bind() {
        
        searchViewModel
            .repositories
            .drive(tableView.rx.items(cellIdentifier: "repositoryCell", cellType: RepositoryCell.self)) { row, element, cell in
                cell.repositoryName.text = element.nameOfRepository
                cell.ownerName.text = element.userName
                cell.avatarImageView.sd_setImage(with: URL(string: element.userAvatarUrl ?? ""), placeholderImage: UIImage(named: "placeholder.jpg"))
            }.disposed(by: bag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                self.searchViewModel
                    .willDisplayCell(index: indexPath.row)
            }).disposed(by: bag)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [weak self] repository in
                self?.startDetailController(repository: repository)
            }).disposed(by: bag)
        
        searchBar.rx.text
            .orEmpty
            .bind(to: searchViewModel.searchText)
            .disposed(by: bag)
        
        searchViewModel.repositories.map{!$0.isEmpty}
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: bag)
        
        let click = searchBar.rx.searchButtonClicked.asObservable()
        
        click.subscribe(onNext: {
            self.searchViewModel.search()
        }).disposed(by: bag)
    }
    
    func startDetailController(repository: Repository) {
        let vc = DetailViewController.instantinateFromStoryboard()
        vc.viewModel = DetailViewModel(repository: repository)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - StoryboardInstantinable
extension SearchViewController: StoryboardInstantinable {}
