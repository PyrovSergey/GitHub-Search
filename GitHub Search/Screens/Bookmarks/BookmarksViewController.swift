//
//  BookmarksViewController.swift
//  GitHub Search
//
//  Created by Sergey on 24/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit
import SwipeCellKit


class BookmarksViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var bookmarks: [Bookmark] = [] {
        didSet {
            updateTableView()
        }
    }
    
    private let bookmarksManager = BookmarksManager.share
}

// MARK: - Override
extension BookmarksViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bookmarksManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarksManager.load()
    }
}

// MARK: - UITableViewDelegate
extension BookmarksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startDetailController(bookmark: bookmarks[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension BookmarksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: BookmarkCell = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        
        let bookmark = bookmarks[indexPath.row]
        cell.delegate = self
        cell.repositoryName.text = bookmark.repositoryName
        cell.ownerName.text = bookmark.ownerName
        cell.avatarImageView.image = UIImage(named: "placeholder.jpg")
        if let imageData = bookmark.imageData {
            cell.avatarImageView.image = UIImage(data: imageData)
        }
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate
extension BookmarksViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            action.fulfill(with: .delete)
        }
        
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
}

// MARK: - BookmarksManagerDelegate
extension BookmarksViewController: BookmarksManagerDelegate {
    
    func bookmarksManagerDelegateDidUpdateList(_ manager: BookmarksManager) {
        
        guard let newBookmarksList = manager.bookmarks else { return }
        bookmarks = newBookmarksList
    }
}

// MARK: - Private
private extension BookmarksViewController {
    
    func setupView() {
        
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        
        title = "Bookmarks"
    }
    
    func updateTableView() {
        
        tableView.isHidden = bookmarks.isEmpty
        emptyLabel.isHidden = !bookmarks.isEmpty
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        bookmarksManager.delete(bookmark: bookmarks[indexPath.row])
    }
    
    func startDetailController(bookmark: Bookmark) {
        let vc = DetailViewController.instantinateFromStoryboard()
        vc.config(bookmark: bookmark)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - StoryboardInstantinable
extension BookmarksViewController: StoryboardInstantinable { }
