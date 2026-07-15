//
//  TransferViewModelTests.swift
//  TransferGo
//
//  Created by Marek Wala on 14/07/2026.
//

import XCTest
import Combine
@testable import TransferGo

@MainActor
final class TransferViewModelTests: XCTestCase {
    private var useCaseMock: CalculateTransferUseCaseMock!
    private var sut: TransferViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        useCaseMock = CalculateTransferUseCaseMock()
        cancellables = []
    }
    
    override func tearDown() {
        useCaseMock = nil
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_init_setsDefaultsAndFetchesInitialRate() async {
        // Given
        sut = TransferViewModel(calculateUseCase: useCaseMock)
        
        // Then
        XCTAssertEqual(sut.fromCurrency.code, "PLN")
        XCTAssertEqual(sut.toCurrency.code, "UAH")
        XCTAssertEqual(sut.fromAmountString, "300.00")
    }
    
    func test_limitValidation_exceededLimit_setsErrorMessage() async {
        // Given
        sut = TransferViewModel(calculateUseCase: useCaseMock)
        
        // When
        sut.fromAmountString = "25000.00"
        await sut.fetchRate(updatingSourceAmount: true)
        
        // Then
        XCTAssertTrue(sut.isLimitExceeded)
        XCTAssertNotNil(sut.limitErrorMessage)
        XCTAssertTrue(sut.limitErrorMessage?.contains("20 000 PLN") ?? false)
    }
    
    func test_swapCurrencies_swapsSourceAndTarget() async {
        // Given
        sut = TransferViewModel(calculateUseCase: useCaseMock)
        let initialFrom = sut.fromCurrency
        let initialTo = sut.toCurrency
        
        // When
        sut.swapCurrencies()
        
        // Then
        XCTAssertEqual(sut.fromCurrency, initialTo)
        XCTAssertEqual(sut.toCurrency, initialFrom)
    }
}


