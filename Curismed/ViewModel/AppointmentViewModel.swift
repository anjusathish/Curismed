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
    
    
    //MARK:- AddSession
    func addNewSessionAPI(info: AddNewSessionRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.addNewSession(info), completion: { (result : Result<AddNewSessionResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let addSession):
                    
                    self.delegate?.addSessionResponse(addSession)
                    
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
        
    }
    
    
    //MARK:-
    
    func updateSessionAPI(_ info: AppointmentUpdateRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.updateSession(info), completion: { (result : Result<AppointmentUpdateResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let updateSession):
                    
                    self.delegate?.updateSession(updateSession)
                    
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
        
    }
    
    //MARK:-
    
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
    
    func getAppointmentListData(_ info: AppointmentsListRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.appointmentList(info), completion: { (result : Result<AppointmentsListResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let appointmentList):
                    
                    if let data =  appointmentList.data{
                        
                        self.delegate?.appointmentListData(data)
                    }
                    
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
    }
    
    //MARK:- ClientName List API
    
    func getClientNameList(info: ClientListRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.clientNameList(_info: info), completion: { (result : Result<ClientListResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let clientNameList):
                    
                    if let data = clientNameList.data{
                        
                        self.delegate?.clientListData(data)
                    }
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
    }
    
    //MARK:- Non Billable ClientName List API
    
    func getNonBillableClientNameList(info: ClientListRequest){
        
        AppointmentServiceHelper.request(router: AppointmentServiceManager.nonBillableClientName(info), completion: { (result : Result<NonBillableClientResponse, CustomError>) in
            
            DispatchQueue.main.async {
                
                switch result{
                    
                case .success(let clientNameList):
                    
                    if let data = clientNameList.data{
                        
                        self.delegate?.nonBillableClientName(data)
                    }
                case .failure(let message): self.delegate?.appointmentFailure(message: "\(message)")
                    
                }
            }
        })
    }
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData : AppointmentMobileMapAddRequest)
    {
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
