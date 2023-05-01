//
//  CartManagerTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import XCTest
@testable import fast_marvel

final class CartManagerTest: XCTestCase, Mockable {
    var comics: [Comic] = []
    var itensAfterRemove: [Comic] = []
    var valueAfterRemove: Double = 0.0

    override func setUp() {
        let comicsData = loadJSON(filename: "comics_response", type: ComicsModel.self)
        self.comics = comicsData.data?.results ?? []
        CartManager.shared.addToCart(comic: self.comics[0])
        CartManager.shared.addToCart(comic: self.comics[1])
    }
    
    override func tearDown() {
        CartManager.shared.emptyCart()
        super.tearDown()
    }
    
    func test_cartPresenter_value() {
        XCTAssertEqual(CartManager.shared.cartTotal.roundToDecimal(2), 3)
    }
    
    func test_cartPresenter_comic_count() {
        XCTAssertEqual(CartManager.shared.comics.count, 2)
    }
    
    func test_cartPresenter_remove_item() {
        CartManager.shared.removeFromCart(comic: self.comics[0])
        XCTAssertEqual(CartManager.shared.cartTotal.roundToDecimal(2), 1.3)
        XCTAssertEqual(CartManager.shared.comics.count, 1)
    }
}
