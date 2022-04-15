//
//  ImportModelPost.swift
//  Radom
//
//  Created by YingQi Tao on 4/15/22.
//

import Foundation


final class ImportModelPost: ObservableObject {
    static let shared = ImportModelPost()
    private init() {}
    
    private let serverUrl = "https://35.238.172.242/"

    
    func postmodel(username: String, description: String, price: String, modelName: String, model: String) {
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters: [String: Any] = [
            "username": username,
            "description": description,
            "price": price,
            "modelName": modelName,
            "model": model
        ]
        guard let apiUrl = URL(string: serverUrl+"postmodel/") else {
            print("postmodel: Bad URL")
            return
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = parameters.encodePercent()
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { semaphore.signal() }
            
            guard let _ = data, error == nil else {
                print("postmodel: NETWORKING ERROR")
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postmodel: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    print("postmodel: success")
                }
            }
        }.resume()
        
        semaphore.wait()
    }
}
