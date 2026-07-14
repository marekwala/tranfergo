//
//  NetworkFXRepository.swift
//  Networking
//
//  Created by Marek Wala on 13/07/2026.
//

import Foundation
import Core

public final class NetworkFXRepository: FXRepository {
        private let session: URLSessionProtocol
        private let baseURL: String
        
        public init(session: URLSessionProtocol = URLSession.shared, baseURL: String = "https://my.transfergo.com/api/fx-rates") {
            self.session = session
            self.baseURL = baseURL
        }
    
    public func fetchFXRate(from source: String, to target: String, amount: Double) async throws -> FXRateResult {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "from", value: source),
            URLQueryItem(name: "to", value: target),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        let decoder = JSONDecoder()
        guard let dto = try? decoder.decode(FXRateDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return FXRateResult(
            from: dto.from,
            to: dto.to,
            rate: dto.rate,
            fromAmount: dto.fromAmount,
            toAmount: dto.toAmount
        )
    }
}
