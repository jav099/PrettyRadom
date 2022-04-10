//
//  ProfileView.swift
//  Radom
//
//  Created by Jane Chen on 4/7/22.
//

import SwiftUI

struct ProfileView: View {
    @Binding var loggedIn: Bool
    @Binding var username: String
    
    var body: some View {
        if loggedIn {
            ProfileLoggedInView(username: $username)
        } else {
            FirstView(loggedIn: self.loggedIn, username: self.username)
        }
    }
    
}

struct ProfileLoggedInView: View {
    @Binding var username: String
    @ObservedObject var store = ProfileStore.shared
    @State private var isPublic = false
    @State private var location = ""
    let testUsername = "emily"
    
    func loadData() {
        store.getProfile(username)
        self.isPublic = store.profile.isPublic
        self.location = store.profile.location
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                HStack {
                    Text(username)
                        .padding()
                        .font(.system(size: 22, weight: .semibold)).lineLimit(2)
                }
                HStack {
                    Text(location)
                        .padding(.bottom, 40)
                        .font(.system(size: 20)).lineLimit(2)
                }
                VStack() {
                    Text("Public").font(.system(size: 18, weight: .semibold)).lineLimit(2) // <2>
                    HStack { // <3>
                        if self.isPublic { // <4>
                            Text("On").font(.system(size: 16))
                        } else {
                            Text("Off").font(.system(size: 16))
                        }
                        Spacer()
                        Toggle("", isOn: $isPublic) // <5>
                    }
                }
                .frame(width: 100) // <6>
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(self.isPublic ? Color.green: Color.gray, lineWidth: 2) // <7>
                )
                Spacer()
                HStack {
                    ModelView(username: $username)
                }
                .padding()
            }
            .onAppear(perform: loadData)
            .onDisappear {
                let newProfile = Profile(username: username, location: store.profile.location, isPublic: self.isPublic)
                store.setPrivacy(newProfile)
            }
        }
    }
}

struct ModelView: View {
    @Binding var username: String
    @ObservedObject var store = ModelStore.shared
    let columns = [GridItem(.fixed(150)),
                   GridItem(.fixed(150))]
     
    //let models = LibraryModels().get()
    @ObservedObject var modelFiles = LibraryModels()
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
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
    }
    
    var searchResults: [LibraryModel] {
//        var namelist: [String] = []
//        modelFiles.all.forEach {model in
//            namelist.append(model.name)
//        }
        return modelFiles.all
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
    
//    var searchResults: [LibraryModel] {
//        var all: [LibraryModel] = []
//        store.getModels(username)
//
//        for model in store.model {
//            let newModel = LibraryModel(name: model.name, scaleCompensation: 30/100, url: model.fileUrl)
//            newModel.genThumbnail()
//            all += [newModel]
//        }
//
//        return all
//    }
}


