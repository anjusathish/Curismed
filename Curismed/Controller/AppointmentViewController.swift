//
//  AppointmentViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import DropDown
import MapKit
import CoreLocation
import SwiftKeychainWrapper
import SwiftGifOrigin
import SwiftyGif

protocol UpdateAppointmenteDelegateMethode {
    func updateAppointementSucess(_ message: String)
}

class AppointmentViewController: BaseViewController, CLLocationManagerDelegate {
    @IBOutlet weak var txtClockIn: CTTextField!
    
    @IBOutlet weak var txtTravelStart: CTTextField!
    @IBOutlet weak var txtNotes: CTTextField!
    @IBOutlet weak var txtBreakTime: CTTextField!
    @IBOutlet weak var txtEndTime: CTTextField!
    @IBOutlet weak var txtStartTime: CTTextField!
    @IBOutlet weak var txrRenderDate: CTTextField!
    @IBOutlet weak var txtStatus: CTTextField!
    @IBOutlet weak var txtService: CTTextField!
    @IBOutlet weak var txtDateAndTime: CTTextField!
    @IBOutlet weak var txtAddress: CTTextField!
    @IBOutlet weak var txtMobileNumber: CTTextField!
    @IBOutlet weak var txtClientName: CTTextField!
    
    @IBOutlet weak var imageViewSignature: UIImageView!
    @IBOutlet weak var travelGif: UIImageView!
    @IBOutlet weak var clockGif: UIImageView!

    @IBOutlet weak var travelStartStackView: UIStackView!
    
    @IBOutlet weak var travelBtn: UIButton!
    @IBOutlet weak var clockBtn: UIButton!

    @IBOutlet weak var addSignBtn: UIButton!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var showCurrentLocationView: UIView!
    var popUpController: STPopupController?
    let window = UIApplication.shared.windows.first
    
    public var delegate: UpdateAppointmenteDelegateMethode?
    public var appointmentDataList: AppInfo?
    public var appointmentData: AppointmentsListData?
    public var activity =  String()
    public var activityArray =  [AActivity]()
    var thirtySecTimer = Timer()
    var activityLabel = String()
    
    public var status: String?
    var clockInTime: String = ""
    var clockOutTime: String = ""

    private var arrayStatus:[String] = ["Confirm","Rendered","No Show","Cancelled by Provider","Cancelled by Client","Hold"]
    let defaults = UserDefaults.standard
    
    lazy var viewModel : AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var startTime: String = ""
    var endTime: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var customPickerObj : CustomPicker!
    var selectedDate:Date?
    private var base64String: String = ""
    private var breakTime: String = ""
    private var latitudeStr: String = ""
    private var longitudeStr: String = ""
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var startStr = Int()
    var numberOfClicks = String()
    var selectedStartIndexArr = [Int]()
    var selectedClockIndexArr = [Int]()
    var indexStopTravel = Int()
    var activityID = String()
    
    var indexx = 0
    var arrObj = [Dictionary<String, AnyObject>]()
    var arrObjClock = [Dictionary<String, AnyObject>]()


    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        titleString = "Appointment"
        viewModel.delegate = self
        
        let currentDate = Date().string(format: "MM-dd-yyyy")
        
        if currentDate == convertDateFormater((appointmentDataList?.startDate)!){
            if appointmentDataList?.appType == "non-billable"{
                userInteration(isEnable: false)
                addSignBtn.isUserInteractionEnabled = false
                txtStatus.isUserInteractionEnabled = false
                travelStartStackView.isHidden = true
                updateBtn.isHidden = true
                showCurrentLocationView.isUserInteractionEnabled = false
                txtAddress.rightImage = nil
            }
            else
            {
                if status == "Confirm"{
                    travelStartStackView.isHidden = false
                    userInteration(isEnable: true)
                    addSignBtn.isUserInteractionEnabled = true
                    txtStatus.isUserInteractionEnabled = true
                    showCurrentLocationView.isUserInteractionEnabled = true

                }
                else if status == "Rendered"{
                    travelStartStackView.isHidden = true
                    userInteration(isEnable: false)
                    addSignBtn.isUserInteractionEnabled = true
                    txtStatus.isUserInteractionEnabled = true
                    showCurrentLocationView.isUserInteractionEnabled = false
                    txtAddress.rightImage = nil
                }else
                {
                    travelStartStackView.isHidden = true
                    userInteration(isEnable: false)
                    addSignBtn.isUserInteractionEnabled = false
                    txtStatus.isUserInteractionEnabled = true
                    showCurrentLocationView.isUserInteractionEnabled = false
                    txtAddress.rightImage = nil
                }
            }
        }else
        {
            travelStartStackView.isHidden = true
            showCurrentLocationView.isUserInteractionEnabled = false
            txtAddress.rightImage = nil
        }
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.openDiapPad(_:)))
////        txtMobileNumber.superView.addGestureRecognizer(gesture)
//        self.txtMobileNumber.addGestureRecognizer(gesture)
        
//        self.txtMobileNumber.addTarget(self, action: #selector(openDiapPad), for: .allTouchEvents)
        self.txtMobileNumber.isUserInteractionEnabled = false
        txtClientName.text = appointmentDataList?.patientName
        txtAddress.text = appointmentData?.address
        txtMobileNumber.text = appointmentData?.phoneHome
        
        txtService.text = activityLabel
        txtStatus.text = appointmentDataList?.status
        

        let convertDateFormat = convertDateFormater((appointmentDataList?.startDate)!)
        txrRenderDate.text = convertDateFormat
        
        guard let dateAsString = appointmentDataList?.renderedStartDate else { return  }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateAsString) else { return  }
        dateFormatter.dateFormat = "hh:mm a"
        
        let fromTime = dateFormatter.string(from: date)
        txtStartTime.text = fromTime
        
        guard let todateAsString = appointmentDataList?.renderedEndDate else { return  }
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date1 = dateFormatter1.date(from: todateAsString) else { return }
        dateFormatter1.dateFormat = "hh:mm a"
        
        let toTime = dateFormatter.string(from: date1)
        txtEndTime.text = toTime
        
        txtDateAndTime.text = convertDateFormat + " " + fromTime + " to " + toTime
        
        txtNotes.text = appointmentDataList?.desc
        
        
        if arrObj.count != 0 {
            if (ConstantObj.Data.names[indexx]["isHidden"] as! Bool) == true {
                self.txtTravelStart.text = "Start"
                self.clockBtn.isUserInteractionEnabled = true
                self.travelGif.isHidden = true
            }
            else {
                self.txtTravelStart.text = "Stop"
                self.clockBtn.isUserInteractionEnabled = false
                do
                {
                    let gif = try UIImage(gifName: "motorcycle.gif")
                    self.travelGif.isHidden = false
                    self.travelGif.setGifImage(gif)
                    self.travelGif.delegate = self
                }
                catch
                {
                    print(error)
                }
            }
        }
        else{
            if (ConstantObj.Data.names[indexx]["isHidden"] as! Bool) == true {
                self.txtTravelStart.text = "Start"
                self.clockBtn.isUserInteractionEnabled = true
                self.travelGif.isHidden = true
            }
            else {
                self.txtTravelStart.text = "Stop"
                self.clockBtn.isUserInteractionEnabled = false
                do
                {
                    let gif = try UIImage(gifName: "motorcycle.gif")
                    self.travelGif.isHidden = false
                    self.travelGif.setGifImage(gif)
                    self.travelGif.delegate = self
                }
                catch
                {
                    print(error)
                }
            }
        }

        if arrObjClock.count != 0 {
            if (ConstantObj.Data.clock[indexx]["isHidden"] as! Bool) == true {
                self.txtClockIn.text = "In"
                self.travelBtn.isUserInteractionEnabled = true
                self.clockGif.isHidden = true
            }
            else {
                self.txtClockIn.text = "Out"
                self.travelBtn.isUserInteractionEnabled = false
                do
                {
                    let gif = try UIImage(gifName: "ClickAnimation.gif")
                    self.clockGif.isHidden = false
                    self.clockGif.setGifImage(gif)
                    self.clockGif.delegate = self
                }
                catch
                {
                    print(error)
                }
            }
        }
        else{
            if (ConstantObj.Data.clock[indexx]["isHidden"] as! Bool) == true {
                self.txtClockIn.text = "In"
                self.travelBtn.isUserInteractionEnabled = true
                self.clockGif.isHidden = true
            }
            else {
                self.txtClockIn.text = "Out"
                self.travelBtn.isUserInteractionEnabled = false
                do
                {
                    let gif = try UIImage(gifName: "ClickAnimation.gif")
                    self.clockGif.isHidden = false
                    self.clockGif.setGifImage(gif)
                    self.clockGif.delegate = self
                }
                catch
                {
                    print(error)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(ConstantObj.Data.names, forKey: "ConstantObj")
        UserDefaults.standard.set(ConstantObj.Data.clock, forKey: "ConstantObjClock")
    }
    @IBAction func showLocBtn(_ sender: Any) {
        let vc = UIStoryboard.appointmentStoryboard().instantiateViewController(withIdentifier: "CurrentLocationViewController") as! CurrentLocationViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.address = appointmentData?.address ?? "Current Location"
        self.present(navController, animated:true, completion: nil)
    }

    @objc func openDiapPad() {
        guard let number = URL(string: "tel://" + "4151231234") else { return }
        UIApplication.shared.open(number)
    }

    
    
    func userInteration(isEnable: Bool){
        travelBtn.isUserInteractionEnabled = isEnable
        clockBtn.isUserInteractionEnabled = isEnable
        txrRenderDate.isUserInteractionEnabled = isEnable
        txtStartTime.isUserInteractionEnabled = isEnable
        txtEndTime.isUserInteractionEnabled = isEnable
        txtBreakTime.isUserInteractionEnabled = isEnable
        txtNotes.isUserInteractionEnabled = isEnable
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latitudeStr = "\(locValue.latitude)"
        longitudeStr = "\(locValue.longitude)"
    }
    @objc func changeStartTravelClr() {
        let colors = [
            UIColor.white,
            UIColor.lightGray
        ]
        let randomColor = Int(arc4random_uniform(UInt32 (colors.count)))
        self.txtTravelStart.backgroundColor = colors[randomColor]
    }
    @objc func changeClockInClr() {
        let colors = [
            UIColor.white,
            UIColor.lightGray
        ]
        let randomColor = Int(arc4random_uniform(UInt32 (colors.count)))
        self.txtClockIn.backgroundColor = colors[randomColor]
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return  dateFormatter.string(from: date)
    }
    
    
    func convertDateFormater2(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date)
    }
    
    
    func convertTimeFormat24hoursto12hours(_ Time: String){
        
    }
    
    //MARK:- ShowDropDown
    func showDropDown(sender : UITextField, content : [String]) {
        
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.anchorView = sender
        dropDown.dismissMode = .automatic
        dropDown.dataSource = content
        
        dropDown.selectionAction = { (index: Int, item: String) in
            
            if sender == self.txtService{
                if let id = self.activityArray[index].key
                {
                    self.activityID = "\(id)"
                }
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
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    //MARK:- UIButton Action Methodes
    @IBAction func addSignatureAction(_ sender: Any) {
        
        let controller = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "AddSignature") as! AddSignatureViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func buttonTravelStart(_ sender: Any) {
        if (ConstantObj.Data.names[indexx]["isHidden"] as! Bool) == true {
            let alert = UIAlertController.init(title: nil, message: "Do you want to start the Travel?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Start Travel", style: .default, handler: { (action) in
                self.txtTravelStart.text = "Stop"
                
                do
                {
                    let gif = try UIImage(gifName: "motorcycle.gif")
                    self.travelGif.isHidden = false
                    self.travelGif.setGifImage(gif)
                    self.travelGif.delegate = self
                }
                catch
                {
                    print(error)
                }

                self.thirtySecTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector:#selector(self.getCurrentLocationAPI), userInfo: nil, repeats: true)
                self.thirtySecTimer.fire()
                self.clockBtn.isUserInteractionEnabled = false
                ConstantObj.Data.names[self.indexx]["isHidden"] = false as AnyObject
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController.init(title: nil, message: "Do you want to stop the Travel?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Stop Travel", style: .default, handler: { (action) in
                self.txtTravelStart.text = "Start"
                self.txtTravelStart.backgroundColor = UIColor.white
                self.travelGif.isHidden = true
                self.thirtySecTimer.invalidate()
                self.getCurrentLocationAPI()
                self.clockBtn.isUserInteractionEnabled = true
                ConstantObj.Data.names[self.indexx]["isHidden"] = true as AnyObject
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func buttonClockIn(_ sender: Any) {

        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        if (ConstantObj.Data.clock[indexx]["isHidden"] as! Bool) == true {
            let alert = UIAlertController.init(title: nil, message: "Do you want to Clock In?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Clock In", style: .default, handler: { (action) in
                ConstantObj.Data.clock[self.indexx]["isHidden"] = false as AnyObject
                self.txtClockIn.text = "Out"
                do
                {
                    let gif = try UIImage(gifName: "ClickAnimation.gif")
                    self.clockGif.isHidden = false
                    self.clockGif.setGifImage(gif)
                    self.clockGif.delegate = self
                }
                catch
                {
                    print(error)
                }
                self.travelBtn.isUserInteractionEnabled = false
                self.clockInTime = dateFormatter.string(from: currentTime)
                self.clockOutTime = ""
                self.clockinOutAPI()
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController.init(title: nil, message: "Do you want to Clock Out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Clock Out", style: .default, handler: { (action) in
                ConstantObj.Data.clock[self.indexx]["isHidden"] = true as AnyObject
                self.txtClockIn.text = "In"
                self.clockGif.isHidden = true
                self.travelBtn.isUserInteractionEnabled = true
                self.clockOutTime = dateFormatter.string(from: currentTime)
                self.clockInTime = ""
                self.clockinOutAPI()
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func getCurrentLocationAPI()   {
        var isEnd : String?
        
        ((ConstantObj.Data.names[indexx]["isHidden"] as! Bool) == true) ? (isEnd = "0") : (isEnd = "1")
        
        let degree = latitudeStr + " and " + longitudeStr
        let request = AppointmentMobileMapAddRequest.init(app_id: "\(appointmentDataList?.id ?? 0)", degrees: degree, is_end: isEnd!)
        print(request)
        viewModel.getCurrentLocationSuccess(request)
    }
    
    func clockinOutAPI()  {
        guard let _startDate = txrRenderDate.text, !_startDate.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        guard let _startTime = txtStartTime.text, !_startTime.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        
        guard let _endTime = txtEndTime.text, !_endTime.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: _startTime)
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let fromTime = dateFormatter.string(from: date!)
        //txtStartTime.text = fromTime
        
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        let date1 = dateFormatter1.date(from: _endTime)
        dateFormatter1.dateFormat = "HH:mm:ss"
        
        let toTime = dateFormatter.string(from: date1!)

        let convertStartDate = convertDateFormater2(_startDate)
        
        if let practiceID = UserProfile.shared.currentUser?.practiceID,let providerID = UserProfile.shared.currentUser?.providerID{
            let costartTime = convertStartDate + " " + fromTime
            let cotoTime = convertStartDate + " " + toTime
            
            let request = AppointmentUpdateClockRequest.init(appType: appointmentDataList?.appType ?? "", appID: "\(appointmentDataList?.id ?? 0)", status: txtStatus.text!, fromTime: costartTime, toTime: cotoTime, breakTime: breakTime, activity: (appointmentDataList?.activity)!, notes: txtNotes.text!, imgSign: base64String, clockIn: clockInTime, clockOut: clockOutTime , practiceID: "\(practiceID)", providerID: "\(providerID)",providerName: appointmentDataList?.provider ?? "",location: appointmentDataList?.location ?? "")
            
            print(request)
            
            viewModel.updateClockSessionAPI(request)
        }
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        
        
        guard let _startDate = txrRenderDate.text, !_startDate.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        guard let _startTime = txtStartTime.text, !_startTime.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        
        guard let _endTime = txtEndTime.text, !_endTime.removeWhiteSpace().isEmpty else {
            displayError(withMessage: .inVaildDate)
            return
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: _startTime)
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let fromTime = dateFormatter.string(from: date!)
        //txtStartTime.text = fromTime
        
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        let date1 = dateFormatter1.date(from: _endTime)
        dateFormatter1.dateFormat = "HH:mm:ss"
        
        let toTime = dateFormatter.string(from: date1!)
        //   txtEndTime.text = toTime
        
        
        
        
        let convertStartDate = convertDateFormater2(_startDate)
        
        let costartTime = convertStartDate + " " + fromTime
        let cotoTime = convertStartDate + " " + toTime
        
        
        
        if txtStatus.text == "Rendered" {
            if base64String.isEmpty {
                self.displayServerError(withMessage: "Please add signature")
            }else{
                
                if let practiceID = UserProfile.shared.currentUser?.practiceID,let providerID = UserProfile.shared.currentUser?.providerID,let providerName = appointmentDataList?.provider {
                    
                    let request = AppointmentUpdateRequest(appType: appointmentDataList?.appType ?? "", appID: "\(appointmentDataList?.id ?? 0)", status: txtStatus.text!, fromTime: costartTime, toTime: cotoTime, breakTime: breakTime, activity: self.activityID, notes: txtNotes.text!, imgSign: base64String, practiceID: practiceID, providerID: providerID, providerName: providerName,location: appointmentDataList?.location ?? "")
                    
                    print(request)
                    
                    viewModel.updateSessionAPI(request)
                }
                
            }
        }else{
            
            if let practiceID = UserProfile.shared.currentUser?.practiceID,let providerID = UserProfile.shared.currentUser?.providerID,let providerName = appointmentDataList?.provider {
                
                let request = AppointmentUpdateRequest(appType: appointmentDataList?.appType ?? "", appID: "\(appointmentDataList?.id ?? 0)", status: txtStatus.text!, fromTime: costartTime, toTime: cotoTime, breakTime: breakTime, activity: self.activityID, notes: txtNotes.text!, imgSign: base64String, practiceID: practiceID, providerID: providerID,providerName: providerName,location: appointmentDataList?.location ?? "")
                
                print(request)
                
                viewModel.updateSessionAPI(request)
            }
            
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension AppointmentViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtStatus{
            showDropDown(sender: txtStatus, content: arrayStatus)
            return false
        }else if textField == txrRenderDate{
            
            let picker = self.showDateTimePicker(mode: .date, selectedDate: selectedDate)
            picker.dismissBlock = { date in
                self.selectedDate = date
                self.txrRenderDate.text = date.asString(withFormat: "MM-dd-yyyy")
                self.startDate = date.asString(withFormat: "yyyy-MM-dd")
            }
            return false
            
        }else if textField == txtStartTime{
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .time
            
            vc.dismissBlock = { dataObj in
                textField.text = dataObj.getasString(inFormat: "hh:mm a")
                self.startTime = dataObj.getasString(inFormat: "HH:mm")
                
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
            
        }else if textField == txtBreakTime{
            
            let vc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            
            vc.mode = .countDownTimer
            
            vc.dismissBlock = { dataObj in
                let hour = dataObj.getasString(inFormat: "HH")
                let min = dataObj.getasString(inFormat: "mm")
                let overallTime = dataObj.getasString(inFormat: "HH:mm")
                if min != "01"{
                    textField.text = "\(hour) Hour \(min) Minute"
                }
                else{
                    textField.text = "\(hour) Hour \(min) Minutes"
                }
                self.breakTime = overallTime
            }
            present(controllerInSelf: vc)
            return false
        }
        else if textField == txtService{

            showDropDown(sender: txtService, content: activityArray.map({$0.label}))
            
            return false
        }
        return true
    }
}

extension AppointmentViewController: SignatureDelegateMethode {
    
    func getSignatureImage(_ signatureImage: UIImage) {
        
        print(signatureImage)
        imageViewSignature.image = signatureImage
        
        base64String = convertImageToBase64String(img: signatureImage)
        
    }
    
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension AppointmentViewController: AppointmentDelegate{
    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData: AppointmentMobileMapAddResponse) {
        
    }
    
    
    func appointmentListData(_ appointmentData: [AppointmentsListData]) {
        
    }
    
    func updateSession(_ updateSuccess: AppointmentUpdateResponse) {
        self.displayServerSuccess(withMessage: "Updated successfully")
        delegate?.updateAppointementSucess("Updated successfully")
        self.navigationController?.popViewController(animated: true)
    }
    
    func addSessionResponse(_ addSession: AddNewSessionResponse) {
        
    }
    
    func clientListData(_ clientNameData: [PatientDatum]) {
        
    }
    
    func nonBillableClientName(_ clientName: [NonBillableDatum]) {
        
    }
    
    func appointmentFailure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    
}
extension AppointmentViewController: SwiftyGifDelegate {
  
  func gifURLDidFinish(sender: UIImageView) {
    print("gifURLDidFinish")
  }
  
  func gifURLDidFail(sender: UIImageView) {
    print("gifURLDidFail")
  }
  
  func gifDidStart(sender: UIImageView) {
    print("gifDidStart")
  }
  
  func gifDidLoop(sender: UIImageView) {
    
  }
  
  func gifDidStop(sender: UIImageView) {
    print("gifDidStop")
  }
}
