//
//  ListUserRow.swift
//  Radom
//
//  Created by Grace Liu on 4/11/22.
//

import SwiftUI

struct ListUserRow: View {
    var users: Users
    //@Binding var profileName: String
    var profileName: String
    
    var body: some View {
        NavigationLink(destination: PublicView(user:users, profileName: profileName)){
            VStack(alignment: .leading) {
                HStack {
                    if let username = users.username, let location = users.location {
                        Text(username).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14, weight:
                                                                                                                            .semibold))
                        Spacer()
                        Text(location).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14))
                    }
                }
            }
        }
            //add privacy
//            if(users.publicity == "true"){
//                PublicView(user: users)
//            }
//            else{
//                // when?
//                print("Sorry, this user is private, you can't see their models.")
//            }

    }
}

