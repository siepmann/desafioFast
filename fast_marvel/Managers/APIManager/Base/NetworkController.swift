//
//  NetworkController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation

protocol NetworkControllerProtocol {
    func request<T>(router: RouterProtocol,
                    type: T.Type
    ) async -> Result<T, RequestErrorModel> where T: Decodable
}

extension NetworkControllerProtocol {
    func request<T>(router: RouterProtocol,
                    type: T.Type
    ) async -> Result<T, RequestErrorModel> where T: Decodable {
        do {

            let (data, response) = try await URLSession.shared.data(for: router.toRequest())
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(RequestErrorModel.notFoundError())
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(type, from: data) else {
                    return .failure(RequestErrorModel.decodeError())
                }
                return .success(decodedResponse)
            default:
                guard let decodedResponse = try? JSONDecoder().decode(RequestErrorModel.self, from: data) else {
                    return .failure(RequestErrorModel.decodeError())
                }
                return .failure(decodedResponse)
            }
        } catch {
            return .failure(RequestErrorModel.unknownError())
        }
    }
}
