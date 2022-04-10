//
//  SignUpPost.swift
//  Radom
//
//  Created by YingQi Tao on 4/9/22.
//

import Foundation

extension Dictionary {
    func encodePercent() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

final class SignUpPost: ObservableObject {
    static let shared = SignUpPost()
    private init() {}
    
    private let serverUrl = "https://35.238.172.242/"

    
    func postuser(usern: String, pass: String) -> Bool {
        let semaphore = DispatchSemaphore (value: 0)
        let parameters: [String: Any] = [
            "username": usern,
            "password": pass
        ]
        var retx: Bool = false
        guard let apiUrl = URL(string: serverUrl+"postuser/") else {
            print("postuser: Bad URL")
            return false
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.httpBody = parameters.encodePercent()
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer { semaphore.signal() }
            
            guard let _ = data, error == nil else {
                print("postuser: NETWORKING ERROR")
                retx = false
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postuser: HTTP STATUS: \(httpStatus.statusCode)")
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
    
