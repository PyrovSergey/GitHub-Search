//
//  ViewController.swift
//  GitHub Search
//
//  Created by Sergey on 22/08/2019.
//  Copyright © 2019 PyrovSergey. All rights reserved.
//

import RxSwift
import RxCocoa
import SDWebImage


class DetailViewController: UIViewController {

    @IBOutlet private weak var repositoryName: UILabel!
    @IBOutlet private weak var descriptionRepository: UILabel!
    @IBOutlet private weak var ownerName: UILabel!
    @IBOutlet private weak var ownerEmail: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var avatarImage: UIImageView!
    
    var viewModel: DetailViewModel?
    
    private var addToBookmarksButton: UIBarButtonItem!
    private let bag = DisposeBag()
}

// MARK: - Override
extension DetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel?.checkInBookmarks()
        viewModel?.getEmail()
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

// MARK: - Private
private extension DetailViewController {
    
    func setupView() {
        avatarImage.round()
        addToBookmarksButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(DetailViewController.clickAddToBookmarksButton))
        
        navigationItem.rightBarButtonItems = [addToBookmarksButton] as? [UIBarButtonItem]
        
        addToBookmarksButton?.isEnabled = false
        
        repositoryName.text = viewModel?.repositoryName
        descriptionRepository.text = viewModel?.descriptionRepository
        ownerName.text = viewModel?.ownerName
        
        viewModel?.email
            .drive(ownerEmail.rx.text)
            .disposed(by: bag)
        
        viewModel?.isBookmarks
            .drive(addToBookmarksButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel?.email
            .map{ $0.isEmpty }
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        guard let imageData = viewModel?.imageData else {
            
            if let stringUrl = viewModel?.userAvatarUrl {
                avatarImage.sd_setImage(with: URL(string: stringUrl), placeholderImage: UIImage(named: "placeholder.jpg"))
            }
            return
        }
        avatarImage.image = UIImage(data: imageData)
    }
    
    @objc func clickAddToBookmarksButton() {
        
        guard let imageData = avatarImage.image?.pngData() else { return }
        viewModel?.addToBookmarks(data: imageData)
    }
}

// MARK: - StoryboardInstantinable
extension DetailViewController: StoryboardInstantinable { }
