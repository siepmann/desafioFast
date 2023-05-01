//
//  FavoriteManager.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import Foundation

protocol Favoritable {
    func addFavorite(comic: [Comic])
    func removeFavorite(id: Int)
    func listFavorite() -> [Comic]
}

class FavoriteManager: Favoritable {
    private let favoriteComicsKey: String
    private var comicIds: [Int] = []
    let userDefaults: UserDefaults
    
    init(defaults: UserDefaults = .standard, favoriteKey: String = "fast.comics") {
        self.userDefaults = defaults
        self.favoriteComicsKey = favoriteKey
    }
    
    func addFavorite(comic: [Comic]) {
        var comics = self.listFavorite()
        comics.append(contentsOf: comic)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(comics) {
            userDefaults.set(encoded, forKey: favoriteComicsKey)
        }
    }
    
    func removeFavorite(id: Int) {
        var favorites = listFavorite()
        favorites.removeAll {
            $0.id == id
        }
        
        userDefaults.set(nil, forKey: favoriteComicsKey)
        userDefaults.synchronize()
        self.addFavorite(comic: favorites)
    }
    
    func listFavorite() -> [Comic] {
        if let savedComics = userDefaults.object(forKey: favoriteComicsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedComics = try? decoder.decode([Comic].self, from: savedComics) {
                return loadedComics
            }
        }
        
        return []
    }
}
