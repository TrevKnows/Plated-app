//
//  EmptyStateView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/20/24.
//

import SwiftUI

struct EmptyStateView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Recipes Available")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text( "We couldn't find any recipes matching your search.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView()
}
