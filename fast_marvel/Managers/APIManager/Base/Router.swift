//
//  Router.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation
import CryptoKit

public protocol RouterProtocol {
    var method: String { get }
    var path: String { get }
    var host: String { get }
    var headers: [String: Any] { get }
    var parameters: [String: Any] { get }
    
    /// This function has a generic implenetation for the more simple routes, all others should have their own.
    func toRequest() -> URLRequest
}

extension RouterProtocol {
    var parameters: [String: Any] {
        return [:]
    }
    
    /// The basic implementation of `Route` `toRequest` adds parameters and builds the path.
    public func toRequest() -> URLRequest {
        let apikey = "57e250ddd3d5cb02ee99847e267a98ae"
        let privateKey = "e735a5f41362c72aa14d34604abb21f46a42bf1a"
        
        var urlComponents = URLComponents()
        urlComponents.port = 443
        urlComponents.scheme = "https"
        urlComponents.host = self.host
        urlComponents.path = self.path
        
        urlComponents.queryItems = []
        urlComponents.queryItems?.append(URLQueryItem(name: "apikey", value: apikey))
        
        let ts = Date().timeIntervalSince1970
        
        urlComponents.queryItems?.append(URLQueryItem(name: "ts", value: "\(ts)"))
        
        let hash = Insecure.MD5.hash(data: ("\(ts)" + privateKey + apikey).data(using: .utf8)!)
        let computedString = hash.map { String(format: "%02hhx", $0) }.joined()
        
        urlComponents.queryItems?.append(URLQueryItem(name: "hash", value: computedString))
        
        parameters.forEach({
            urlComponents.queryItems?.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        })
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = self.method
        
        self.headers.forEach { key, value in
            request.addValue("\(value)", forHTTPHeaderField: key)
        }

        return request
    }
}
