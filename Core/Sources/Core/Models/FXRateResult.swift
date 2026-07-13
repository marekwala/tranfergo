//
//  FXRateResult.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

public struct FXRateResult: Equatable {
    public let from: String
    public let to: String
    public let rate: Double
    public let fromAmount: Double
    public let toAmount: Double
    
    public init(from: String, to: String, rate: Double, fromAmount: Double, toAmount: Double) {
        self.from = from
        self.to = to
        self.rate = rate
        self.fromAmount = fromAmount
        self.toAmount = toAmount
    }
}
