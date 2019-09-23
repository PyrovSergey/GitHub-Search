//
//  BookmarksManager.swift
//  GitHub Search
//
//  Created by Sergey on 23/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import CoreData

class BookmarksManager {
    
    private var bookmarks: [Bookmark]?
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var dateSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
}

// MARK: - Public interface
extension BookmarksManager {
    
    func load() -> Single<[Bookmark]> {
        
        return Single.create(subscribe: { single -> Disposable in
            
            let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
            fetchRequest.sortDescriptors = [ self.dateSortDescriptor ]

            do {
                let resultRequest = try self.context.fetch(fetchRequest)
                print(resultRequest.count)
                self.bookmarks = resultRequest
                single(.success(resultRequest))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        })
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
    
    func delete(at indexPath: IndexPath) -> Completable {
        
        return Completable.create(subscribe: { event -> Disposable in
            
            guard let bookmark = self.bookmarks?[indexPath.row] else {
                return Disposables.create()
            }
            
            self.context.delete(bookmark)
            do {
                try self.context.save()
                event(.completed)
            } catch {
                event(.error(error))
            }
            
            return Disposables.create()
        })
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
