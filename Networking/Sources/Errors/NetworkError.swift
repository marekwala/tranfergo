//
//  NetworkError.swift
//  Networking
//
//  Created by Marek Wala on 13/07/2026.
//

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
}
