//
//  BookmarksViewController.swift
//  GitHub Search
//
//  Created by Sergey on 24/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import RxCocoa
import SwipeCellKit


class BookmarksViewController: UIViewController {
    
    @IBOutlet private weak var emptyLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var model: BookmarksViewModel!
    
    private let bag = DisposeBag()
}

// MARK: - Override
extension BookmarksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.loadBookmarks()
    }
}

// MARK: - SwipeTableViewCellDelegate
extension BookmarksViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.model.deleteBookmark(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}

// MARK: - Private
private extension BookmarksViewController {
    
    func setupView() {
        
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        title = "Bookmarks"
        
        bind()
    }
    
    func bind() {
        
        model.bookmarks.drive(tableView.rx.items(cellIdentifier: "bookmarkCell", cellType: BookmarkCell.self)) { row, element, cell in
            cell.rx.base.delegate = self
            cell.repositoryName.text = element.repositoryName
            cell.ownerName.text = element.ownerName
            cell.avatarImageView.image = UIImage(named: "placeholder.jpg")
            if let imageData = element.imageData {
                cell.avatarImageView.image = UIImage(data: imageData)
            }
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Bookmark.self).subscribe(onNext: { [weak self] bookmark in
            self?.startDetailController(bookmark: bookmark)
        }).disposed(by: bag)
        
        model.bookmarks.map{!$0.isEmpty}
            .drive(emptyLabel.rx.isHidden)
            .disposed(by: bag)
    }
    
    func startDetailController(bookmark: Bookmark) {
        let vc = DetailViewController.instantinateFromStoryboard()
        vc.viewModel = DetailViewModel(bookmark: bookmark)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - StoryboardInstantinable
extension BookmarksViewController: StoryboardInstantinable { }
