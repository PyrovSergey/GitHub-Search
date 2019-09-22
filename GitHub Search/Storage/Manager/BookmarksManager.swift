//
//  BookmarksManager.swift
//  GitHub Search
//
//  Created by Sergey on 23/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import CoreData


protocol BookmarksManagerDelegate: class {
    
    func bookmarksManagerDelegateDidUpdateList(_ manager: BookmarksManager)
    
}

class BookmarksManager {
    
    static let share = BookmarksManager()
    
    private init() {
        load()
    }
    
    weak var delegate: BookmarksManagerDelegate?
    
    var bookmarks: [Bookmark]? {
        didSet {
            delegate?.bookmarksManagerDelegateDidUpdateList(self)
        }
    }
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var dateSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
}

// MARK: - Public interface
extension BookmarksManager {
    
    func load() {
        
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        fetchRequest.sortDescriptors = [ dateSortDescriptor ]
        
        do {
            let resultFetchRequest = try context.fetch(fetchRequest)
            bookmarks = resultFetchRequest
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save(repository: Repository,
              success: @escaping () -> (),
              failure: @escaping  (Error) -> ()) {
        
        let bookmark = transfer(repository)
        
        do {
            bookmarks?.append(bookmark)
            try context.save()
            success()
        } catch {
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func save(repository: Repository) -> Completable {
        return Completable.create(subscribe: { event -> Disposable in
            
            let bookmark = self.transfer(repository)
            
            do {
                self.bookmarks?.append(bookmark)
                try self.context.save()
                event(.completed)
            } catch {
                event(.error(error))
            }
            return Disposables.create()
        })
    }
    
    func delete(bookmark: Bookmark) {
        
        context.delete(bookmark)
        
        do {
            try context.save()
            load()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func isBookmark(repositoryId: Int) -> Single<Bool> {
        
        return Single.create(subscribe: { single -> Disposable in
            
            let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
            let predicate = NSPredicate(format: "repositoryId == %@", String(describing: repositoryId))
            fetchRequest.predicate = predicate
            fetchRequest.fetchLimit = 1

            do {
                let count = try self.context.count(for: fetchRequest)
                single(.success(count != 0))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        })
    }
}

// MARK: - Private
private extension BookmarksManager {
    
    func transfer(_ repository: Repository) -> Bookmark {
        
        let entity = NSEntityDescription.entity(forEntityName: "Bookmark", in: context)
        
        let newBookmark = NSManagedObject(entity: entity!, insertInto: context) as! Bookmark
        
        newBookmark.dateCreated = Date()
        newBookmark.repositoryId = Int64(repository.id)
        newBookmark.repositoryName = repository.nameOfRepository
        newBookmark.repositoryDescription = repository.description
        newBookmark.ownerId = Int64(repository.userId ?? 0)
        newBookmark.ownerName = repository.userName
        newBookmark.ownerAvatarUrl = repository.userAvatarUrl
        newBookmark.ownerEmail = repository.userEmail
        newBookmark.imageData = repository.avatarImageData

        return newBookmark
    }
}
