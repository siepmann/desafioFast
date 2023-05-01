//
//  CartControllerTest.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import XCTest
@testable import fast_marvel

final class CartControllerTest: XCTestCase, Mockable {
    var sut: CartResumeViewController!
    var presenter: CartPresenter!
    var tableView: UITableView!
    var datasource: CartDataSource!
    var delegate: UITableViewDelegate!
    
    override func setUp() {
        presenter = CartPresenter()
        
        sut = CartResumeViewController(presenter: presenter)
        
        presenter.attachView(view: self)
        
        sut.loadViewIfNeeded()
        
        tableView = sut.view.subviews.first(where: { $0 is UITableView }) as! UITableView
        datasource = CartDataSource(resume: [], delegate: self)
        
        tableView.dataSource = datasource
        delegate = tableView.delegate
    }
    
    func test_cell_not_nil() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resumeCell")
        XCTAssertNotNil(cell)
    }
    
    func test_number_of_rows() {
        var rows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, 0)

        self.datasource.resume = [CartResume(id: 1, comicName: "teste", price: 1.0, quantity: 1, comicThumb: "")]
        self.tableView.reloadData()
        rows = tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, 1)
    }
    
    func test_cell_height() {
        self.datasource.resume = [CartResume(id: 1, comicName: "teste", price: 1.0, quantity: 1, comicThumb: "")]
        self.tableView.reloadData()
        
        let cellHeight = delegate.tableView?(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cellHeight, UITableView.automaticDimension)
    }
    
    func test_cell_events() {
        let comics = self.loadComics().sorted {
            ($0.id ?? 0) < ($1.id ?? 0)
        }
        
        let valueFirstComic = (comics[0].prices?.first(where: { $0.type == "printPrice" })?.price ?? 0)
        let doubleValue = valueFirstComic * 2
        CartManager.shared.addToCart(comic: comics[0])
        
        self.datasource.resume = CartManager.shared.createCartResume()
        self.tableView.reloadData()
        
        var cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        let priceLabel = cell?.subviews[1].subviews[2] as! UILabel
        XCTAssertEqual(priceLabel.text, "USD \(valueFirstComic.toString())")
        
        let addOneItemButton = cell?.subviews[1].subviews[6] as! UIButton
        addOneItemButton.sendActions(for: .touchUpInside)
        
        cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(priceLabel.text, "USD \(doubleValue.toString())")
        
        let removeOneItemButton = cell?.subviews[1].subviews[4] as! UIButton
        removeOneItemButton.sendActions(for: .touchUpInside)
        
        cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(priceLabel.text, "USD \(valueFirstComic.toString())")
        
        let removeAllEntriesButton = cell?.subviews[1].subviews[3] as! UIButton
        removeAllEntriesButton.sendActions(for: .touchUpInside)
        cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(datasource.resume.count, 0)
    }
    
    private func loadComics() -> [Comic] {
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        return comics.data?.results ?? []
    }
}

extension CartControllerTest: CartPresentable {
    func changeCart(comicId: Int, action: CartActionType) {
        self.presenter.changeCart(comicId: comicId,
                                  action: action)
    }
    
    func displayCart(resume: [CartResume]) {
        datasource.resume = resume
        tableView.reloadData()
    }
}
