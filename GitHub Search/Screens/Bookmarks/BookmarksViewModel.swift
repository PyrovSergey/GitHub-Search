//
//  BookmarksViewModel.swift
//  GitHub Search
//
//  Created by Sergey on 22/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import RxCocoa

class BookmarksViewModel: NSObject {
    
    var bookmarks: Driver<[Bookmark]> {
        return bookmarksData.asDriver()
    }
    
    private var bookmarksData = BehaviorRelay<[Bookmark]>(value: [])
    private let manager = BookmarksManager()
    
    private let bag = DisposeBag()
}


// MARK: - Public interface
extension BookmarksViewModel {
    
    func loadBookmarks() {
        manager.load()
            .subscribe(onSuccess: { bookmarks in
            self.bookmarksData.accept(bookmarks)
        }) { error in
            AlertController.shared.showErrorToast(error: error.localizedDescription)
        }.disposed(by: bag)
    }
    
    func deleteBookmark(at indexPath: IndexPath) {
        manager.delete(at: indexPath)
            .subscribe(onCompleted: {
                self.loadBookmarks()
            }) { error in
                AlertController.shared.showErrorToast(error: error.localizedDescription)
        }.disposed(by: bag)
    }
}

// MARK: - Private
private extension BookmarksViewModel {
    
}
