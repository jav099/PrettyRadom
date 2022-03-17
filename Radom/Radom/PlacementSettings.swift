//
//  PlacementSettings.swift
//  Radom
//
//  Created by Grace Liu on 3/15/22.
//
import SwiftUI
import RealityKit
import Combine
class PlacementSettings: ObservableObject{
    
    // When the user selects a model in library, this property is set
    @Published var selectedModel : LibraryModel?{
        willSet(newValue){
            print ("Setting selectedModel to \(String(describing:newValue?.name))")
        }
    }
    
    // When the user taps comfirm in PlacementView, the value of selectedModel is assigned to confirmedModel
    @Published var confirmedModel : LibraryModel? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmed to \(model.name)")
        }
    }
    
    // This property retains the cancellable object for SceneEvents.Update subscriber
    var sceneObserver: Cancellable?
}
