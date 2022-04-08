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

final class ProfileStore: ObservableObject {
    static let shared = ProfileStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    
    var profile = Profile(username: "", location: "", isPublic: false)

    private let serverUrl = "https://35.238.172.242/"

    func getProfile(_ username: String) {
        guard let apiUrl = URL(string: serverUrl+"getprofile/") else {
            print("getProfile: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
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
            
            let profilesReceived = jsonObj["profile"] as? [Profile] ?? []
            DispatchQueue.main.async {
                for profile in profilesReceived {
                    self.profile.location = profile.location
                    self.profile.isPublic = profile.isPublic
                }
            }
        }.resume()
    }
    
    func setPrivacy(_ privacy: Profile) {
        let jsonObj = ["username": privacy.username,
                       "public": privacy.isPublic] as [String : Any]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("setPrivacy: jsonData serialization error")
            return
        }

        guard let apiUrl = URL(string: serverUrl+"setprivacy/") else {
            print("setPrivacy: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
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
    }
}
