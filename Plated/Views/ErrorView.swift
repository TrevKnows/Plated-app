//
//  ErrorView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text("Something went wrong")
                .font(.headline)
            Text(error.localizedDescription)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
