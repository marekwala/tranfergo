//
//  CurrencyViewModel.swift
//  TransferGo
//
//  Created by Marek Wala on 15/07/2026.
//

import Foundation

public struct CurrencyViewModel: Identifiable, Equatable, Sendable {
    public var id: String { code }
    public let code: String
    public let name: String
    public let flagImageName: String
    public let limit: Decimal?
}
