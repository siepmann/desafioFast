//
//  ComicRoute.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation

enum ComicsRoute {
    case getComics(offset: Int)
    case getComicWithId(id: Int)
}

extension ComicsRoute: RouterProtocol {
    var method: String {
        return "GET"
    }
    
    var path: String {
        switch self {
        case .getComics(_):
            return "/v1/public/comics"
        case .getComicWithId(let id):
            return "/v1/public/comics/\(id)"
        }
    }
    
    var host: String {
        return "gateway.marvel.com"
    }
    
    var headers: [String : Any] {
        return [:]
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getComics(let offset):
            return ["offset": offset]
        default:
            return [:]
        }
    }
}
