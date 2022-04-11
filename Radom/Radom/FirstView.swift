//
//  FirstView.swift
//  Radom
//
//  Created by YingQi Tao on 4/6/22.
//

import SwiftUI
import Introspect

struct FirstView : View {
    @State var loggedIn = false
    @State var username = ""
    @State var showTab: Bool
    @State var uiTabarController: UITabBarController?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Radom!")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(Color.blue)
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Sign up")
                    .frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.title)
                }
                // change destination to login page!!
                NavigationLink(destination: LoginView()) {
                    Text("Log in")
                    .frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.title)
                }
                NavigationLink(destination: TabMenuView(username: $username, loggedIn: $loggedIn)) {
                    Text("Continue as Guest")
                    .frame(minWidth: 0, maxWidth: 300)
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)
                    .font(.title)
                }
                
          }
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .introspectTabBarController { (UITabBarController) in
            if !showTab {
                UITabBarController.tabBar.isHidden = true
            }
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView(loggedIn: false, username: "", showTab: true)    // testing
    }
}

