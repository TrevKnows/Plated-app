//
//  MainHeader.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct MainHeaderView: View {
    var body: some View {
        
        HStack {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 32))
                
            Text("Plated")
                .bold()
                .font(.largeTitle)
            Spacer()
        }
        .padding()
        .foregroundStyle(.orange)
    }
}

#Preview {
    MainHeaderView()
}
