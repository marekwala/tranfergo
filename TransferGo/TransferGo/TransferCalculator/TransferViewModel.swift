//
//  TransferViewModel.swift
//  TransferGo
//
//  Created by Marek Wala on 14/07/2026.
//

import Foundation
import Combine
import Core

@MainActor
public final class TransferViewModel: ObservableObject {
    @Published public var fromCurrency: CurrencyViewModel
    @Published public var toCurrency: CurrencyViewModel
    @Published public var fromAmountString: String = "300.00"
    @Published public var toAmountString: String = ""
    
    @Published public var limitErrorMessage: String? = nil
    @Published public var isLimitExceeded: Bool = false
    @Published public var networkErrorMessage: String? = nil
    
    @Published public var currentRateText: String = "1 PLN = 1.00 UAH"
    @Published public var isFetching: Bool = false
    @Published public var searchQuery: String = ""
    
    public let availableCurrencies: [CurrencyViewModel]
    private let calculateUseCase: CalculateTransferUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var isUpdatingInternally = false
    
    public init(calculateUseCase: CalculateTransferUseCaseProtocol) {
        self.calculateUseCase = calculateUseCase
        self.availableCurrencies = SupportedCurrencies.all.map {
            CurrencyViewModel(code: $0.code, name: $0.name, flagImageName: $0.flagImageName, limit: $0.limit)
        }
        
        self.fromCurrency = availableCurrencies.first(where: { $0.code == "PLN" }) ?? availableCurrencies[0]
        self.toCurrency = availableCurrencies.first(where: { $0.code == "UAH" }) ?? availableCurrencies[3]
        
        setupDebouncedBindings()
        Task {
            await fetchRate(updatingSourceAmount: true)
        }
    }
    
    public var filteredCurrencies: [CurrencyViewModel] {
        if searchQuery.isEmpty {
            return availableCurrencies
        }
        return availableCurrencies.filter {
            $0.name.localizedCaseInsensitiveContains(searchQuery) ||
            $0.code.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    private func setupDebouncedBindings() {
        $fromAmountString
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task { @MainActor in
                    guard !self.isUpdatingInternally else { return }
                    await self.fetchRate(updatingSourceAmount: true)
                }
            }
            .store(in: &cancellables)
        
        $toAmountString
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task { @MainActor in
                    guard !self.isUpdatingInternally else { return }
                    await self.fetchRate(updatingSourceAmount: false)
                }
            }
            .store(in: &cancellables)
    }
    
    public func fetchRate(updatingSourceAmount: Bool) async {
        guard !isFetching else { return }
        isFetching = true
        networkErrorMessage = nil
        
        let amountToUse = updatingSourceAmount ?
            (Double(fromAmountString) ?? 0.0) :
            (Double(toAmountString) ?? 0.0)
        
        validateLimits()
        
        guard let domainFrom = SupportedCurrencies.find(fromCurrency.code),
              let domainTo = SupportedCurrencies.find(toCurrency.code) else {
            isFetching = false
            return
        }
        
        do {
            let calculation = try await calculateUseCase.execute(
                sourceAmount: updatingSourceAmount ? amountToUse : 1.0,
                sourceCurrency: domainFrom,
                targetCurrency: domainTo
            )
            
            isUpdatingInternally = true
            
            if updatingSourceAmount {
                self.toAmountString = String(format: "%.2f", calculation.targetAmount)
            } else {
                let targetVal = Double(toAmountString) ?? 0.0
                let calculatedSource = calculation.rate > 0 ? (targetVal / calculation.rate) : 0.0
                self.fromAmountString = String(format: "%.2f", calculatedSource)
                validateLimits()
            }
            
            self.currentRateText = "1 \(fromCurrency.code) = \(String(format: "%.4f", calculation.rate)) \(toCurrency.code)"
            isUpdatingInternally = false
        } catch {
            networkErrorMessage = "No network. Check your internet connection"
        }
        
        isFetching = false
    }
    
    public func swapCurrencies() {
        isUpdatingInternally = true
        let tempCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrency
        
        let tempAmount = fromAmountString
        fromAmountString = toAmountString
        toAmountString = tempAmount
        isUpdatingInternally = false
        
        Task {
            await fetchRate(updatingSourceAmount: true)
        }
    }
    
    private func validateLimits() {
        guard let amount = Decimal(string: fromAmountString) else {
            isLimitExceeded = false
            limitErrorMessage = nil
            return
        }
        
        if let limit = fromCurrency.limit, amount > limit {
            isLimitExceeded = true
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = " "
            let formattedLimit = formatter.string(from: limit as NSDecimalNumber) ?? "\(limit)"
            limitErrorMessage = "Maximum sending amount: \(formattedLimit) \(fromCurrency.code)"
        } else {
            isLimitExceeded = false
            limitErrorMessage = nil
        }
    }
    
    public func selectFromCurrency(_ currency: CurrencyViewModel) {
        fromCurrency = currency
        Task {
            await fetchRate(updatingSourceAmount: true)
        }
    }
    
    public func selectToCurrency(_ currency: CurrencyViewModel) {
        toCurrency = currency
        Task {
            await fetchRate(updatingSourceAmount: true)
        }
    }
}
