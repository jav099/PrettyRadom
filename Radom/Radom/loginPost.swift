//
//  loginPost.swift
//  Radom
//
//  Created by Elena Tzalel on 4/9/22.
//

import Foundation

extension Dictionary {
    func ercentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

final class loginP: ObservableObject {
    static let shared = loginP()
    private init() {}
    
    private let serverUrl = "https://35.238.172.242/"

    
    func logn(usern: String, pass: String) -> Bool {
        let semaphore = DispatchSemaphore (value: 0)
        let parameters: [String: Any] = [
            "username": usern,
            "password": pass
        ]
        var retx: Bool = false
        guard let apiUrl = URL(string: serverUrl+"login/") else {
            print("getLogin: Bad URL")
            return false
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = parameters.ercentEncoded()
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { semaphore.signal() }
            
            guard let _ = data, error == nil else {
                print("login: NETWORKING ERROR")
                retx = false
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("login: HTTP STATUS: \(httpStatus.statusCode)")
                    retx = false
                    return
                } else {
                    retx = true
                }
            }
        }.resume()
        
        
        semaphore.wait()
        return retx
    }


    }
    

