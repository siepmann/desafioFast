//
//  ErrorModel.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation

struct RequestErrorModel: Codable, Error {
    let code: Int
    let status: String
    
    static func notFoundError() -> RequestErrorModel {
        return self.init(code: 404,
                         status: "Not found")
    }
    
    static func decodeError() -> RequestErrorModel {
        return self.init(code: 404,
                         status: "Decode Error")
    }
    
    static func unknownError() -> RequestErrorModel {
        return self.init(code: 404,
                         status: "Unknown error")
    }
}
