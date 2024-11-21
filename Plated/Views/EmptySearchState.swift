//
//  EmptySearchState.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct SearchEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("No recipes found")
                .font(.headline)
            Text("Try adjusting your search")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SearchEmptyState()
}
