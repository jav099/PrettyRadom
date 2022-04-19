//
//  ProfileStore.swift
//  Radom
//
//  Created by Jane Chen on 4/7/22.
//

import Foundation

struct Profile {
    var username: String
    var location: String
    var isPublic: Bool
}

struct FormBodyKeyValue {
    var key: String
    var value: String
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

final class ProfileStore: ObservableObject {
    static let shared = ProfileStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    
    var profile = Profile(username: "", location: "", isPublic: false)
    var models = [[String?]]()

    private let serverUrl = "https://35.238.172.242/"

    func getProfile(_ username: String) {
        let sem = DispatchSemaphore.init(value: 0)
        guard let apiUrl = URL(string: serverUrl+"getprofile/?username="+username) else {
            print("getProfile: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { sem.signal() }
            
            guard let data = data, error == nil else {
                print("getProfile: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getProfile: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getProfile: failed JSON deserialization")
                return
            }
            
            if let profile = jsonObj["profile"] as? [Any] {
                // access individual value in dictionary
                self.profile.location = profile[0] as! String
                self.profile.isPublic = profile[1] as! Bool
                self.profile.username = username
            }
        }.resume()
        
        sem.wait()
    }
    
    func returnModels() -> [[String?]] {
        return self.models
    }
    
    func getUserModels(_ username: String) {
        let sem = DispatchSemaphore.init(value: 0)
        guard let apiUrl = URL(string: serverUrl+"getmodels/?username="+username) else {
            print("getProfile: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { sem.signal() }
            
            guard let data = data, error == nil else {
                print("getProfile: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getProfile: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getProfile: failed JSON deserialization")
                return
            }
            self.models = jsonObj["models"] as? [[String?]] ?? []
            print("IN GETUSERMODELS")
            print(self.models.count)
        }.resume()
        
        sem.wait()
    }
    
    func setPrivacy(_ privacy: Profile) {
        
        let sem = DispatchSemaphore.init(value: 0)
        
        let parameters: [String: Any] = [
            "username": privacy.username,
            "public": privacy.isPublic
        ]

        guard let apiUrl = URL(string: serverUrl+"setprivacy/") else {
            print("setPrivacy: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = parameters.percentEncoded()

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { sem.signal() }
            
            guard let _ = data, error == nil else {
                print("setPrivacy: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("setPrivacy: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    self.getProfile(privacy.username)
                }
            }
        }.resume()
        
        sem.wait()
    }
    
    func postModelFromSearch(username: String, description: String, price: String, modelname: String, fileString: String) {
        print(username)
        let semaphore = DispatchSemaphore (value: 0)
        let boundary = UUID().uuidString
        
        let parameters: [String: String] = [
                    "username": username,
                    "description": description,
                    "price": price,
                    "modelName": modelname,
                    "fileurl": fileString
                ]
        
        let url = URL(string: serverUrl + "postmodelfromsearch/")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let modeldata = try? Data(contentsOf: modelURL)
        let lineBreak = "\r\n"
        var data = Data()
        
        for (key, value) in parameters {
            data.append("--\(boundary + lineBreak)".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
            data.append("\(value + lineBreak)".data(using: .utf8)!)
        }
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = data
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            defer { semaphore.signal() }
            
            guard let _ = data, error == nil else {
                print("postmodelfromsearch: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    //print(modelName)
                    print("postmodelfromsearch: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    print("postmodelfromsearch: success")
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
}
