//
//  TransferViewBuilder.swift
//  TransferGo
//
//  Created by Marek Wala on 14/07/2026.
//

import SwiftUI
import Core
import Networking

@MainActor
public final class TransferViewBuilder {
    public static func make() -> some View {
        let networkRepository = NetworkFXRepository()
        let useCase = CalculateTransferUseCase(repository: networkRepository)
        
        let viewModel = TransferViewModel(
            calculateUseCase: useCase
        )
        
        return TransferView(viewModel: viewModel)
    }
}
