import XCTest
@testable import Networking
import Core

final class NetworkFXRepositoryTests: XCTestCase {
    
    private var sessionMock: URLSessionMock! /// ☕ TODO: Add Mock
    private var sut: NetworkFXRepository! /// ☕ TODO: Add Repository
    
    override func setUp() {
        super.setUp()
        sessionMock = URLSessionMock()
        sut = NetworkFXRepository(session: sessionMock, baseURL: "https://mock.api.transfergo.com/api/fx-rates")
    }
    
    override func tearDown() {
        sessionMock = nil
        sut = nil
        super.tearDown()
    }
    
    func test_fetchFXRate_success_returnsMappedResult() async throws {
        // Given
        let json = """
        {
            "from": "PLN",
            "to": "EUR",
            "rate": 0.25,
            "fromAmount": 100.0,
            "toAmount": 25.0
        }
        """
        sessionMock.stubbedData = json.data(using: .utf8)
        
        // When
        let result = try await sut.fetchFXRate(from: "PLN", to: "EUR", amount: 100.0)
        
        // Then
        XCTAssertEqual(result.from, "PLN")
        XCTAssertEqual(result.to, "EUR")
        XCTAssertEqual(result.rate, 0.25)
        XCTAssertEqual(result.fromAmount, 100.0)
        XCTAssertEqual(result.toAmount, 25.0)
    }
    
    func test_fetchFXRate_serverError_throwsError() async {
        // Given
        sessionMock.stubbedResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.transfergo.com/api/fx-rates")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        
        // Then
        do {
            _ = try await sut.fetchFXRate(from: "PLN", to: "EUR", amount: 100.0)
            XCTFail("Should throw serverError")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.serverError(statusCode: 500)) /// ☕ TODO: Add Error
        }
    }
}
