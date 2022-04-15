//
//  ContentView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI

struct MainView: View {
    @Binding var username: String
    @Binding var loggedIn: Bool

    let colors: [Color] = [.red, .green, .blue, .yellow, .purple]
    //Searchbar
    @State private var searchText = ""
    
    @ViewBuilder
    func ColorView() -> some View {
        (colors.randomElement() ?? .gray)
            .cornerRadius(10)
            .frame(minHeight: 40)
    }
    
    let columns = [GridItem(.fixed(150)),
                   GridItem(.fixed(150))]
     
    //let models = LibraryModels().get()
    @ObservedObject var modelFiles = LibraryModels()
    @ObservedObject var importModel = ImportModelPost.shared
    @EnvironmentObject var placementSettings: PlacementSettings
    
    @State var openFile = false
    @State var fileName = ""
    @State var files = [URL]()
    

    
    var body: some View {
        NavigationView{
            ScrollView(.vertical) {
                VStack(spacing: 40) {
                    Button(action: {openFile.toggle()}, label: {
                        Text("Import File")
                    })

                }
                .fileImporter(isPresented: $openFile, allowedContentTypes: [.usdz]) { (res) in
                    do {
                        let fileUrl = try res.get()
                        var fileToPost = try? Data(contentsOf: modelFiles.get().last!.url)
                        
                        print(fileUrl)
                        
                        // getting filename:
                        self.fileName = fileUrl.lastPathComponent
                        files.append(saveFile(url: fileUrl))
                        modelFiles.updateLibrary()
                        importModel.postmodel(username: username, description: "place holder description", price: "place holder price", modelName: self.fileName, model: fileToPost!.base64EncodedString())
                    } catch {
                        print("error reading file")
                        print(error.localizedDescription)
                    }
                }
                
                LazyVGrid(columns: columns,
                          spacing: 30) {
                    ForEach(searchResults, id: \.name) { model in
                        //let model = modelFiles.all[index]
                        
                        ItemButton(model: model) {
                            model.asyncLoadModelEntity()
                            self.placementSettings.selectedModel = model
                            print("BrowseView: select \(model.name) for placement")
                        }
                        // get search information
                    }
                }
                .searchable(text: $searchText)
            }
            .padding()
        }
        .navigationBarHidden(true)

    }
    
    var searchResults: [LibraryModel] {
//        var namelist: [String] = []
//        modelFiles.all.forEach {model in
//            namelist.append(model.name)
//        }
        if searchText.isEmpty {
            return modelFiles.all
        } else {
            return modelFiles.all.filter({$0.name.contains(searchText)})
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
 */

func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}


func saveFile (url: URL) -> URL{
    if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) { // <- here
        
        let fileData = try? Data.init(contentsOf: url)
        let fileName = url.lastPathComponent
        
        let actualPath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try fileData?.write(to: actualPath)
            if(fileData == nil){
                print("Permission error!")
            }
            else {
                print("Success.")
            }
        } catch {
            print(error.localizedDescription)
        }
        CFURLStopAccessingSecurityScopedResource(url as CFURL) // <- and here
        return actualPath
    }
    else {
        print("Permission error!")
        return getDocumentsDirectory().appendingPathComponent(url.lastPathComponent)
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
            VStack {
                Image(uiImage: model.thumbnail!)
                    .resizable()
                    .frame(height:150)
                    .aspectRatio(1/1, contentMode: .fit)
                    .background(Color(UIColor.secondarySystemFill))
                    .cornerRadius(8.0)
                Text(model.name)
                    .foregroundColor(.black)
                    .font(.body)
            }
        
        }
    }
}
