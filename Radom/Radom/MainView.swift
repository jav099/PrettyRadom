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
                    let model = models[index]
                    
                    ItemButton(model: model) {
                        //TODO: call model metthod to asynch load modelEntity
                        //TODO: select model for placement
                        print("BrowseView: select \(model.name) for placement")
                    }
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

struct ItemButton: View {
    let model: LibraryModel
    let action: () -> Void
    
    var body: some View {
        Button(action:{
            self.action()
        }) {
            //let defaultThumbnail = UIImage(systemName: "questionmark")
            //Image(uiImage: self.model.thumbnailGenerator.thumbnailImage!)
            Image(uiImage: UIImage(systemName: "questionmark.folder")!)
                .resizable()
                .frame(height:150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8.0)
        
        }
    }
}
