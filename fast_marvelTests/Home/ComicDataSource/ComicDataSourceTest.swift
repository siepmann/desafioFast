//
//  ComicDataSourceTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 27/04/23.
//

import XCTest
@testable import fast_marvel

final class ComicDataSourceTest: XCTestCase, Mockable {
    var collectionView: UICollectionView!
    var dataSource: ComicDataSource!
    var comics: [Comic] = []
    
    override func setUp() {
        collectionView = UICollectionView(frame: CGRect(x: 1, y: 1, width: 1, height: 1),
                                          collectionViewLayout: UICollectionViewLayout())
        
        let comics = loadJSON(filename: "comics_response", type: ComicsModel.self)
        self.comics = comics.data?.results ?? []
        dataSource = ComicDataSource(comics: self.comics)
        collectionView.dataSource = dataSource
    }
    
    func test_dataSource() {
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 20)
    }
    
    func test_datasource_return_cell() {
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        if let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as? ComicCollectionViewCell,
           let label = cell.subviews[0].subviews.first(where: { $0 is UILabel }) as? UILabel {
            XCTAssertEqual(self.dataSource.searchActive, false)
            XCTAssertEqual(label.text, comics[indexPath.row].title)
        } else {
            XCTFail("fail dequeue cell")
        }
    }

    func test_datasource_return_filtered_cell() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.dataSource.filterComics(searchText: "Ant")
        XCTAssertEqual(self.dataSource.filteredComics.count, 4)
        let firstFilteredComic = self.dataSource.filteredComics[0]
        
        collectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        if let cell = dataSource.collectionView(collectionView, cellForItemAt: indexPath) as? ComicCollectionViewCell,
           let label = cell.subviews[0].subviews.first(where: { $0 is UILabel }) as? UILabel {
            XCTAssertEqual(self.dataSource.searchActive, true)
            XCTAssertEqual(label.text, firstFilteredComic.title)
        } else {
            XCTFail("fail dequeue cell")
        }
    }
    
    
    func test_filter_comics() {
        self.dataSource.filterComics(searchText: "Ant")
        XCTAssertEqual(self.dataSource.filteredComics.count, 4)
        XCTAssertEqual(self.dataSource.searchActive, true)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 4)
        
        self.dataSource.filterComics(searchText: "")
        XCTAssertEqual(self.dataSource.filteredComics.count, 20)
    }
}
