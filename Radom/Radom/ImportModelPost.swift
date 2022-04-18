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

    
//    func postmodel(username: String, description: String, price: String, modelName: String, model: String) {
//        let semaphore = DispatchSemaphore (value: 0)
//
//        let parameters: [String: Any] = [
//            "username": username,
//            "description": description,
//            "price": price,
//            "modelName": modelName,
//            "model": model
//        ]
//        guard let apiUrl = URL(string: serverUrl+"postmodel/") else {
//            print("postmodel: Bad URL")
//            return
//        }
//        var request = URLRequest(url: apiUrl)
//        request.httpMethod = "POST"
//        request.httpBody = parameters.encodePercent()
//        URLSession.shared.dataTask(with: request) { data, response, error in
//
//            defer { semaphore.signal() }
//
//            guard let _ = data, error == nil else {
//                print("postmodel: NETWORKING ERROR")
//                return
//            }
//            print(String(data: data!, encoding: .utf8)!)
//            if let httpStatus = response as? HTTPURLResponse {
//                if httpStatus.statusCode != 200 {
//                    print("postmodel: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                } else {
//                    print("postmodel: success")
//                }
//            }
//        }.resume()
//
//        semaphore.wait()
//    }
    
    func postModel( username: String, description: String, price: String, modelName: String, modelURL: URL) {
        let semaphore = DispatchSemaphore (value: 0)
        let url = URL(string: serverUrl + "postmodel/")
        let paramName = "model"
        let actualName = modelName.replacingOccurrences(of: ".usdz", with: "")

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        
        let parameters: [String: String] = [
            "username": username,
            "description": description,
            "price": price,
            "modelName": actualName
        ]

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let modeldata = try? Data(contentsOf: modelURL)
        let lineBreak = "\r\n"
        var data = Data()
        
        for (key, value) in parameters {
            data.append("--\(boundary + lineBreak)".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
            data.append("\(value + lineBreak)".data(using: .utf8)!)
        }
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(actualName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: model/vnd.usdz+zip\r\n\r\n".data(using: .utf8)!)
        data.append(modeldata!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
//        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
//            defer { semaphore.signal() }
//
//            guard let _ = responseData, error == nil else {
//                print("postmodel: NETWORKING ERROR")
//                return
//            }
//            if let httpStatus = response as? HTTPURLResponse {
//                if httpStatus.statusCode != 200 {
//                    print("postmodel: HTTP STATUS: \(httpStatus.statusCode)")
//                    return
//                } else {
//                    print("postmodel: success")
//                }
//            }
//
//            if error == nil {
//                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
//                if let json = jsonData as? [String: Any] {
//                    print(json)
//                }
//            }
        //        }).resume()
        urlRequest.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            defer { semaphore.signal() }
            
            guard let _ = data, error == nil else {
                print("postmodel: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print(modelName)
                    print("postmodel: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    print("postmodel: success")
                }
            }
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
        semaphore.wait()
    }
    
    
    private func textFormField(named name: String, value: String, boundary: UUID) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }
}
