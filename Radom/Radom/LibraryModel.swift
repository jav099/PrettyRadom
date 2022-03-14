//
//  LibraryModel.swift
//  Radom
//
//  Created by Javier Contreras on 3/14/22.
//

import SwiftUI
import RealityKit
import Combine

class LibraryModel {
    var name: String
    var thumbnail: UIImage?
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    // @ObservedObject var thumbnailGenerator = ThumbnailGenerator()
    
    init(name: String, scaleCompensation: Float = 1.0) {
        self.name = name
        self.scaleCompensation = scaleCompensation
        let thumbnailGenerator = ThumbnailGenerator()
        thumbnailGenerator.generateThumbnail(for: name, size: CGSize(width: 150, height: 150))
        // TODO: handle for errors/no thumbnail made
    }
    
    //TODO: probably create a method to generate the thumbnails and have the observed object uncommented
    
    //TODO: Create a method to async load modelEntity
}

struct LibraryModels {
    var all: [LibraryModel] = []
    
    init() {
        // TODO: will have to populate with models from back end
        let chair_swan = LibraryModel(name: "chair_swan", scaleCompensation: 0.32/100)
        
        let flower_tulip = LibraryModel(name: "flower_tulip", scaleCompensation: 0.32/100)
        
        let horse = LibraryModel(name: "horse", scaleCompensation: 0.32/100)
        
        let flower_bed = LibraryModel(name: "flower_bed", scaleCompensation: 0.32/100)
        
        let tv_retro = LibraryModel(name: "chair_swan", scaleCompensation: 0.32/100)
        
        self.all += [chair_swan, flower_tulip, horse, flower_bed, tv_retro]
    }
    
    func get() -> [LibraryModel] {
        return all
    }
}
