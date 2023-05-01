//
//  FavoritesDataSourceTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import XCTest
@testable import fast_marvel

final class FavoritesDataSourceTest: XCTestCase, Mockable {
    var dataSource: FavoritesDataSource!
    let tableView = UITableView()
    var manager: Favoritable!
    private var defaults: UserDefaults = UserDefaults(suiteName: "com.guilherme.FavoritesDataSourceTest.fast_marvel")!
    private let favoriteKey = "test_favorite"
    
    override func setUp() {
        defaults.set(nil, forKey: favoriteKey)
        
        manager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
        self.dataSource = FavoritesDataSource(favoriteManager: manager)
        self.tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        
        self.tableView.estimatedRowHeight = 44
        
        //needed for editingStyle
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        manager.addFavorite(comic: comics.data?.results ?? [])
        
        self.dataSource.setComics(comics: comics.data?.results ?? [])
        
    }
    
    override func tearDown() {
        defaults.set(nil, forKey: favoriteKey)
    }
    
    func test_datasource_has_comic() {
        XCTAssertEqual(dataSource.count(), 1)
    }
    
    func test_has_item_in_section() {
        XCTAssertEqual(dataSource.numberOfSections(in: tableView), 1)
    }
    
    func test_number_of_rows() {
        let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 1)
    }
    
    func test_cell_for_row() {
        let cell = dataSource.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        if let label = cell.subviews[1].subviews[0].subviews[0] as? UILabel {
            XCTAssertEqual(label.text, "Marvel Previews (2017)")
        } else {
            XCTFail("unable to load cell")
        }
    }
    
    func test_editing_style() {
        dataSource.tableView(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        dataSource.setComics(comics: manager.listFavorite())
        let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 0)
    }
}
