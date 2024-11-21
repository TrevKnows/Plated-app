//
//  EmptyStateView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/20/24.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let image: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(title: "Test", message: "Testing!", image: "exclamationmark.triangle")
}
