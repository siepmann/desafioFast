//
//  HomePresenterMock.swift
//  fast_marvelTests
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import Foundation
@testable import fast_marvel

class HomePresenterMock: NSObject, HomeViewControllerPresenterProtocol, Mockable {
    private weak var comicsView: HomeViewControllerViewProtocol?
    
    deinit {
        comicsView = nil
    }
    
    func attachView(comicsView: HomeViewControllerViewProtocol) {
        self.comicsView = comicsView
    }
    
    func loadData(offset: Int) {
        let comics = loadJSON(filename: "comic_by_id_response", type: ComicsModel.self)
        comicsView?.setComics(comics: comics.data?.results ?? [])
    }
}
