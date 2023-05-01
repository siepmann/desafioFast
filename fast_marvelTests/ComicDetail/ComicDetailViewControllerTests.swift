//
//  ComicDetailViewControllerTests.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 28/04/23.
//

import XCTest
@testable import fast_marvel

final class ComicDetailViewControllerTests: XCTestCase, Mockable {
    var sut: ComicDetailViewController!
    var favoriteManager: FavoriteManager!
    private var defaults: UserDefaults = UserDefaults(suiteName: "com.guilherme.ComicDetailViewControllerTests.fast_marvel")!
    private let favoriteKey = "test_favorite"
    private var comic: Comic!
    
    override func setUp() {
        defaults.set(nil, forKey: favoriteKey)
        favoriteManager = FavoriteManager(defaults: defaults, favoriteKey: favoriteKey)
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        comic = comics.data?.results?.first!
        sut = ComicDetailViewController(comic: comic, favoriteManager: favoriteManager)
    }
    
    func test_detail_controller() {
        sut.loadView()
        sut.viewDidLoad()

        let favoriteButton = sut.view.subviews[6] as! UIButton
        XCTAssertEqual(favoriteButton.image(for: .normal), UIImage(named: "favoriteOff"))
        
        let button = UIButton()
        sut.didTapFavoriteButton(button)
        
        XCTAssertEqual(favoriteButton.image(for: .normal), UIImage(named: "favoriteOn"))
        
        XCTAssertEqual(favoriteManager.listFavorite().count, 1)
        XCTAssertEqual(favoriteManager.listFavorite().first?.id, comic.id)
        
        let comicName = sut.view.subviews[1] as! UILabel
        XCTAssertEqual(comicName.text, comic.title)
        
        if let price = comic.prices?.first {
            if price.price == 0.0 {
                XCTAssertTrue((sut.view.subviews[3] as! UIButton).isHidden)
            } else {
                XCTAssertFalse((sut.view.subviews[3] as! UIButton).isHidden)
            }
        }
    }
}
