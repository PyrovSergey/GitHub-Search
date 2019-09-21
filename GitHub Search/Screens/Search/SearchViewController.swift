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
            .drive(tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { row, element, cell in
                self.tableView.isHidden = row == 0
                cell.repositoryName.text = element.nameOfRepository
                cell.ownerName.text = element.userName
                cell.avatarImageView.sd_setImage(with: URL(string: element.userAvatarUrl ?? ""), placeholderImage: UIImage(named: "placeholder.jpg"))
            }.disposed(by: bag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { (cell, indexPath) in
                //print("\(indexPath.row)")
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
    }
    
    func startDetailController(repository: Repository) {
        let vc = DetailViewController.instantinateFromStoryboard()
        vc.config(repository: repository)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - StoryboardInstantinable
extension SearchViewController: StoryboardInstantinable {}



