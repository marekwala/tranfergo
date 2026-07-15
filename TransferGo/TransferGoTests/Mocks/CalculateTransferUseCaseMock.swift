//
//  CalculateTransferUseCaseMock.swift
//  TransferGo
//
//  Created by Marek Wala on 15/07/2026.
//

@testable import Core

final class CalculateTransferUseCaseMock: CalculateTransferUseCaseProtocol {
    var stubbedCalculation = TransferCalculation(
        sourceCurrency: SupportedCurrencies.all[0],
        targetCurrency: SupportedCurrencies.all[3],
        rate: 7.23,
        sourceAmount: 100.0,
        targetAmount: 723.0
    )
    
    func execute(sourceAmount: Double, sourceCurrency: Currency, targetCurrency: Currency) async throws -> TransferCalculation {
        return TransferCalculation(
            sourceCurrency: sourceCurrency,
            targetCurrency: targetCurrency,
            rate: stubbedCalculation.rate,
            sourceAmount: sourceAmount,
            targetAmount: sourceAmount * stubbedCalculation.rate
        )
    }
}
