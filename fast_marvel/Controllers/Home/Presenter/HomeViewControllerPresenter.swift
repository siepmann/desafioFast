//
//  ComicsPresenter.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 25/04/23.
//

import Foundation
import UIKit

protocol HomeViewControllerViewProtocol: NSObjectProtocol {
    func setComics(comics: [Comic])
}

protocol HomeViewControllerPresenterProtocol: NSObjectProtocol {
    func attachView(comicsView: HomeViewControllerViewProtocol) 
    func loadData(offset: Int)
}

class HomeViewControllerPresenter: NSObject, HomeViewControllerPresenterProtocol {
    private let service: ComicsServiceable
    private weak var comicsView: HomeViewControllerViewProtocol?
    
    init(service: ComicsServiceable) {
        self.service = service
    }
    
    deinit {
        self.comicsView = nil
    }
    
    func attachView(comicsView: HomeViewControllerViewProtocol) {
        self.comicsView = comicsView
    }
    
    func loadData(offset: Int) {
        fetchData(offset: offset)  { [weak self] result in
            switch result {
            case .success(let response):
                self?.comicsView?.setComics(comics: response.data?.results ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchData(offset: Int, completion: @escaping (Result<ComicsModel, RequestErrorModel>) -> Void) {
        Task(priority: .background) {
            let result = await service.getComics(offset: offset)
            completion(result)
        }
    }
}
