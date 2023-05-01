//
//  FavoritesViewController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    private var dataSource: FavoritesDataSource
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var presenter: FavoritesControllerPresenterProtocol?
    
    init(presenter: FavoritesControllerPresenterProtocol,
         dataSource: FavoritesDataSource = FavoritesDataSource(favoriteManager: FavoriteManager())) {
        self.presenter = presenter
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        presenter = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Favorites"
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
        
        self.tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.presenter?.loadFavorites()
    }
    
    private func setupViews() {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let comicId = self.dataSource.getComic(index: indexPath.row)?.id {
            ProgressView.shared.show()
            presenter?.loadFavoriteDetail(comicId: comicId)
        } else {
            print("not a valid comic id")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavorites(comics: [Comic]) {
        if comics.count > 0 {
            self.dataSource.setComics(comics: comics)
        } else {
            self.dataSource.setComics(comics: [])
        }
        
        self.tableView.reloadData()
    }
    
    func displayFavoriteDetail(comic: Comic) {
        ProgressView.shared.hide()
        let presenter = ComicDetailPresenter(comic: comic)
        DispatchQueue.main.async {
            presenter.navigate(from: self)
        }
    }
}
