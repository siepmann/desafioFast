//
//  FavoriteManagerTests.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import XCTest
@testable import fast_marvel


final class FavoriteManagerTests: XCTestCase, Mockable {
    private var defaults: UserDefaults = UserDefaults(suiteName: "com.guilherme.favoriteManager.fast_marvel")!
    private let favoriteKey = "test_favorite"

    override func setUp() {
        defaults.set(nil, forKey: favoriteKey)
    }
    
    func test_save_list_favorite_comic() {
        let favoriteManager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
        let comics = loadJSON(filename: "comics_response", type: ComicsModel.self)
        
        favoriteManager.addFavorite(comic: comics.data?.results ?? [])
        
        XCTAssertEqual(favoriteManager.listFavorite().count, 20)
        
        defaults.set(nil, forKey: favoriteKey)
    }
    
    func test_delete_favorite() {
        let favoriteManager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
        let comics = loadJSON(filename: "comics_response", type: ComicsModel.self)
        
        favoriteManager.addFavorite(comic: comics.data?.results ?? [])
        
        favoriteManager.removeFavorite(id: 82967)
        XCTAssertEqual(favoriteManager.listFavorite().count, 19)
        
        defaults.set(nil, forKey: favoriteKey)
    }
}
