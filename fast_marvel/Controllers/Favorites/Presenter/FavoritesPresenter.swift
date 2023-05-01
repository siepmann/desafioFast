//
//  FavoritesPresenter.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import Foundation
import UIKit

protocol FavoritesViewProtocol: NSObjectProtocol {
    func displayFavorites(comics: [Comic])
    func displayFavoriteDetail(comic: Comic)
}

protocol FavoritesControllerPresenterProtocol: NSObjectProtocol {
    func loadFavorites()
    func loadFavoriteDetail(comicId: Int)
    func attachView(favoritesView: FavoritesViewProtocol) 
}

class FavoritesPresenter: NSObject, FavoritesControllerPresenterProtocol {
    private let service: ComicsServiceable
    weak private var favoritesView: FavoritesViewProtocol?
    private var favoritesManager: Favoritable
    
    init(service: ComicsServiceable,
         favoriteManager: Favoritable = FavoriteManager()) {
        self.service = service
        self.favoritesManager = favoriteManager
    }
    
    deinit {
        self.favoritesView = nil
    }
    
    func loadFavorites() {
        let comics = favoritesManager.listFavorite()
        favoritesView?.displayFavorites(comics: comics)
    }
    
    func attachView(favoritesView: FavoritesViewProtocol) {
        self.favoritesView = favoritesView
    }
    
    func loadFavoriteDetail(comicId: Int) {
        fetchData(comicId: comicId)  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let comic = response.data?.results?.first {
                    self.favoritesView?.displayFavoriteDetail(comic: comic)
                } else {
                    print("missing comic")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchData(comicId: Int, completion: @escaping (Result<ComicsModel, RequestErrorModel>) -> Void) {
        Task(priority: .background) {
            let result = await service.getComicsById(id: comicId)
            completion(result)
        }
    }
}
