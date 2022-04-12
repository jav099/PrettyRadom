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
    var url: URL
    
    private var cancellable: AnyCancellable?
    
    //@ObservedObject var thumbnailGenerator = ThumbnailGenerator()
    var ARQLthumbnailGenerator = ARQLThumbnailGenerator()
    
    init(name: String, scaleCompensation: Float = 1.0, url: URL) {
        self.name = name
        self.scaleCompensation = scaleCompensation
        self.url = url
        //let thumbnailGenerator = ThumbnailGenerator()
        //thumbnailGenerator.generateThumbnail(for: name, size: CGSize(width: 150, height: 150))
        // TODO: handle for errors/no thumbnail made
    }
    
    func genThumbnail() {
        self.thumbnail = self.ARQLthumbnailGenerator.thumbnail(for: self.url, size: CGSize(width: 150, height: 150))
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

func listAllFiles() -> [URL]{
    let documentsUrl = getDocumentsDirectory()

    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
        print(directoryContents)
        return directoryContents
    } catch {
        print(error)
        print("Error listing all the documents")
        // this is just so it builds
        return [URL(string: "NIL")!]
    }
}


class LibraryModels: ObservableObject {
    @Published var all: [LibraryModel] = []
    var existingModels: Set = ["Inbox"]
    var modelCount = 0
    var defaultModelsCount: Int
    
    init() {
        
        //updateLibrary()
        
        // TODO: will have to populate with models from back end
        
        var filePath = Bundle.main.path(forResource: "chair_swan", ofType: "usdz")!
        var fileUrl = URL(fileURLWithPath: filePath)
        let chair_swan = LibraryModel(name: "chair_swan", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("chair_swan")
        chair_swan.genThumbnail()
        modelCount += 1
        
        filePath = Bundle.main.path(forResource: "flower_tulip", ofType: "usdz")!
        fileUrl = URL(fileURLWithPath: filePath)
        let flower_tulip = LibraryModel(name: "flower_tulip", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("flower_tulip")
        flower_tulip.genThumbnail()
        modelCount += 1
        
        filePath = Bundle.main.path(forResource: "horse", ofType: "usdz")!
        fileUrl = URL(fileURLWithPath: filePath)
        let horse = LibraryModel(name: "horse", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("horse")
        horse.genThumbnail()
        modelCount += 1
        
        filePath = Bundle.main.path(forResource: "flower_bed", ofType: "usdz")!
        fileUrl = URL(fileURLWithPath: filePath)
        let flower_bed = LibraryModel(name: "flower_bed", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("flower_bed")
        flower_bed.genThumbnail()
        modelCount += 1
        
        filePath = Bundle.main.path(forResource: "tv_retro", ofType: "usdz")!
        fileUrl = URL(fileURLWithPath: filePath)
        let tv_retro = LibraryModel(name: "tv_retro", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("tv_retro")
        tv_retro.genThumbnail()
        modelCount += 1
        
        defaultModelsCount = modelCount
        self.all += [chair_swan, flower_tulip, horse, flower_bed, tv_retro]
        
    }
    
    func get() -> [LibraryModel] {
        return all
    }
    
    func updateLibrary() {
        let docs = listAllFiles()
        for url in docs {
            if url.lastPathComponent != "Inbox"{
                let fullUrl = url.lastPathComponent
                let fullArr = fullUrl.components(separatedBy: ".")
                
                let name = fullArr[0]
                if !existingModels.contains(name) {
                    let model = LibraryModel(name: name, scaleCompensation: 0.32/100, url: url)
                    model.genThumbnail()
                    self.all.append(model)
                    print(self.all)
                    modelCount += 1
                }
            }
        }
    }
    
    func getModels(username: String) -> [LibraryModel]{
        var returnVal = [LibraryModel]()
        let serverUrl = "https://35.238.172.242/"
        guard let apiUrl = URL(string: serverUrl+"getmodels/?username="+username) else {
            print("getModels: Bad URL")
            return returnVal
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        //var userModels = [LibraryModel]()
        let group = DispatchGroup()
        group.enter()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //TEST
            guard let data = data, error == nil else {
                print("getModels: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getModels: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getModels: failed JSON deserialization")
                return
            }
//            let usersReceived = jsonObj["users"] as? [[String?]] ?? []
            //print("Successfully loaded")
            let userModelsServer = jsonObj["models"] as? [[Any]] ?? []
            // access individual value in dictionary
            DispatchQueue.main.async {
//                self.users = [Users]()
//                for userEntry in usersReceived {
//                    self.users.append(Users(username: userEntry[0]!,
//                                            location: userEntry[1]!))
//                    print("getUsers successfully called.")
//                }
                
                for userModel in userModelsServer {
                    print(userModel[2])
                    print(userModel[3])
                    returnVal.append(LibraryModel(name: (userModel[2] as? String)!,
                                                   scaleCompensation: 30/100,
                                                   url: URL(fileURLWithPath: (userModel[3] as? String)!)))
                }
            }
            group.leave()
        }.resume()
        group.wait()
        return returnVal
    }
}
