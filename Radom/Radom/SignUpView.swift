//
//  SignUpView.swift
//  Radom
//
//  Created by YingQi Tao on 4/8/22.
//

import SwiftUI

struct SignUpView: View {
    @State var username = ""
    @State var password = ""
    @State var loggedIn = true
    
    @ObservedObject var signup = SignUpPost.shared
    @State var createAccountSuccess: Bool = false
    @State var createAccountFail: Bool = false
    
    func tryCreateAccount() {
        let x: Bool = signup.postuser(usern: username, pass: password)
        if x {
            createAccountSuccess = true
        } else {
            createAccountFail = true
        }
    }
    
    var body: some View {
        ZStack {
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
                    TextField("username", text:$username)
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
                Button(action: {tryCreateAccount()}) {
                    Text("Sign up")
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .font(.title)
                }
                if createAccountFail {
                    Text("Account already exist, please log in")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
            }
            .padding()
            if createAccountSuccess {
                TabMenuView(username: $username, loggedIn: $loggedIn)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

