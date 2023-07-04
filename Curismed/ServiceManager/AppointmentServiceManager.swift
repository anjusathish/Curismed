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
    case addBillableAppointment(_ info: AddBillableAppointmentRequest)
    case addNonBillableAppointment(_ info: AddNonBillableAppointmentRequest)
    case updateAppointment(_ info: UpdateAppointmentRequest)
    case getPatientList
    case getProviderList
    case getPointOfService
    case getAppointmentStatus
    
    case authByClientId(_ info: AuthByClientIdRequest)
    case activityByAuth(_ info: ActivityByAuthIdRequest)
    
    case createBillableAppoinemnt(_ info: AddBillableAppointmentRequest)
    case createNonBillableAppoinemnt(_ info: AddNonBillableAppointmentRequest)

    case appointmentList(_ date: String)
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
        case .updateSession(_):  return API.scheme
        case .updateClockSession(_): return API.scheme
        case .addBillableAppointment, .addNonBillableAppointment, .updateAppointment, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt:  return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .appointmentList,.addNewSession,.getCurrectLatLong(_): return API.baseURL
        case .clientNameList,.nonBillableClientName: return API.baseURL
        case .addregister(_): return API.baseURL
        case .updateSession(_): return API.baseURL
        case .updateClockSession, .addNonBillableAppointment, .updateAppointment, .addBillableAppointment, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt: return API.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .appointmentList: return "/api/v1/ios/appointments/mob_gets"
        case .clientNameList: return "/api/v1/ios/patient/mob_list5"
        case .addNewSession: return "/api/v1/ios/appointments/recurrence"
        case .addregister(_): return ""
        case .nonBillableClientName: return "/api/v1/ios/appointment/mob_checktype"
        case .getCurrectLatLong(_): return "/api/v1/ios/appointments/mob_map_add"
        case .updateSession(_): return "/api/v1/ios/appointments/update"
        case .updateClockSession(_): return "/api/v1/ios/appointments/update"
        case .addBillableAppointment:  return "/api/v1/ios/appointment/billable/create"
        case .addNonBillableAppointment:  return "/api/v1/ios/appointment/non-billable/create"
        case .getPatientList: return "/api/v1/ios/appointment/patients"
        case .getProviderList: return "/api/v1/ios/appointment/providers"
        case .getPointOfService: return "/api/v1/ios/appointment/pointofservice"
        case .getAppointmentStatus: return "/api/v1/ios/appointment/status"
        case .updateAppointment: return "/api/v1/ios/appointment/update"
        case .authByClientId: return "/api/v1/ios/client/authorization"
        case .activityByAuth: return "/api/v1/ios/client/activity"
        case .createBillableAppoinemnt: return "/api/v1/ios/appointment/billable/create"
        case .createNonBillableAppoinemnt: return "/api/v1/ios/appointment/non-billable/create"
        }
    }
    
    var method: String {
        switch self {
        case .appointmentList,.addNewSession,.getCurrectLatLong(_): return "POST"
        case .clientNameList,.nonBillableClientName: return "POST"
        case .addregister(_): return "POST"
        case .updateSession(_):  return "POST"
        case .updateClockSession(_), .addBillableAppointment, .addNonBillableAppointment, .updateAppointment, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt: return "POST"
        case .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus: return "GET"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .appointmentList(let date): return [URLQueryItem(name: "schedule_date", value: date)]
        case .addNewSession: return nil
        case .clientNameList,.nonBillableClientName: return nil
        case .addregister(_),.getCurrectLatLong(_): return nil
        case .updateSession(_): return nil
        case .updateClockSession(_), .addBillableAppointment, .addNonBillableAppointment, .updateAppointment, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt: return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .appointmentList, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus: return nil
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
            
        case .addBillableAppointment(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .addNonBillableAppointment(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .updateAppointment(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .authByClientId(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .activityByAuth(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .createBillableAppoinemnt(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)
            
        case .createNonBillableAppoinemnt(let req):
            let encoder = JSONEncoder()
            return try? encoder.encode(req)

        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .appointmentList,.addNewSession,.getCurrectLatLong: return [:]
        case .clientNameList,.nonBillableClientName:  return [:]
        case .addregister(_): return [:]
        case .updateSession(_):  return [:]
        case .updateClockSession(_), .addBillableAppointment, .addNonBillableAppointment, .updateAppointment, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt: return [:]
        }
    }
    
    var formDataParameters : [String : Any?]? {
        switch self {
        case .addNewSession(_):  return nil
        case .getCurrectLatLong(_): return nil
        case .appointmentList(_): return nil
        case .clientNameList(_),.nonBillableClientName: return nil
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
        case .updateSession(_):  return nil
        case .updateClockSession(_), .addBillableAppointment, .addNonBillableAppointment, .updateAppointment, .getPatientList, .getProviderList, .getPointOfService, .getAppointmentStatus, .authByClientId, .activityByAuth, .createBillableAppoinemnt, .createNonBillableAppoinemnt:  return nil
        }
    }
}
