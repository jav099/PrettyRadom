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
    var body: some View {
        ARViewContainer()
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
    }
}
