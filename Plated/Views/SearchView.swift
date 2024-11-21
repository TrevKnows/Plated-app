//
//  SearchBar.swift
//  Plated
//
//  Created by Trevor Beaton on 11/20/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search recipes...", text: $text)
                .foregroundColor(.primary)
                .frame(height: 32)
                
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal)
    }
}

#Preview {
    SearchView(text: .constant("Test"))
}
