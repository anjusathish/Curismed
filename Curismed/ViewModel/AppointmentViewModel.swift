//
//  AppointmentViewModel.swift
//  Curismed
//
//  Created by PraveenKumar R on 05/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import Foundation

protocol AppointmentDelegate{
    func appointmentListData(_ appointmentData : [AppointmentsListData])
    
    func getPatientList(list: [CommonData])
    func getProviderList(list: [CommonData])
    func getPointOfService(data: [PointOfService])
    func getAppointmentStatus(data: [String])
    func getAuthorization(data: [AuthorizationsDatum])
    func getActivityData(data: [CommonData])
    func appointmentSuccess(message: String)
    
    func updateSession(_ updateSuccess: AppointmentUpdateResponse)
    func addSessionResponse(_ addSession: AddNewSessionResponse)
    func clientListData(_ clientNameData: [PatientDatum])
    func nonBillableClientName(_ clientName: [NonBillableDatum])
    func appointmentFailure(message : String)
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData : AppointmentMobileMapAddResponse)
    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse)
}

class AppointmentViewModel{
    
    var delegate: AppointmentDelegate?
    
    func updateClockSessionAPI(_ info: AppointmentUpdateClockRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.updateClockSession(info), completion: { (result : Result<AppointmentUpdateResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let updateSession):
                    
                    self.delegate?.updateClockSession(updateSession)
                    
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
        
    }
    
    //MARK:- AppointmentList API
    func getAppointmentListData(_ date: String) {
        AppointmentServiceHelper.request(router: AppointmentServiceManager.appointmentList(date), completion: { (result : Result<AppointmentsListResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let appointmentList):
                    if let data =  appointmentList.appointments?.data {
                        self.delegate?.appointmentListData(data)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Patient List
    func getPatientList() {
        AppointmentServiceHelper.request(router: .getPatientList, completion: { (result : Result<PatientListModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let patientList):
                    if let data = patientList.CommonData {
                        self.delegate?.getPatientList(list: data)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Providder List
    func getProviderList() {
        AppointmentServiceHelper.request(router: .getProviderList, completion: { (result : Result<ProviderListModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let providerList):
                    if let data = providerList.providerData {
                        self.delegate?.getProviderList(list: data)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Point of contact
    func getPointOfService() {
        AppointmentServiceHelper.request(router: .getPointOfService, completion: { (result : Result<PointOfServiceModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let pointOfService):
                    if let data = pointOfService.pointOfService {
                        self.delegate?.getPointOfService(data: data)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Appointment status List
    func getAppointmentStatus() {
        AppointmentServiceHelper.request(router: .getAppointmentStatus, completion: { (result : Result<AppointmentStatusModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let status):
                    if let data = status.statusList {
                        self.delegate?.getAppointmentStatus(data: data)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Appointment status List
    func getAuthByClientID(info: AuthByClientIdRequest) {
        AppointmentServiceHelper.request(router: .authByClientId(info), completion: { (result : Result<AuthorizationModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    if let authData = data.authorizationsData {
                        self.delegate?.getAuthorization(data: authData)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Appointment status List
    func getActivityByAuth(info: ActivityByAuthIdRequest) {
        AppointmentServiceHelper.request(router: .activityByAuth(info), completion: { (result : Result<ActivityServiceModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    if let serviceData = data.serviceData {
                        self.delegate?.getActivityData(data: serviceData)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Appointment status List
    func createAppointment(isBillable: Bool, info: Any) {
        AppointmentServiceHelper.request(router: isBillable ? .addBillableAppointment(info as! AddBillableAppointmentRequest) : .addNonBillableAppointment(info as! AddNonBillableAppointmentRequest),
                                         completion: { (result : Result<AppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    if let message = data.message {
                        self.delegate?.appointmentSuccess(message: message)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    //Get Appointment status List
    func updateAppointment(info: UpdateAppointmentRequest) {
        AppointmentServiceHelper.request(router: .updateAppointment(info), completion: { (result : Result<AppointmentModel, CustomError>) in
            DispatchQueue.main.async {
                switch result{
                case .success(let data):
                    if let message = data.message {
                        self.delegate?.appointmentSuccess(message: message)
                    }
                case .failure(let message):
                    self.delegate?.appointmentFailure(message: "\(message)")
                }
            }
        })
    }
    
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData : AppointmentMobileMapAddRequest) {
        AppointmentServiceHelper.request(router: AppointmentServiceManager.getCurrectLatLong(appointmentMobileMapAddData), completion: { (result : Result<AppointmentMobileMapAddResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                case .success(let getcurrentLoc):
                    self.delegate?.getCurrentLocationSuccess(getcurrentLoc)
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
    }
}
