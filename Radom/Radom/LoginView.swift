//
//  LoginView.swift
//  Radom
//
//  Created by Elena Tzalel on 4/9/22.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView : View {
    @State var username: String = ""
    @State var password: String = ""
    
    @State var authenticationFailed: Bool = false
    @State var authenticationSucceeded: Bool = false
    @State var loggedIn = true
    
    @ObservedObject var log = loginP.shared
    
    func loadLogin() {
        let x: Bool = log.logn(usern: username, pass: password)
        if x == true {
            authenticationSucceeded = true
            authenticationFailed = false
        }
        else {
            authenticationFailed = true
            authenticationSucceeded = false
        }
    }
    
    
    var body: some View {
        
        ZStack {
        
            VStack {
                WelcomeText()
                UserImage()
                UsernameTextField(username: $username)
                PasswordSecureField(password: $password)
                
                Button(action: {loadLogin()}) {
                    Text("LOGIN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
                if authenticationFailed {
                    InfoIncorrect()
                }
            
            }
                .padding()
            if authenticationSucceeded {
                loginSucceeded()
                TabMenuView(username: $username, loggedIn: $loggedIn)
            }
            }
    }
}

struct LoginView_Previews : PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct WelcomeText : View {
    var body: some View {
        return Text("Sign in")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage : View {
    var body: some View {
        return Image("profileIcon")
            .resizable()
            .aspectRatio(UIImage(named: "profileIcon")!.size, contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct UsernameTextField: View {
    @Binding var username: String
    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .foregroundColor(.black)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            .foregroundColor(.black)
    }
}

struct InfoIncorrect: View {
    var body: some View {
        Text("Information not correct. Try again.")
            .offset(y: -10)
            .foregroundColor(.red)
    }
}

struct loginSucceeded: View {
    var body: some View {
        Text("Login Succeeded!")
            .font(.headline)
            .frame(width: 250, height: 80)
            .background(Color.green)
            .cornerRadius(20.0)
            .foregroundColor(.white)
            .animation(Animation.default)
    }
}
