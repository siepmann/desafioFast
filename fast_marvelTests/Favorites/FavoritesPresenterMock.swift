//
//  FavoritesPresenterMock.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import Foundation
@testable import fast_marvel

class FavoritesPresenterMock: NSObject, FavoritesControllerPresenterProtocol, Mockable {
    weak private var favoritesView: FavoritesViewProtocol?
    
    deinit {
        self.favoritesView = nil
    }
    
    func loadFavorites() {
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        
        favoritesView?.displayFavorites(comics: comics.data?.results ?? [])
    }
    
    func loadFavoriteDetail(comicId: Int) {
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        let comic = comics.data?.results?.first!
        favoritesView?.displayFavoriteDetail(comic: comic!)
    }
    
    func attachView(favoritesView: FavoritesViewProtocol) {
        self.favoritesView = favoritesView
    }
}
