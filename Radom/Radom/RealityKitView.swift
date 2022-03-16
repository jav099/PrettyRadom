//
//  ARView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI
import RealityKit
import ARKit
import Introspect

struct RealityKitView: View {
    @State var uiTabarController: UITabBarController?
    @EnvironmentObject var placementSettings: PlacementSettings

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ARViewContainer()
                
                if self.placementSettings.selectedModel == nil {
                    //FIXME
                    MainView()
                } else {
                    PlacementView()
                }
        
            }
            .edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .top) {
                LibraryButton()
            }
        }
        .navigationBarTitle("Title", displayMode: .inline)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //empty for now
    }
}

struct LibraryButton: View {
    @State private var isShowingDetailView = false
    
    var body: some View {
        ZStack {
            
            HStack() {
                Color.black.opacity(0.25)
                
                NavigationLink(destination: MainView(), isActive: $isShowingDetailView) {
                    Button(action: {
                        print("LibraryButton pressed")
                        self.isShowingDetailView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
                .navigationBarHidden(true)
    
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)

        }
        .padding(.top, 45)
        .padding(.trailing, 20)

    }
}


struct RealityKitView_Previews: PreviewProvider {
    static var previews: some View {
        RealityKitView()
            .environmentObject(PlacementSettings())
    }
}
