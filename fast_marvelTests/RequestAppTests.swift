//
//  RequestAppTests.swift
//  fast_marvelUITests
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import XCTest
@testable import fast_marvel

final class RequestAppTests: XCTestCase {
    func test_get_comics_mock() async {
        let serviceMock = ComicsServiceMock()
        let requestResult = await serviceMock.getComics(offset: 0)
        
        switch requestResult {
        case.success(let comics):
            XCTAssertEqual(comics.code, 200)
            XCTAssertEqual(comics.data?.count, 20)
            XCTAssertEqual(comics.data?.results?[0].title, "Marvel Previews (2017)")
        case .failure:
            XCTFail("The request should not fail")
        }
    }
    
    func test_get_comics_by_id() async {
        let serviceMock = ComicsServiceMock()
        let requestResult = await serviceMock.getComicsById(id: 82967)
        
        switch requestResult {
        case.success(let comics):
            XCTAssertEqual(comics.code, 200)
            XCTAssertEqual(comics.data?.count, 1)
            XCTAssertEqual(comics.data?.results?[0].id, 82967)
        case .failure:
            XCTFail("The request should not fail")
        }
    }
    
    func test_comic_thumb_url() async {
        let serviceMock = ComicsServiceMock()
        let requestResult = await serviceMock.getComicsById(id: 82967)
        
        switch requestResult {
        case.success(let comics):
            XCTAssertEqual(comics.data?.results?[0].thumbnail?.thumbURL(),
                           "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg")
        case .failure:
            XCTFail("The request should not fail")
        }
    }
}

final class ComicsServiceMock: Mockable, ComicsServiceable {
    func getComics(offset: Int) async -> Result<ComicsModel, RequestErrorModel> {
        return .success(loadJSON(filename: "comics_response", type: ComicsModel.self))
    }
    
    func getComicsById(id: Int) async -> Result<ComicsModel, RequestErrorModel> {
        return .success(loadJSON(filename: "comic_by_id_response", type: ComicsModel.self))
    }
}
