//
//  ModelStore.swift
//  Radom
//
//  Created by Jane Chen on 4/9/22.
//

import Foundation

struct Model {
    var name: String
    var fileUrl: String
    var price: String
    var description: String
}

final class ModelStore: ObservableObject {
    static let shared = ModelStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    
    var model = [Model]()

    private let serverUrl = "https://35.238.172.242/"

    func getModels(_ username: String) {
        let sem = DispatchSemaphore.init(value: 0)
        guard let apiUrl = URL(string: serverUrl+"getmodels/?username="+username) else {
            print("getModel: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { sem.signal() }
            
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
            self.model = [Model]()
            
            for modelEntry in modelsReceived {
                self.model.append(Model(name: modelEntry[2]!,
                                        fileUrl: modelEntry[3]!,
                                        price: modelEntry[1]!,
                                        description: modelEntry[0]!))
            }
        }.resume()
        
        sem.wait()
    }
}
