//
//  TabView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI


struct TabMenuView: View {

    var body: some View {
        NavigationView {
            TabView {
                MainView()
                    .tabItem {
                        Label("Library", systemImage: "square.grid.2x2")
                    }

                RealityKitView()
                    .tabItem {
                        Label("AR", systemImage: "camera")
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView()
    }
}
