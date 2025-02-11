//
//  ContentView.swift
//  SmartPantry
//
//  Created by Christelle Maaß on 10.02.25.
//

import SwiftUI

struct ContentView: View {
    
    var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red]
    
    @State private var circleColor: Color = .blue
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(circleColor)
                    .padding()
                VStack{
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
            }
            Button("Change color") { circleColor = colors.randomElement() ?? .blue
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
