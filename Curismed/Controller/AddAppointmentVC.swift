//
//  AddAppointmentVC.swift
//  TherapyPMS
//
//  Created by Satiz War Machine on 03/07/23.
//  Copyright © 2023 Praveen. All rights reserved.
//

import UIKit
import BEMCheckBox
import DropDown

class AddAppointmentVC: BaseViewController {
    
    @IBOutlet weak var patientNameTF: CTTextField!
    @IBOutlet weak var authTF: CTTextField!
    @IBOutlet weak var serviceTF: CTTextField!
    @IBOutlet weak var providerNameTF: CTTextField!
    @IBOutlet weak var posTF: CTTextField!
    @IBOutlet weak var fromDateTF: CTTextField!
    @IBOutlet weak var toDateTF: CTTextField!
    @IBOutlet weak var fromTimeTF: CTTextField!
    @IBOutlet weak var toTimeTF: CTTextField!
    @IBOutlet weak var statusTF: CTTextField!
    @IBOutlet weak var billableSessionBox: BEMCheckBox!{
        didSet{
            billableSessionBox.boxType = .square
        }
    }
    @IBOutlet weak var nonBillableSessionBox: BEMCheckBox!{
        didSet{
            nonBillableSessionBox.boxType = .square
        }
    }
    
    private var selectedDate: Date?
    
    private var clientID: Int?
    private var authID: Int?
    private var activityID: Int?
    private var providertID: Int?
    private var posID: Int?
    private var status: String?
    private var sessionType: Int?
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    private var patientListData: [CommonData] = []
    private var providerListData: [CommonData] = []
    private var pointOfServiceData: [PointOfService] = []
    
    private var authData: [AuthorizationsDatum] = []
    private var activityData: [CommonData] = []
    
    
    private var statusData: [String] = []
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleString = "Add Appointment"
        viewModel.delegate = self
        
        dispatchGroup.enter()
        viewModel.getPatientList()
        
        dispatchGroup.enter()
        viewModel.getProviderList()
        
        dispatchGroup.enter()
        viewModel.getPointOfService()
        
        dispatchGroup.enter()
        viewModel.getAppointmentStatus()
        
        /// `Notify Main thread`
        dispatchGroup.notify(queue: .main) {
            print("All APIs are completed")
        }
    }
    
    //MARK:- ShowDropDown
    func showDropDown(sender : UITextField, content : [String]) {
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { [self] (index: Int, item: String) in
            
            if sender == patientNameTF {
                if let clientID = self.patientListData[index].id,
                   patientNameTF.text != self.patientListData[index].text {
                    self.clientID = clientID
                    self.authTF.text = ""
                    self.serviceTF.text = ""
                    self.authID = nil
                    self.activityID = nil
                    
                    viewModel.getAuthByClientID(info: AuthByClientIdRequest(client_id: clientID))
                }
            }
            
            if sender == authTF {
                if let authID = self.authData[index].id,
                   authTF.text != self.authData[index].text {
                    self.authID = authID
                    self.serviceTF.text = ""
                    self.activityID = nil
                    
                    viewModel.getActivityByAuth(info: ActivityByAuthIdRequest(authorization_id: authID))
                }
            }
            
            if sender == serviceTF {
                if let activityID = self.activityData[index].id {
                    self.activityID = activityID
                }
            }
            
            if sender == self.providerNameTF {
                if let providertID = self.providerListData[index].id,
                   providerNameTF.text != self.providerListData[index].text {
                    self.providertID = providertID
                }
            }
            
            if sender == self.posTF {
                if let posID = self.pointOfServiceData[index].id {
                    self.posID = posID
                }
            }
            
            if sender == self.statusTF {
                self.status = self.statusData[index]
            }
            
            sender.text = item
        }
        
        dropDown.width = sender.frame.width
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        if let visibleDropdown = DropDown.VisibleDropDown {
            visibleDropdown.dataSource = content
        }
        else {
            dropDown.show()
        }
    }
    
    @IBAction func addSessionTypeButton(_ sender: BEMCheckBox) {
        
        billableSessionBox.on = sender.tag == 0
        nonBillableSessionBox.on = sender.tag != 0
        sessionType = sender.tag == 0 ? 1 : 2
        
    }
    
    @IBAction func addAppointmentBtn(_ sender: UIButton) {
        
        let addAppointment = AddBillableAppointmentRequest(billable: sessionType,
                                                           clientID: clientID,
                                                           authorizationID: authID,
                                                           activityID: activityID,
                                                           providerID: providertID,
                                                           location: posID,
                                                           daily: 1,
                                                           fromTime: fromTimeTF.text,
                                                           formTimeSession: fromTimeTF.text,
                                                           toTimeSession: toTimeTF.text,
                                                           status: status,
                                                           endDate: toDateTF.text,
                                                           chkrecurrence: 1)
        
        if sessionType == 1 {
            viewModel.createAppointment(isBillable: true, info: addAppointment)
        } else {
            viewModel.createAppointment(isBillable: false, info: addAppointment)
        }
        
    }
}

extension AddAppointmentVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var dropDownData = [String]()
        
        switch textField {
            
        case patientNameTF : dropDownData = patientListData.compactMap({ $0.text })
            
        case authTF        :  dropDownData = authData.compactMap({ $0.text })
            
        case serviceTF     :  dropDownData = activityData.compactMap({ $0.text })
            
        case providerNameTF:  dropDownData = providerListData.compactMap({ $0.text })
            
        case posTF         :  dropDownData = pointOfServiceData.compactMap({ $0.posName })
            
        case statusTF      : dropDownData = statusData
            
        default            : break
            
        }
        
        showDropDown(sender: textField, content: dropDownData)
        
        if textField == fromDateTF {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.fromDateTF.text = date.asString(withFormat: "MM-dd-yyyy")
            }
            
        } else if textField == toDateTF {
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.toDateTF.text = date.asString(withFormat: "MM-dd-yyyy")
            }
            
        } else if textField == fromTimeTF {
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.fromTimeTF.text = dataObj.getasString(inFormat: "HH:mm:ss")
                UserDefaults.standard.set(dataObj.getasString(inFormat: "hh:mm a"), forKey: "startTime")
            }
            present(controllerInSelf: vc)
            
        } else if textField == toTimeTF {
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            vc.status = "clickedEndTime"
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.toTimeTF.text = dataObj.getasString(inFormat: "HH:mm:ss")
            }
            present(controllerInSelf: vc)
            
        }
        return false
    }
}

extension AddAppointmentVC: AppointmentDelegate {
    
    func appointmentSuccess(message: String) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAuthorization(data: [AuthorizationsDatum]) {
        authData = data
    }
    
    func getActivityData(data: [CommonData]) {
        activityData = data
    }
    
    func appointmentListData(_ appointmentData: [AppointmentsListData]) {
        
    }
    
    func getPatientList(list: [CommonData]) {
        patientListData = list
        dispatchGroup.leave()
    }
    
    func getProviderList(list: [CommonData]) {
        providerListData = list
        dispatchGroup.leave()
    }
    
    func getPointOfService(data: [PointOfService]) {
        pointOfServiceData = data
        dispatchGroup.leave()
    }
    
    func getAppointmentStatus(data: [String]) {
        statusData = data
        dispatchGroup.leave()
    }
    
    func updateSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func addSessionResponse(_ addSession: AddNewSessionResponse) {
        
    }
    
    func clientListData(_ clientNameData: [PatientDatum]) {
        
    }
    
    func nonBillableClientName(_ clientName: [NonBillableDatum]) {
        
    }
    
    func appointmentFailure(message: String) {
        
    }
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData: AppointmentMobileMapAddResponse) {
        
    }
    
    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
}