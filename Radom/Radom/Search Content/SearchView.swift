//
//  SearchView.swift
//  Radom
//
//  Created by Grace Liu on 4/11/22.
//

import SwiftUI

struct SearchView: View {
    @Binding var username: String
    @ObservedObject var store = UserStore.shared
    //Searchbar
    @State private var searchText = ""
    //var names: [String] = []
    
    var body: some View {
        NavigationView {
            List{
                ForEach(searchResults, id: \.self){ usera in
                    ListUserRow(users:usera, profileName: username)
                }
            }
            .searchable(text: $searchText, prompt:"Search for user ...")
            .refreshable {
                store.getUsers()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Text("Search Users")
                }
            }
            .onAppear {
                store.getUsers()
            }
        }
    }
    var searchResults: [Users] {
        if searchText.isEmpty {
            print("Search Text is Empty!")
            return store.users
        } else {
            print("You entered in search Text")
            return store.users.filter({$0.username!.contains(searchText)})
        }
    }
}


