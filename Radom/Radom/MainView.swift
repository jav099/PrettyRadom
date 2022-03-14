//
//  ContentView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI

struct MainView: View {
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple]
    
    @ViewBuilder
    func ColorView() -> some View {
        (colors.randomElement() ?? .gray)
            .cornerRadius(10)
            .frame(minHeight: 40)
    }
    
    let columns = [GridItem(.fixed(150)),
                   GridItem(.fixed(150))]
     
    let models = LibraryModels().get()
    
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns,
                      spacing: 30) {
                ForEach(0..<models.count) { index in
                    Color(UIColor.secondarySystemFill)
                        .frame(width: 150, height: 150)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
