//
//  ViewController.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {

    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var descriptionRepository: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerEmail: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImage: UIImageView!
    private var addToBookmarksButton: UIBarButtonItem?
    
    private var bookmarkManager = BookmarksManager.share
    private var userManager = UserManager()
    
    private var repository: Repository?
    private var bookmark: Bookmark?
    
    private var user: User? {
        didSet {
            activityIndicator.isHidden = true
            ownerEmail.text = user?.userEmail
            ownerEmail.isHidden = false
        }
    }
}

// MARK: - Override
extension DetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Public interface
extension DetailViewController {
    
    func config(repository: Repository) {
        self.repository = repository
    }
    
    func config(bookmark: Bookmark) {
        self.bookmark = bookmark
    }
}

// MARK: - UserManagerDelegate
extension DetailViewController: UserManagerDelegate {
    
    func updateUserInfo(_ manager: UserManager) {
        user = manager.user
        repository?.user = user
    }
}

// MARK: - Private
private extension DetailViewController {
    
    func setupView() {
        avatarImage.round()
        addToBookmarksButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(DetailViewController.clickAddToBookmarksButton))
        navigationItem.rightBarButtonItems = [addToBookmarksButton] as? [UIBarButtonItem]
        
        addToBookmarksButton?.isEnabled = false
        
        guard repository == nil else {
            prepareRepositoryInformation()
            return
        }
        prepareBookmarkInformation()
    }
    
    func prepareBookmarkInformation() {
        repositoryName.text = bookmark?.repositoryName
        descriptionRepository.text = bookmark?.repositoryDescription
        ownerName.text = bookmark?.ownerName
        activityIndicator.isHidden = true
        ownerEmail.text = bookmark?.ownerEmail
        ownerEmail.isHidden = false
        avatarImage.image = UIImage(named: "placeholder.jpg")
        
        guard let imageData = bookmark?.imageData else { return }
        avatarImage.image = UIImage(data: imageData)
    }
    
    func prepareRepositoryInformation() {
        repositoryName.text = repository?.nameOfRepository
        descriptionRepository.text = repository?.description
        ownerName.text = repository?.userName
        getUserInfo()
        avatarImage.sd_setImage(with: URL(string: (repository?.userAvatarUrl)!), placeholderImage: UIImage(named: "placeholder.jpg"))
        
        checkInBookmarks()
    }
    
    func getUserInfo() {
        userManager.delegate = self
        guard let currentRepository = repository else { return }
        userManager.getUserInfo(name: currentRepository.userName)
    }
    
    func checkInBookmarks() {
        guard let id = repository?.id else { return }
        addToBookmarksButton?.isEnabled = bookmarkManager.isBookmark(repositoryId: id)
    }
    
    @objc func clickAddToBookmarksButton(_ sender: UIBarButtonItem) {
        
        repository?.avatarImageData = avatarImage.image?.pngData()
        
        guard let repository = repository else { return }
        
        bookmarkManager.save(repository: repository, success: {
            AlertController.shared.showToast(message: "Bookmark added")
            self.checkInBookmarks()
        }, failure: { error in
            AlertController.shared.showErrorToast(error: error.localizedDescription, autoHide: true)
        })
    }
}

// MARK: - StoryboardInstantinable
extension DetailViewController: StoryboardInstantinable { }
