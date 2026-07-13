//
//  Currency.swift
//  Core
//
//  Created by Marek Wala on 13/07/2026.
//

public struct Currency: Equatable, Hashable {
    public let code: String
    public let name: String
    public let symbol: String
    
    public init(code: String, name: String, symbol: String) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }
}
