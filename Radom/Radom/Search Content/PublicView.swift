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
        store.getUserModels(user.username!)
        //print("LOADED USER MODELS")
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
                .onAppear {
                    loadData()
                }
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
    //Is this the users username? There is not @State or @Binding
    var username: String
    @ObservedObject var store = ProfileStore.shared
    let columns = [GridItem(.fixed(150)),
                   GridItem(.fixed(150))]
     
    //let models = LibraryModels().get()
    @ObservedObject var modelFiles = LibraryModels()
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        LazyVGrid(columns: columns,
                  spacing: 30) {
            ForEach(searchResults, id: \.self) { model in
                //let model = modelFiles.all[index]
                
                PublicItemButton(model: model, user: username) {
                    //model.asyncLoadModelEntity()
                    //self.placementSettings.selectedModel = model
                    print("BrowseView: select"+model[0]!+" for placement")
                    //Need to add model to user
                }
                // get search information
            }
        }
    }
    
    // KL: need to modify according to user
    var searchResults: [[String?]] {
        /*var userModels = modelFiles.getModels(username: username)
        userModels.append(contentsOf: modelFiles.all)
        return userModels*/
        //print("CHECKING STORE MODELS")
        store.getUserModels(username)
        //print(store.models.count)
        return store.returnModels()
    }
}


struct PublicItemButton: View {
    let model: [String?]
    let user: String
    let action: () -> Void
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button(action:{
            print("Button hit for "+model[0]!)
            //https://35.238.172.242/media/teapotIKEA.usdz
            
            let url = URL(string: (model[3])!)
            FileDownloader.loadFileAsync(url: url!) { (path, error) in
                print("added "+(model[2]!))
            }
            print("Saved "+(model[2]!)+"from "+user)
                //self.updateLibrary()
        }) {
            //let defaultThumbnail = UIImage(systemName: "questionmark")
            //Image(uiImage: self.model.thumbnailGenerator.thumbnailImage!)
            VStack {
                Text(model[0]!)
                    .padding()
                    .foregroundColor(.white)
                    .font(.title)
                Text(model[1]!)
                    .padding()
                    .foregroundColor(.white)
                    .font(.body)
            }
        }
    }
}
