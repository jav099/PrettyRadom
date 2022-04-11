//
//  UserStore.swift
//  Radom
//
//  Created by Grace Liu on 4/11/22.
//

import Foundation

struct Users: Hashable {
    var username: String?
    var location: String?
    var publicity: Bool?
}

final class UserStore : ObservableObject {
    static let shared = UserStore()
    private init() {}
    
    @Published private(set) var users = [Users]()
    
    private let serverUrl = "https://35.238.172.242/"

    func getUsers() {
        guard let apiUrl = URL(string: serverUrl+"getusers/") else {
            print("getUsers: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //TEST
            guard let data = data, error == nil else {
                print("getUsers: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getUsers: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getUsers: failed JSON deserialization")
                return
            }
//            let usersReceived = jsonObj["users"] as? [[String?]] ?? []
            
            let userReceivedtest = jsonObj["users"] as? [[Any]] ?? []
            // access individual value in dictionary

            DispatchQueue.main.async {
//                self.users = [Users]()
//                for userEntry in usersReceived {
//                    self.users.append(Users(username: userEntry[0]!,
//                                            location: userEntry[1]!))
//                    print("getUsers successfully called.")
//                }
                self.users = [Users]()
                for userEntrytest in userReceivedtest {
                    self.users.append(Users(username: userEntrytest[0] as? String,
                                            location: userEntrytest[1] as? String,
                                            publicity: userEntrytest[2] as? Bool))
                    print("getUsers successfully called.")
                }
            }
        }.resume()
    }
}

