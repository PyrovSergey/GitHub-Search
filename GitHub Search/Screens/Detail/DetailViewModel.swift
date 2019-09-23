//
//  DetailViewModel.swift
//  GitHub Search
//
//  Created by Sergey on 21/09/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import RxCocoa

class DetailViewModel {
    
    private typealias repositoryInfo = [String: Any]
    
    let repositoryName: String?
    let descriptionRepository: String?
    let ownerName: String?
    private let ownerEmail = BehaviorRelay<String>(value: "")
    private let bookmarkState = BehaviorRelay<Bool>(value: false)
    let userAvatarUrl: String?
    let repositoryId: Int?
    let imageData: Data?
    private var repository: Repository?
    
    var email: Driver<String> {
        return ownerEmail.asDriver()
    }
    
    var isBookmarks: Driver<Bool> {
        return bookmarkState.asDriver()
    }
    
    private var bookmarkManager = BookmarksManager()
    private var userManager = UserManager()
    
    private let bag = DisposeBag()
    
    init(repository: Repository) {
        self.repository = repository
        repositoryName = repository.nameOfRepository
        descriptionRepository = repository.description
        ownerName = repository.userName
        ownerEmail.accept("")
        userAvatarUrl = repository.userAvatarUrl
        imageData = repository.avatarImageData
        repositoryId = repository.id
    }
    
    init(bookmark: Bookmark) {
        repositoryName = bookmark.repositoryName
        descriptionRepository = bookmark.repositoryDescription
        ownerName = bookmark.ownerName
        ownerEmail.accept(bookmark.ownerEmail ?? "unknown email")
        userAvatarUrl = bookmark.ownerAvatarUrl
        imageData = bookmark.imageData
        repositoryId = Int(truncatingIfNeeded: bookmark.repositoryId)
    }
    
    func getEmail() {
        guard let name = ownerName else { return }
        userManager.getUserInfo(name: name).subscribe(onSuccess: { (user) in
            self.ownerEmail.accept(user?.email ?? "unknown email")
            self.repository?.user = user
        }) { error in
            print(error.localizedDescription)
        }.disposed(by: bag)
    }
    
    func checkInBookmarks() {
        guard let id = repositoryId else { return }
        bookmarkManager.isBookmark(repositoryId: id).subscribe(onSuccess: { inBookmarks in
            self.bookmarkState.accept(!inBookmarks)
        }) { error in
            print(error.localizedDescription)
        }.disposed(by: bag)
    }
    
    func addToBookmarks(data: Data) {
        repository?.avatarImageData = data
        
        guard let repository = repository else { return }
        
        bookmarkManager.save(repository: repository)
            .subscribe(onCompleted: {
            AlertController.shared.showToast(message: "Bookmark added")
                self.checkInBookmarks()
        }) { error in
            AlertController.shared.showErrorToast(error: error.localizedDescription, autoHide: true)
        }.disposed(by: bag)
    }
}
