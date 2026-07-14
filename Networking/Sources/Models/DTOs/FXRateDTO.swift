//
//  FXRateDTO.swift
//  Networking
//
//  Created by Marek Wala on 13/07/2026.
//

struct FXRateDTO: Decodable {
    let from: String
    let to: String
    let rate: Double
    let fromAmount: Double
    let toAmount: Double
}
