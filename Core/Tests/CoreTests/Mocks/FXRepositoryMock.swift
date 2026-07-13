//
//  FXRepositoryMock.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

import XCTest
@testable import Core

final class FXRepositoryMock: FXRepository {
    private(set) var fetchFXRateCalled = false
    private(set) var passedFrom: String?
    private(set) var passedTo: String?
    private(set) var passedAmount: Double?

    var stubbedResult: FXRateResult?
    var throwError: Error?
    
    func fetchFXRate(from source: String, to target: String, amount: Double) async throws -> FXRateResult {
        fetchFXRateCalled = true
        passedFrom = source
        passedTo = target
        passedAmount = amount
        
        if let error = throwError {
            throw error
        }
        
        return stubbedResult ?? FXRateResult(from: source, to: target, rate: 0.0, fromAmount: amount, toAmount: 0.0)
    }
}
