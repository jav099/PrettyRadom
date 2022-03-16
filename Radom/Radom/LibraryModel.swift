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
    var scaleCompensation: Float  //KL: remove ?
    
    private var cancellable: AnyCancellable?
    
    @ObservedObject var thumbnailGenerator = ThumbnailGenerator()
    
    init(name: String, scaleCompensation: Float = 1.0) {
        self.name = name
        self.scaleCompensation = scaleCompensation
        //let thumbnailGenerator = ThumbnailGenerator()
        //thumbnailGenerator.generateThumbnail(for: name, size: CGSize(width: 150, height: 150))
        // TODO: handle for errors/no thumbnail made
    }
    
    func genThumbnail() {
        self.thumbnailGenerator.generateThumbnail(for: name, size: CGSize(width: 150, height: 150))
    }
    
    //TODO: probably create a method to generate the thumbnails and have the observed object uncommented
    
    //TODO: Create a method to async load modelEntity
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                switch loadCompletion{
                case .failure(let error): print("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: {modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded.")
                })
    }
}

struct LibraryModels {
    var all: [LibraryModel] = []

    
    init() {
        // TODO: will have to populate with models from back end
        let chair_swan = LibraryModel(name: "chair_swan", scaleCompensation: 0.32/100)
        chair_swan.genThumbnail()
        
        let flower_tulip = LibraryModel(name: "flower_tulip", scaleCompensation: 0.32/100)
        flower_tulip.genThumbnail()
        
        let horse = LibraryModel(name: "horse", scaleCompensation: 0.32/100)
        horse.genThumbnail()
        
        let flower_bed = LibraryModel(name: "flower_bed", scaleCompensation: 0.32/100)
        flower_bed.genThumbnail()
        
        let tv_retro = LibraryModel(name: "tv_retro", scaleCompensation: 0.32/100)
        tv_retro.genThumbnail()
        
        self.all += [chair_swan, flower_tulip, horse, flower_bed, tv_retro]
    }
    
    func get() -> [LibraryModel] {
        return all
    }
}
