//
//  OnBoardingServiceHelper.swift
//  Bungkus
//
//  Created by Athiban Ragunathan on 12/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

enum CustomError : Error {
  case message(String)
  case unKnown
  case offline
}

class OnBoardingServiceHelper {
  
  class func request<T: Codable>(router: OnBoardingServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
    
    let window = UIApplication.shared.windows.first
    
    if !Reachability.isConnectedToNetwork() {
      completion(.failure(.offline))
      return
    }
    
    MBProgressHUD.showAdded(to: window!, animated: true)
    
    var components = URLComponents()
    components.scheme = router.scheme
    components.host = router.host
    components.path = router.path
    components.queryItems = router.parameters    
    
    guard let url = components.url else { return }
    
    print(url)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = router.method
    
    if let data = router.body {
      urlRequest.httpBody = data
    }
    
    urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
    
    
    for (key, value) in router.headerFields {
      urlRequest.addValue(value, forHTTPHeaderField: key)
    }
    
    
    ServiceHelper.instance.request(forUrlRequest: urlRequest, completion: { (result : Result<Data, CustomError>) in
      
      DispatchQueue.main.async {
        
        MBProgressHUD.hide(for: window!, animated: true)
        
        switch result {
        case .success(let data):
          
          do {
            if let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] {
              
              print(dict)
              
              var status : Bool = false
              
              if let _status = dict["status"] as? Bool {
                status = _status
                
              }else if let _statusString = dict["status"] as? String, _statusString.lowercased() == "success" {
                  status = true
              }
              
              if status {
                let responseObject = try! JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
              }
              else if let message = dict["message"] as? String {
                completion(.failure(.message(message)))
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
          
        case .failure(let message): completion(.failure(message))
        }
      }
    })
  }
}
