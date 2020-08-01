//
//  AppointmentServiceHelper.swift
//  Curismed
//
//  Created by PraveenKumar R on 05/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import Foundation

class AppointmentServiceHelper{
  
  class func request<T: Codable>(router: AppointmentServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
    
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
              
              
              }else {
              
              let responseObject = try! JSONDecoder().decode(T.self, from: data)
              completion(.success(responseObject))
              
             // completion(.failure(.unKnown))
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
  
  
  class func requestFormData<T: Codable>(router: AppointmentServiceManager, completion: @escaping (Result<T, CustomError>) -> ()) {
      
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
      
      guard let url = components.url else { return }
      
      print(url)
      
      var request = URLRequest(url: url)
      request.httpMethod = router.method
      
      let boundary = UUID().uuidString
      request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
      
      var data = Data()
      
      if let parameters = router.formDataParameters {
          
          for(key, value) in parameters {
              
              if let image = value as? UIImage, let imageData = image.jpegData(compressionQuality: 0.1) {
                  data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                  data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\("Image.jpg")\"\r\n".data(using: .utf8)!)
                  data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
                  data.append(imageData)
                  
              }
              else if let valueString = value as? String {
                  data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                  data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                  data.append(valueString.data(using: .utf8)!)
              }
              else if let valueInt = value as? Int {
                  data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                  data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                  data.append("\(valueInt)".data(using: .utf8)!)
              }
          }
      }
      
      data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
      
      ServiceHelper.instance.requestFormData(withData: data, forRequest: request, completion: { (result : Result<Data, CustomError>) in
          
          DispatchQueue.main.async {
              
              MBProgressHUD.hide(for: window!, animated: true)
              
              switch result {
              case .success(let data):
                  
                  do {
                      if let dict = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String : Any] {
                          
                          print(dict)
                          
                          if let status = dict["isSuccess"] as? Bool  {
                              if status == true
                              {
                                  let responseObject = try! JSONDecoder().decode(T.self, from: data)
                                  completion(.success(responseObject))
                              }else{
                                  if let message = dict["message"] as? String {
                                      completion(.failure(.message(message)))
                                  }
                              }
                          }
                          else if let message = dict["message"] as? String {
                              completion(.failure(.message(message)))
                          }
                          else {
                              completion(.failure(.unKnown))
                          }
                      }
                  } catch(let error) {
                      completion(.failure(.message(error.localizedDescription)))
                  }
                  
              case .failure(let message): completion(.failure(message))
              }
          }
      })
  }
  
  
}
