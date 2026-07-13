//
//  FXRepository.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

public protocol FXRepository {
    func fetchFXRate(from source: String, to target: String, amount: Double) async throws -> FXRateResult
}
