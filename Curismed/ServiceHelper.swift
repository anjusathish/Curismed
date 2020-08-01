//
//  ServiceHelper.swift
//  Clear Thinking
//
//  Created by Ragavi Rajendran on 13/09/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//


import Foundation

enum ContentType1 : String {
    case x_www_form_urlEncoded = "application/x-www-form-urlencoded"
    case json = "application/json"
    case form_data = "multipart/form-data"
}

enum StatusCode : Int {
    case success = 200
    case unAuthorized = 401
    case refreshTokenFailure = 400
}

class ServiceHelper : NSObject {
    
    static let instance = ServiceHelper()
    
    func requestFormData(withData data : Data, forRequest request : URLRequest, completion: @escaping (Result<Data, CustomError>) -> ()) {
        
      let _urlRequest = request
        
//        if let token =  UserManager.shared.token {
//            _urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        loadDataSession(forData: data, withURLRequest: _urlRequest, completionHandler: {
            data, response, error in
            self.processResponse(urlRequest: request, data: data, response: response, error: error, completion: completion)
        })
    }
    
    func request(forUrlRequest urlRequest : URLRequest, includeToken : Bool = true, completion: @escaping (Result<Data, CustomError>) -> ()) {
        
      let _urlRequest = urlRequest
        
//        if let token =  UserManager.shared.token, includeToken {
//            _urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        
        loadURLSession(withURLRequest: _urlRequest, completionHandler: {
            data, response, error in
            self.processResponse(urlRequest: urlRequest, data: data, response: response, error: error, completion: completion)
        })
    }
    
    private func loadURLSession(withURLRequest request : URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            completionHandler(data,response,error)
        }
        
        dataTask.resume()
    }
    
    private func loadDataSession(forData data : Data, withURLRequest request : URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            completionHandler(data,response,error)
        }).resume()
    }
    
    private func processResponse(urlRequest : URLRequest, data : Data?, response : URLResponse?, error : Error?, completion : @escaping (Result<Data, CustomError>) -> ()) {
        
        guard error == nil else {
            completion(.failure(.message(error!.localizedDescription)))
            if let errorDesc = error?.localizedDescription {
                print(errorDesc)
            }
            return
        }
        
        guard response != nil else {
            completion(.failure(.unKnown))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, let statusCode = StatusCode(rawValue: httpResponse.statusCode) else {
            completion(.failure(.unKnown))
            return
        }
        
        switch statusCode {
            
        case .success:
            
            guard let _data = data else {
                completion(.failure(.unKnown))
                return
            }
            
            completion(.success(_data))
                      
        case .refreshTokenFailure:
            
            guard let _data = data else {
                completion(.failure(.unKnown))
                return
            }
            
            do {
                if let dict = try JSONSerialization.jsonObject(with: _data, options: [.allowFragments]) as? [String : Any] {
                    
                    print(dict)
                    
                    if let errorMessage = dict["error_description"] as? String {
                        completion(.failure(.message(errorMessage)))
                    }
                    else {
                        completion(.failure(.unKnown))
                    }
                }
                else {
                    completion(.failure(.unKnown))
                }
            }
            catch (let error) {
                completion(.failure(.message(error.localizedDescription)))
            }
        case .unAuthorized: break
          
      }
    }
}

extension Data {
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
