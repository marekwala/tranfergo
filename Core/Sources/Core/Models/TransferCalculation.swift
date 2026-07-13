//
//  TransferCalculation.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

public struct TransferCalculation: Equatable {
    public let sourceCurrency: Currency
    public let targetCurrency: Currency
    public let rate: Double
    public let sourceAmount: Double
    public let targetAmount: Double
    
    public init(sourceCurrency: Currency, targetCurrency: Currency, rate: Double, sourceAmount: Double, targetAmount: Double) {
        self.sourceCurrency = sourceCurrency
        self.targetCurrency = targetCurrency
        self.rate = rate
        self.sourceAmount = sourceAmount
        self.targetAmount = targetAmount
    }
}
