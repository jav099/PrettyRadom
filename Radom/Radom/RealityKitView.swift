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
                
                if self.placementSettings.selectedModel != nil {
                    PlacementView()
                } else {
                
                    HStack {
                       LibraryButton()
                       Spacer()
                       ExitButton()
                   }
                    
                }
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarTitle("Title", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
}
struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        // Subscribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
            
            // Call updateScene method
            self.updateScene(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        //empty for now
    }
    
    private func updateScene(for arView: CustomARView){
        // Only display focusEntity when the user has selected a model for placement
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        // Add model to scene if confirmed for placement
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity{
            
            // Call place method
            self.place(modelEntity, in: arView)
            self.placementSettings.confirmedModel = nil
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView){
        // 1. Clone modelEntity. This creates an identical copy of modelEntity and references the same model. This also allows us to have multiple models of the same asset in our scene.
        let clonedEntity = modelEntity.clone(recursive: true)
        
        // 2. Enable translation and rotation gestures.
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        // 3. Create an anchorEntity and add clonedEntity to the anchorEntity
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        // 4. Add the anchorEntity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
        print("Added modelEntity to scene.")
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
    
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding()
    }
}
struct ExitButton: View {
    @State private var isShowingDetailView = false
    
    var body: some View {
        ZStack {
            
            HStack() {
                Color.black.opacity(0.25)
                
                NavigationLink(destination: TabMenuView(), isActive: $isShowingDetailView) {
                    Button(action: {
                        print("ExitButton pressed")
                        self.isShowingDetailView = true
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
    
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding()
    }
}
struct RealityKitView_Previews: PreviewProvider {
    static var previews: some View {
        RealityKitView()
            .environmentObject(PlacementSettings())
    }
}
