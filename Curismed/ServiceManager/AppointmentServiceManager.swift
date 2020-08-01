//
//  AppointmentServiceManager.swift
//  Curismed
//
//  Created by PraveenKumar R on 05/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import Foundation

enum AppointmentServiceManager {
  case addNewSession(_ info: AddNewSessionRequest)
  case appointmentList(_ info: AppointmentsListRequest)
  case clientNameList(_info: ClientListRequest)
  case addregister(_ info: AddRegisterRequest)
  case nonBillableClientName(_ info: ClientListRequest)
  case updateSession(_ info: AppointmentUpdateRequest)
  case updateClockSession(_ info: AppointmentUpdateClockRequest)
  case getCurrectLatLong(_ info: AppointmentMobileMapAddRequest)

  var scheme: String {
    switch self {
    case .appointmentList,.getCurrectLatLong(_): return API.scheme
    case .clientNameList: return API.scheme
      
    case .addNewSession: return API.scheme
      
    case .addregister(_): return API.scheme
      
      
    case .nonBillableClientName(_): return API.scheme
      
    case .updateSession(_):
      return API.scheme
    case .updateClockSession(_):
        return API.scheme
    }
  }
  
  var host: String {
    switch self {
    case .appointmentList,.addNewSession,.getCurrectLatLong(_): return API.baseURL
    case .clientNameList,.nonBillableClientName: return API.baseURL
      
    case .addregister(_):return API.baseURL
      
      
    case .updateSession(_):
      return API.baseURL
    case .updateClockSession(_):
              return API.baseURL
    }
  }
  
  var path: String {
    switch self {
    case .appointmentList: return "/appointments/mob_gets"
    case .clientNameList: return "/patient/mob_list5"
    case .addNewSession: return "/appointments/recurrence"
    case .addregister(_): return ""
    case .nonBillableClientName: return "/appointment/mob_checktype"
    case .getCurrectLatLong(_): return "/appointments/mob_map_add"

    case .updateSession(_): return "/appointments/update"
    case .updateClockSession(_): return "/appointments/update"
        
    }
  }
  
  var method: String {
    switch self {
    case .appointmentList,.addNewSession,.getCurrectLatLong(_): return "POST"
    case .clientNameList,.nonBillableClientName: return "POST"
      
    case .addregister(_): return "POST"
      
    case .updateSession(_):
      return "POST"
    case .updateClockSession(_):
            return "POST"

    }
  }
  
    var parameters: [URLQueryItem]? {
        switch self {
        case .appointmentList,.addNewSession: return nil
        case .clientNameList,.nonBillableClientName: return nil
        case .addregister(_),.getCurrectLatLong(_): return nil
        case .updateSession(_):
            return nil
        case .updateClockSession(_):
            return nil
        }
    }
  
  var body: Data? {
    switch self {
      
    case .appointmentList(let request):
      
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
      
    case .clientNameList(let request):
      
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
      
      
    case .nonBillableClientName(let request):
      
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
      
    case .addNewSession(let request):
     
      let encoder = JSONEncoder()
      return try? encoder.encode(request)
      
    case .addregister(_): return nil
      
    case .updateSession(let request):
       
        let encoder = JSONEncoder()
        return try? encoder.encode(request)
        
    case .getCurrectLatLong(let request):
       
        let encoder = JSONEncoder()
        return try? encoder.encode(request)
    case .updateClockSession(let request):
        
        let encoder = JSONEncoder()
        return try? encoder.encode(request)
    }
    
    
  }
  
  var headerFields: [String : String] {
    switch self {
    case .appointmentList,.addNewSession,.getCurrectLatLong: return [:]
    case .clientNameList,.nonBillableClientName:  return [:]
    case .addregister(_): return [:]
      
    case .updateSession(_):
      return [:]
    case .updateClockSession(_):
              return [:]
    }
  }
  
  var formDataParameters : [String : Any?]? {
    switch self {
      
    case .addNewSession(_):
      return nil
    case .getCurrectLatLong(_):
      return nil
    case .appointmentList(_):
      return nil
    case .clientNameList(_),.nonBillableClientName:
      return nil
    case .addregister(let request):
      
      let RequestParameters = [
        
        "user_name":request.user_name,
        "profile_image" : request.profile_image,
        "full_name":request.full_name,
        "password":request.password,
        "confirmPassword":request.confirmPassword,
        "email":request.email,
        "phone":request.phone,
        "zipcode":request.zipcode
        
        ] as [String : Any]
      
      return RequestParameters
      
    case .updateSession(_):
      return nil
    case .updateClockSession(_):
        return nil
    }
  }
  
}
