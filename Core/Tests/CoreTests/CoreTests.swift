
import XCTest
@testable import Core

final class CalculateTransferUseCaseTests: XCTestCase {
    private let pln = Currency(code: "PLN", name: "Zloty", symbol: "zł")
    private let eur = Currency(code: "EUR", name: "Euro", symbol: "€")
    
    private var repositoryMock: FXRepositoryMock!
    private var sut: CalculateTransferUseCase!
    
    override func setUp() {
        super.setUp()
        repositoryMock = FXRepositoryMock()
        sut = CalculateTransferUseCase(repository: repositoryMock)
    }
    
    override func tearDown() {
        repositoryMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_execute_callsRepositoryWithCorrectParameters() async throws {
        // Given
        let requestedAmount = 100.0
        
        // When
        _ = try? await sut.execute(sourceAmount: requestedAmount, sourceCurrency: pln, targetCurrency: eur)
        
        // Than
        XCTAssertTrue(repositoryMock.fetchFXRateCalled)
        XCTAssertEqual(repositoryMock.passedFrom, "PLN")
        XCTAssertEqual(repositoryMock.passedTo, "EUR")
        XCTAssertEqual(repositoryMock.passedAmount, 100.0)
    }
    
    func test_execute_returnsMappedCalculation_whenRepositorySucceeds() async throws {
        // Given
        repositoryMock.stubbedResult = FXRateResult(
            from: "PLN",
            to: "EUR",
            rate: 0.23102,
            fromAmount: 2.0,
            toAmount: 0.46
        )
        
        // When
        let result = try await sut.execute(sourceAmount: 2.0, sourceCurrency: pln, targetCurrency: eur)
        
        // Then
        XCTAssertEqual(result.sourceAmount, 2.0)
        XCTAssertEqual(result.targetAmount, 0.46)
        XCTAssertEqual(result.rate, 0.23102)
        XCTAssertEqual(result.sourceCurrency, pln)
        XCTAssertEqual(result.targetCurrency, eur)
    }
    
    func test_execute_propagatesError_whenRepositoryFails() async {
        // Given
        let expectedError = NSError(domain: "NetworkError", code: -1009)
        repositoryMock.throwError = expectedError
        
        // Then
        do {
            _ = try await sut.execute(sourceAmount: 2.0, sourceCurrency: pln, targetCurrency: eur)
            XCTFail("Expected execute to throw error, but it succeeded instead.")
        } catch {
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}
