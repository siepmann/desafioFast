//
//  HomeViewControllerTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 27/04/23.
//

import XCTest
@testable import fast_marvel

final class HomeViewControllerTest: XCTestCase, Mockable {
    var sut: HomeViewController!
    var presenter: HomeViewControllerPresenterProtocol!
    var expectation: XCTestExpectation?
    var datasource: ComicDataSource!
    var collectionView: UICollectionView!
    var delegate: UICollectionViewDelegate!
    
    override func setUp() {
        presenter = HomePresenterMock()
        
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        self.datasource = ComicDataSource(comics: comics.data?.results ?? [])
        
        sut = HomeViewController(presenter: presenter, dataSource: self.datasource)
        sut.loadViewIfNeeded()
        
        
        collectionView = sut.view.subviews.first(where: { $0 is UICollectionView }) as! UICollectionView
        collectionView.dataSource = self.datasource
        self.delegate = collectionView.delegate
    }
    
    func test_collection_has_cell() {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
}
