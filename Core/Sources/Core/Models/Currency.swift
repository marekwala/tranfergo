//
//  Currency.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

import Foundation

public struct Currency: Hashable, Identifiable, Equatable, Sendable {
    public var id: String { code }
    public let code: String
    public let name: String
    public let flagImageName: String
    public let limit: Decimal
    
    public init(code: String, name: String, flagImageName: String, limit: Decimal) {
        self.code = code
        self.name = name
        self.flagImageName = flagImageName
        self.limit = limit
    }
    
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code &&
               lhs.name == rhs.name &&
               lhs.flagImageName == rhs.flagImageName &&
               lhs.limit == rhs.limit
    }
}

public enum SupportedCurrencies : Sendable{
    public static let all: [Currency] = [
        Currency(code: "PLN", name: "Poland", flagImageName: "flag_pl", limit: 20000),
        Currency(code: "EUR", name: "Germany", flagImageName: "flag_de", limit: 5000),
        Currency(code: "GBP", name: "Great Britain", flagImageName: "flag_gb", limit: 1000),
        Currency(code: "UAH", name: "Ukraine", flagImageName: "flag_ua", limit: 50000)
    ]
    
    public static func find(_ code: String) -> Currency? {
        all.first(where: { $0.code == code })
    }
}
