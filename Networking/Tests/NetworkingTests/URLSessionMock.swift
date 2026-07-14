//
//  URLSessionMock.swift
//  Networking
//
//  Created by Marek Wala on 14/07/2026.
//


import XCTest
@testable import Networking
import Core

final class URLSessionMock: URLSessionProtocol {
    var stubbedData: Data?
    var stubbedResponse: URLResponse?
    var stubbedError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = stubbedError {
            throw error
        }
        
        let data = stubbedData ?? Data()
        let response = stubbedResponse ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        return (data, response)
    }
}
