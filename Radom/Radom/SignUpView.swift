//
//  SignUpView.swift
//  Radom
//
//  Created by YingQi Tao on 4/8/22.
//

import SwiftUI

struct SignUpView: View {
    @State var user = ""
    @State var password = ""
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 12){
                    Text("Create an account")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal,25)
            .padding(.top,30)
            VStack(alignment: .leading, spacing: 15){
                Text("Username")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("username", text:$user)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .foregroundColor(.black)
                
                Text("Password")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("password", text:$password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .foregroundColor(.black)
                    
            }
            .padding(.horizontal,25)
            .padding(.top,25)
            
            // change destination to log in!!
            NavigationLink(destination: TabMenuView()) {
                Text("Sign Up")
                .frame(minWidth: 0, maxWidth: 300)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .font(.title)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
