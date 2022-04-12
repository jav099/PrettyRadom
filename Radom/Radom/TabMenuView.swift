//
//  TabView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI


struct TabMenuView: View {
    @Binding var username: String
    @Binding var loggedIn: Bool

    var body: some View {
        NavigationView {
            TabView {
                MainView(username: $username)
                    .tabItem {
                        Label("Library", systemImage: "square.grid.2x2")
                    }

                RealityKitView(username: $username, loggedIn: $loggedIn)
                    .tabItem {
                        Label("AR", systemImage: "camera")
                    }

                ProfileView(loggedIn: $loggedIn, username: $username)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                SearchView()
                    .tabItem{
                        Image(systemName: "person.2.square.stack")
                        Text("Search Users")
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabMenuView()   // testing with ikea
//    }
//}
