//
//  CartPresenterTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import XCTest
@testable import fast_marvel

final class CartPresenterTest: XCTestCase, Mockable {
    var presenter: CartPresenterProtocol!
    var managerMock = CartManager.shared
    
    var itensAfterRemove: [Comic] = []
    var valueAfterRemove: Double = 0.0
    
    var expectation: XCTestExpectation?
        
    override func setUp() {
        presenter = CartPresenter()
        
        let comics = loadJSON(filename: "comics_response", type: ComicsModel.self)
        managerMock.addToCart(comic: (comics.data?.results?[0])!)
        managerMock.addToCart(comic: (comics.data?.results?[0])!)
        managerMock.addToCart(comic: (comics.data?.results?[0])!)
        managerMock.addToCart(comic: (comics.data?.results?[1])!)
        managerMock.addToCart(comic: (comics.data?.results?[1])!)
    }
    
    override func tearDown() {
        managerMock.emptyCart()
        super.tearDown()
    }
    
    func test_cartPresenter_total_value() {
        let resume = presenter.displayCartResume()
        
        let sum = resume.reduce(0, { $0 + $1.price })
        XCTAssertEqual(sum.roundToDecimal(2), 7.7)
    }

    func test_cartPresenter_comic_count() {
        let resume = presenter.displayCartResume()
        XCTAssertEqual(resume.count, 2)
        
        let sum = resume.reduce(0, { $0 + $1.quantity })
        XCTAssertEqual(sum, 5)
    }

    func test_cartPresenter_remove_item() {
        presenter.removeFromCart(comic: managerMock.comics.first!)
        let resume = presenter.displayCartResume()
        
        let sum = resume.reduce(0, { $0 + $1.price })
        XCTAssertEqual(sum.roundToDecimal(2), 6.0)
        
        let count = resume.reduce(0, { $0 + $1.quantity })
        XCTAssertEqual(count, 4)
    }
}
