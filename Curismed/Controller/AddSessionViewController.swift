//
//  AddSessionViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol AddAppointmenteDelegateMethode {
    func addAppointementSucess(_ message: String)
}

class AddSessionViewController: BaseViewController {
    
    @IBOutlet weak var txtStartDate: CTTextField!
    @IBOutlet weak var txtStartTime: CTTextField!
    @IBOutlet weak var txtEndTime: CTTextField!
    @IBOutlet weak var txtViewNotes: UITextView!
    
    @IBOutlet weak var billableSessionBox: BEMCheckBox!{
        didSet{
            billableSessionBox.boxType = .square
        }
    }
    
    @IBOutlet weak var payableSessionBox: BEMCheckBox!{
        didSet{
            payableSessionBox.boxType = .square
        }
    }
    
    public var addSessionRequest: AddNewSessionRequest?
    
    var startTime: String = ""
    var endTime: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var customPickerObj : CustomPicker!
    var selectedDate:Date?
    
    public var patientName: String = ""
    public var patientID: String = ""
    public var authNo: String = ""
    public var activityNo: String = ""
    public var location: String = ""
    public var sessionType: String = ""
    public var nonClientName: String = ""
    public var nonActivity: String = ""
    
    var delegate: AddAppointmenteDelegateMethode?
    
    lazy var viewModel : AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "Add Session"
        viewModel.delegate = self
        print(authNo)
        
    }
    
    //MARK:- UIButton Action Methodes
    @IBAction func addSetionAction(_ sender: Any) {
        if sessionType != "billable" {
            
            guard let _startDate = txtStartDate.text, !_startDate.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .inVaildDate)
                return
            }
            guard let startTime = txtStartTime.text, !startTime.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .invaildStartTime)
                return
            }
            
            guard let endTime = txtEndTime.text, !endTime.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .invaildEndTime)
                return
            }
            
            if let providerName = UserProfile.shared.currentUser?.providerName, let providerID = UserProfile.shared.currentUser?.providerID ,let practiceID = UserProfile.shared.currentUser?.practiceID{
                
                let request = AddNewSessionRequest(appType: "non-billable", patientName: nonClientName, addNewSessionRequestDescription: txtViewNotes.text, statusApp: "Confirm", startDate: self.startDate + " " + self.startTime, endDate: self.startDate + " " + self.endTime, patientID: patientID, providerName: providerName, providerID: "\(providerID)", authNo: authNo, activity: nonActivity, pos: location, repeatSunday: 0, repeatMonday: 0, repeatTuesday: 0, repeatWednesday: 0, repeatThursday: 0, repeatFriday: 0, repeatSaturday: 0, repeatFrequency: "", repeatCountOccurrance: 0, practiceID: String(practiceID))
                print(request)
                
                viewModel.addNewSessionAPI(info: request)
            }
            
            
        }else{
            
            guard let _startDate = txtStartDate.text, !_startDate.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .inVaildDate)
                return
            }
            guard let startTime = txtStartTime.text, !startTime.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .invaildStartTime)
                return
            }
            
            guard let endTime = txtEndTime.text, !endTime.removeWhiteSpace().isEmpty else {
                displayError(withMessage: .invaildEndTime)
                return
            }
            
            addSessionAPIcall()
        }
        
    }
    
    func addSessionAPIcall(){
        if let providerName = UserProfile.shared.currentUser?.providerName, let providerID = UserProfile.shared.currentUser?.providerID ,let practiceID = UserProfile.shared.currentUser?.practiceID{
            
            
            let request = ["app_type": "billable",
                           "patientName": patientName,
                           "description": txtViewNotes.text ?? "",
                           "statusApp": "Confirm",
                           "start_date": self.startDate + " " + self.startTime,
                           "end_date": self.startDate + " " + self.endTime,
                           "patientID": patientID,
                           "providerName": providerName,
                           "providerID": "\(providerID)",
                "authNo": authNo,
                "activity": activityNo,
                "POS": location,
                "repeat_sunday": 0,
                "repeat_monday": 0,
                "repeat_tuesday": 0,
                "repeat_wednesday": 0,
                "repeat_thursday": 0,
                "repeat_friday": 0,
                "repeat_saturday": 0,
                "repeat_frequency": "",
                "repeat_count_occurrance": 0,
                "practice_id": String(practiceID)
                ] as [String : Any]
            
            print(request)
            var urlReq = URLRequest(url: URL(string: "https://app.curismed.com/appointments/recurrence")!)
            urlReq.httpMethod = "POST"
            urlReq.httpBody = try? JSONSerialization.data(withJSONObject: request, options: [])
            urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlReq, completionHandler: { data, response, error -> Void in
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    
                    let successMessage: String = json["message"] as! String
                    
                    DispatchQueue.main.async {
                        self.displayServerSuccess(withMessage: successMessage)
                        let d1 = ["name": "hi", "isHidden" : true] as [String : AnyObject]
                        
                        ConstantObj.Data.names.append(d1)
                        ConstantObj.Data.clock.append(d1)
                        
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
                        
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: DashBoardViewController.self) {
                                
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    
                } catch {
                    if let returnData = String(data: data!, encoding: .utf8) {
                        print(returnData)
                        let splitDict = returnData.components(separatedBy: "}]}")
                        if splitDict.last != nil {
                            let response = splitDict.last
                            
                            if let split2Dict = response
                            {
                                let splitStatusFromDict = split2Dict.components(separatedBy: ",")
                                if let status = splitStatusFromDict.first
                                {
                                    let stausValue = status.components(separatedBy: ":")
                                    if let statusfinal = stausValue.last
                                    {
                                        DispatchQueue.main.async {
                                            let d1 = ["name": "hi", "isHidden" : true] as [String : AnyObject]
                                            
                                            ConstantObj.Data.names.append(d1)
                                            ConstantObj.Data.clock.append(d1)
                                            
                                            let nc = NotificationCenter.default
                                            nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
                                            
                                            for controller in self.navigationController!.viewControllers as Array {
                                                if controller.isKind(of: DashBoardViewController.self) {
                                                    
                                                    self.navigationController!.popToViewController(controller, animated: true)
                                                    break
                                                }
                                            }
                                        }
                                        if statusfinal == "1"{
                                            print("Successh")
                                        }else{
                                            print("Failure")
                                        }
                                    }
                                }
                            }
                            
                        }else{
                            print("Not Proper Response")
                        }
                        
                    }
                }
            })
            
            task.resume()
            
        }
        
        
    }
}

extension AddSessionViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtStartDate {
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.txtStartDate.text = date.asString(withFormat: "MM-dd-yyyy")
                self.startDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
            
        }else if textField == txtStartTime{
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.startTime = dataObj.getasString(inFormat: "HH:mm")
                UserDefaults.standard.set(dataObj.getasString(inFormat: "hh:mm a"), forKey: "startTime")
                
            }
            present(controllerInSelf: vc)
            return false
            
        }else if textField == txtEndTime{
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            vc.status = "clickedEndTime"
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.endTime = dataObj.getasString(inFormat: "HH:mm")
            }
            present(controllerInSelf: vc)
            
            return false
        }
        
        return true
    }
    
}

extension AddSessionViewController: AppointmentDelegate{
    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData: AppointmentMobileMapAddResponse) {
        
    }
    
    func updateSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func nonBillableClientName(_ clientName: [NonBillableDatum]) {
        
    }
    
    
    func appointmentListData(_ appointmentData: [AppointmentsListData]) {
        
    }
    
    func addSessionResponse(_ addSession: AddNewSessionResponse) {
        
        self.displayServerSuccess(withMessage: "New Session Added Successfully")
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: DashBoardViewController.self) {
                
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func clientListData(_ clientNameData: [PatientDatum]) {
        
    }
    
    func appointmentFailure(message: String) {
        
        self.displayServerError(withMessage: message)
    }
    
}
