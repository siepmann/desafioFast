//
//  FavoritesPresenterTests.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 27/04/23.
//

import XCTest
@testable import fast_marvel

final class FavoritesPresenterTests: XCTestCase, Mockable {
    private var expectation: XCTestExpectation?
    private var favoritesPresenter: FavoritesPresenter!
    private var favoriteManager: Favoritable!
    private var comics: [Comic] = []
    
    private var defaults: UserDefaults = UserDefaults(suiteName: "com.guilherme.favoritesPresenter.fast_marvel")!
    private let favoriteKey = "test_favorite"
    
    override func setUp() {
        favoriteManager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
    
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        favoriteManager.addFavorite(comic: comics.data?.results ?? [])
        
        favoritesPresenter = FavoritesPresenter(service: ComicsServiceMock(),
                                                favoriteManager: favoriteManager)
        
        favoritesPresenter.attachView(favoritesView: self)
        
    }
    
    override func tearDown() {
        defaults.removeObject(forKey: favoriteKey)
    }
    
    func test_load_favorites_presenter() {
        expectation = expectation(description: "fetch comics from local favorite storage")
        favoritesPresenter.loadFavorites()
        
        waitForExpectations(timeout: 2)
        XCTAssertEqual(comics.count, 1)
    }
    
    func test_get_favorite_detail_from_service() {
        expectation = expectation(description: "fetch comic detail from service using comic ID from local favorite storage")
        favoritesPresenter.loadFavoriteDetail(comicId: 82967)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(comics.count, 1)
        XCTAssertNotNil(comics.first)
        XCTAssertEqual(comics.first?.id ?? 0, 82967)
    }
}

extension FavoritesPresenterTests: FavoritesViewProtocol {
    func displayFavorites(comics: [Comic]) {
        self.comics = comics
        expectation?.fulfill()
        self.expectation = nil
    }
    
    func displayFavoriteDetail(comic: Comic) {
        self.comics = [comic]
        expectation?.fulfill()
        self.expectation = nil
    }
}
