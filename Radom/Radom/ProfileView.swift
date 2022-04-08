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
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                HStack {
                    Text(username)
                        .padding()
                        .font(.system(size: 22, weight: .semibold)).lineLimit(2)
                }
                HStack {
                    Text(store.profile.location)
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
            }
            .onAppear {
                store.getProfile(username)
                self.isPublic = store.profile.isPublic
                print(self.isPublic)
                print(store.profile.isPublic)
                print(store.profile.username)
            }
            .onDisappear {
                if store.profile.isPublic != self.isPublic {
                    let newProfile = Profile(username: username, location: store.profile.location, isPublic: self.isPublic)
                    store.setPrivacy(newProfile)
                }
            }
        }
    }
}
