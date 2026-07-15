//
//  TransferView.swift
//  TransferGo
//
//  Created by Marek Wala on 14/07/2026.
//

import SwiftUI

public struct TransferView: View {
    @ObservedObject var viewModel: TransferViewModel
    @State private var isSelectingFrom = false
    @State private var isSelectingTo = false
    
    private let brandPink = Color(red: 229/255, green: 71/255, blue: 109/255)
    private let backgroundColor = Color(red: 237/255, green: 240/255, blue: 244/255)
    
    public init(viewModel: TransferViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                if viewModel.networkErrorMessage != nil {
                    networkPopup
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                VStack(spacing: 0) {
                    currencyRow(title: "Sending from", isFrom: true)
                        .shadow(radius: 20)
                    currencyRow(title: "Receiver gets", isFrom: false)
                }
                .frame(width: 320, height: 184)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(middleBadges)
                
                if let limitError = viewModel.limitErrorMessage {
                    infoBanner(text: limitError)
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isSelectingFrom) { CountryListView(viewModel: viewModel, isSelectingFrom: true) }
            .sheet(isPresented: $isSelectingTo) { CountryListView(viewModel: viewModel, isSelectingFrom: false) }
        }
    }
    
    private func currencyRow(title: String, isFrom: Bool) -> some View {
        let isError = viewModel.isLimitExceeded
        let rowBackground = (isFrom && isError) ? Color.white : (isFrom ? .white : backgroundColor)
        
        return VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 14)).foregroundColor(.gray)
            HStack {
                Button(action: { isFrom ? (isSelectingFrom = true) : (isSelectingTo = true) }) {
                    HStack(spacing: 8) {
                        flagView(for: isFrom ? viewModel.fromCurrency : viewModel.toCurrency)
                            .frame(width: 24, height: 24)
                        Text(isFrom ? viewModel.fromCurrency.code : viewModel.toCurrency.code)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .bold)).foregroundColor(.gray)
                    }
                }
                Spacer()
                TextField("0.00", text: isFrom ? $viewModel.fromAmountString : $viewModel.toAmountString)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(isError ? .red : .blue)
                    .accessibilityIdentifier("swapButton")
            }
        }
        .padding()
        .frame(height: 92)
        .background(rowBackground)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(brandPink, lineWidth: (isFrom && isError) ? 2 : 0))
    }
    
    private var middleBadges: some View {
        ZStack {
            HStack {
                Button(action: { withAnimation { viewModel.swapCurrencies() } }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                        .padding(8).background(Color.blue).clipShape(Circle())
                        .offset(x: 24)
                        .accessibilityIdentifier("swapButton")
                }
                Spacer()
            }
            HStack {
                Text(viewModel.currentRateText)
                    .font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 4)
                    .background(Color.black).clipShape(Capsule())
                    .offset(x: -24)
            }
        }
    }
    
    private func infoBanner(text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
            Text(text).font(.system(size: 12))
            Spacer()
        }
        .foregroundColor(brandPink)
        .padding(.horizontal, 12)
        .frame(width: 320, height: 32)
        .background(brandPink.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var networkPopup: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                .padding(12).background(brandPink).clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("No network").font(.system(size: 18, weight: .bold)).foregroundColor(Color(red: 10/255, green: 37/255, blue: 64/255))
                Text("Check your internet connection").font(.system(size: 14)).foregroundColor(.gray)
            }
            Spacer()
            Button(action: { withAnimation { viewModel.networkErrorMessage = nil } }) {
                Image(systemName: "xmark").foregroundColor(.gray).font(.system(size: 16, weight: .medium))
            }
        }
        .padding()
        .frame(width: 320)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func flagView(for currency: CurrencyViewModel) -> some View {
        Image(currency.flagImageName)
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
    }
}
