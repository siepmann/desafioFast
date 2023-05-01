//
//  FavoritesViewControllerTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 28/04/23.
//

import XCTest
@testable import fast_marvel

final class FavoritesViewSpy: NSObject, FavoritesViewProtocol {
    var didLoadFavoriteDetail: Bool = false
    
    func displayFavorites(comics: [Comic]) { }
    
    func displayFavoriteDetail(comic: Comic) {
        self.didLoadFavoriteDetail = true
    }
}

final class FavoritesViewControllerTest: XCTestCase, Mockable {
    private var sut: FavoritesViewController!
    private var tableView: UITableView!
    private var presenter: FavoritesControllerPresenterProtocol!
    private var favoriteManager: Favoritable!
    private var delegate: UITableViewDelegate!
    
    private var datasource: FavoritesDataSource!
    
    private var defaults: UserDefaults = UserDefaults(suiteName: "com.guilherme.FavoritesViewControllerTest.fast_marvel")!
    private let favoriteKey = "test_favorite"
        
    var expectation: XCTestExpectation?
    
    override func setUp() {
        defaults.set(nil, forKey: favoriteKey)
        
        favoriteManager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
        presenter = FavoritesPresenterMock()
        
        self.datasource = FavoritesDataSource(favoriteManager: self.favoriteManager)
        
        sut = FavoritesViewController(presenter: presenter, dataSource: self.datasource)
        presenter.attachView(favoritesView: sut)
        
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        favoriteManager.addFavorite(comic: comics.data?.results ?? [])
        
        sut.loadViewIfNeeded()
        self.tableView = sut.view.subviews.first(where: { $0 is UITableView }) as! UITableView
                
        self.datasource.setComics(comics: comics.data?.results ?? [])
        self.tableView.dataSource = datasource
        self.delegate = tableView.delegate
    }
    
    func test_table_has_cell() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell")
        XCTAssertNotNil(cell)
    }
    
    func test_did_select_comic() {
        let view = FavoritesViewSpy()
        presenter.attachView(favoritesView: view)
      
        tableView.reloadData()
        delegate.tableView?(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        XCTAssertTrue(view.didLoadFavoriteDetail)
    }
    
    func test_cell_height() {
        let height = delegate.tableView?(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(height, UITableView.automaticDimension)
    }
}
