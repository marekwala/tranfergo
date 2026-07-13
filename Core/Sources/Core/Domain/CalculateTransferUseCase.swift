//
//  CalculateTransferUseCaseProtocol.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

public protocol CalculateTransferUseCaseProtocol {
    func execute(sourceAmount: Double, sourceCurrency: Currency, targetCurrency: Currency) async throws -> TransferCalculation
}

public final class CalculateTransferUseCase: CalculateTransferUseCaseProtocol {
    private let repository: FXRepository
    
    public init(repository: FXRepository) {
        self.repository = repository
    }
    
    public func execute(sourceAmount: Double, sourceCurrency: Currency, targetCurrency: Currency) async throws -> TransferCalculation {
        let result = try await repository.fetchFXRate(
            from: sourceCurrency.code,
            to: targetCurrency.code,
            amount: sourceAmount
        )
        
        return TransferCalculation(
            sourceCurrency: sourceCurrency,
            targetCurrency: targetCurrency,
            rate: result.rate,
            sourceAmount: result.fromAmount,
            targetAmount: result.toAmount
        )
    }
}
