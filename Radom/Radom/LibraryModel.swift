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
    static let shared = LibraryModels()
    @Published var all: [LibraryModel] = []
    @Published var models = [LibraryModel]()
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
        //print(filePath)
        //print("SPACE")
        fileUrl = URL(fileURLWithPath: filePath)
        //print(fileUrl)
        //print("S")
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        let tv_retro = LibraryModel(name: "tv_retro", scaleCompensation: 30/100, url: fileUrl)
        existingModels.insert("tv_retro")
        tv_retro.genThumbnail()
        modelCount += 1
        
        defaultModelsCount = modelCount
        self.all += [chair_swan, flower_tulip, horse, flower_bed, tv_retro]
        
        listAllFiles()
    }
    
    func get() -> [LibraryModel] {
        return all
    }
    
    func updateLibrary() {
        let docs = listAllFiles()
        for url in docs {
            print(url)
            if url.lastPathComponent != "Inbox"{
                let fullUrl = url.lastPathComponent
                let fullArr = fullUrl.components(separatedBy: ".")
                
                let name = fullUrl
                if !existingModels.contains(name) {
                    let model = LibraryModel(name: name, scaleCompensation: 0.32/100, url: url)
                    model.genThumbnail()
                    self.all.append(model)
                    print("Update library")
                    modelCount += 1
                }
            }
        }
        print(self.all.count)
    }
    private let serverUrl = "https://35.238.172.242/"

    func getModels(_ username: String) {
        //let sem = DispatchSemaphore.init(value: 0)
        guard let apiUrl = URL(string: serverUrl+"getmodels/?username="+username) else {
            print("getModel: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //defer { sem.signal() }
            
            guard let data = data, error == nil else {
                print("getModel: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getModel: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getModel: failed JSON deserialization")
                return
            }
            let modelsReceived = jsonObj["models"] as? [[String?]] ?? []
            DispatchQueue.main.async {
                self.models = [LibraryModel]()
                
                for modelEntry in modelsReceived {
                    print(modelEntry[2]!)
                    print(modelEntry[3]!)
                    let url = URL(string: (modelEntry[3])!)
                    print("OUCH")
                    print(url)
                    //FileDownloader.loadFileAsync(url: url!) { (path, error) in
                        //self.updateLibrary()
                        //print("Downloaded")
                    //}
                    /*
                    var temp = LibraryModel(name: (modelEntry[2])!,
                                            scaleCompensation: 30/100,
                                            url: URL(fileURLWithPath: (modelEntry[3])!))
                    temp.genThumbnail()
                    self.models.append(temp)
                    print(self.models.count)*/
                }
            }
        }.resume()
        //sem.wait()
    }
}

class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        //let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        var filePath = Bundle.main.path(forResource: "chair_swan", ofType: "usdz")!
        var fileUrl = URL(fileURLWithPath: filePath)
        let destinationUrl = fileUrl
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        print(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            print("LOOK!!")
            print(request)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
