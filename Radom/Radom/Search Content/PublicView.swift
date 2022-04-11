//
//  PublicView.swift
//  Radom
//
//  Created by Grace Liu on 4/11/22.
//

import SwiftUI


struct PublicView: View {
    @State var user : Users
    @ObservedObject var store = ProfileStore.shared
    //FIXME: user's publicity
    @State private var isPublic = false
    @State private var location = ""
    let testUsername = "emily"
    
    func loadData() {
        store.getProfile(user.username!)
        self.isPublic = store.profile.isPublic
        self.location = store.profile.location
//        if user.publicity == "false" {
//            self.isPublic = false
//        } else {
//            self.isPublic = true
//        }
//        self.location = user.location!
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if user.publicity!{
                VStack() {
                    HStack{
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    HStack {
                        Text(user.username!)
                            .padding()
                            .font(.system(size: 22, weight: .semibold)).lineLimit(2)
                    }
                    HStack {
                        Text(user.location!)
                            .padding(.bottom, 40)
                            .font(.system(size: 20)).lineLimit(2)
                    }
                    HStack {
                        PublicModelView(username: user.username!)
                    }
                    .padding()
                }
                .onAppear(perform: loadData)
            }
            else{
                HStack{
                    Image(systemName: "folder.badge.person.crop")
                    Text("Sorry, this user account is private, and no models will be displayed.")
                }
            }
        }
    }
}

struct PublicModelView: View {
    var username: String
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
                
                PublicItemButton(model: model) {
                    model.asyncLoadModelEntity()
                    self.placementSettings.selectedModel = model
                    print("BrowseView: select \(model.name) for placement")
                }
                // get search information
            }
        }
    }
    
    // KL: need to modify according to user
    var searchResults: [LibraryModel] {
        return modelFiles.all
    }
}


struct PublicItemButton: View {
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
