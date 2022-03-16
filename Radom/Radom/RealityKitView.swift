//
//  ARView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI
import RealityKit
import ARKit

struct RealityKitView: View {
    @EnvironmentObject var placementSettings: PlacementSettings

    var body: some View {
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


struct RealityKitView_Previews: PreviewProvider {
    static var previews: some View {
        RealityKitView()
            .environmentObject(PlacementSettings())
    }
}
