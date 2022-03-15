//
//  ARView.swift
//  Radom
//
//  Created by Javier Contreras on 3/12/22.
//

import SwiftUI
import RealityKit

struct ARView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //empty for now
    }
}


struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARView()
    }
}
