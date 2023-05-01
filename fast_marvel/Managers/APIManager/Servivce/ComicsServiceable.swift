//
//  ComicsServiceable.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation

protocol ComicsServiceable {
    func getComics(offset: Int) async -> Result<ComicsModel, RequestErrorModel>
    func getComicsById(id: Int) async -> Result<ComicsModel, RequestErrorModel>
}

struct ComicsService: NetworkControllerProtocol, ComicsServiceable {
    func getComics(offset: Int) async -> Result<ComicsModel, RequestErrorModel> {
        return await request(router: ComicsRoute.getComics(offset: offset),
                             type: ComicsModel.self)
    }
    
    func getComicsById(id: Int) async -> Result<ComicsModel, RequestErrorModel> {
        return await request(router: ComicsRoute.getComicWithId(id: id),
                             type: ComicsModel.self)
    }
}
