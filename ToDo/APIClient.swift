//
//  APIClient.swift
//  ToDo
//
//  Created by Cesar Paiva on 23/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import Foundation

protocol ToDoURLSession {
    func dataTaskWithURL(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

enum WebServiceError: Error {
    case DataEmptyError
    case ResponseError
}

class APIClient {
    
    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?
    
    func loginUserWithName(_ username: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let allowedCharacters = NSCharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        guard let url = URL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else { fatalError() }
        let task = session.dataTaskWithURL(url: url) { (data, response, error) in
            if error != nil {
                completion(WebServiceError.ResponseError)
                return
            }
            
            guard let data = data else { completion(WebServiceError.DataEmptyError); return }
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : String]
                if let token = responseDict?["token"] {
                    self.keychainManager?.setPassword(token, account: "token")
                }
            } catch {
                completion(error)
            }
        }
        task.resume()
    }
}

extension URLSession: ToDoURLSession {
    func dataTaskWithURL(url: URL, completionHandler: (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTask()
    }
}


