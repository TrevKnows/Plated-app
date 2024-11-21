//
//  LinkButtonView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct LinkButtonView: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 32))
            .foregroundColor(color)
    }
}

#Preview {
    LinkButtonView(icon: "fork.knife", color: .orange)
}
