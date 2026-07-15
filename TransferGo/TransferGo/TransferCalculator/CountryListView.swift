//
//  CountryListView.swift
//  TransferGo
//
//  Created by Marek Wala on 15/07/2026.
//


import SwiftUI

struct CountryListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TransferViewModel
    let isSelectingFrom: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search", text: $viewModel.searchQuery)
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()
                
                Text("All countries")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                List(viewModel.filteredCurrencies) { currency in
                    Button(action: {
                        if isSelectingFrom {
                            viewModel.selectFromCurrency(currency)
                        } else {
                            viewModel.selectToCurrency(currency)
                        }
                        dismiss()
                    }) {
                        HStack(spacing: 16) {
                            Image(currency.flagImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(currency.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("\(currency.code) • \(currency.code)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(isSelectingFrom ? "Sending from" : "Sending to")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
