//
//  DashBoardViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyGif
import FSCalendar

enum AppStatus: String {
    case confirmed = "Confirm"
    case rendered = "Rendered"
    case cancelledByProvide = "Cancelled by Provider"
    case cancelledByClient = "Cancelled by Client"
    case others = "Others"
    case hold = "Hold"
    case noShow = "No Show"
}

class DashBoardViewController: BaseViewController {
    
    @IBOutlet weak var appointmentTableView: UITableView!{
        
        didSet{
            appointmentTableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardCell")
            appointmentTableView!.tableFooterView = UIView()
            appointmentTableView.separatorColor = UIColor.clear
        }
    }
    @IBOutlet weak var calendarView: CTDayWeekCalender!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarVw: FSCalendar!
    lazy var viewModel : AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    let today = Date()
    
    private var appointmentData = [AppointmentsListData]()

    let defaults = UserDefaults.standard
    public var isAddAppointement: Bool = false
    var indexTravel = Int()
    var indexStopTravel = Int()
    var indexClck = Int()
    var indexStopClck = Int()
    var selectedStartIndexArr = [Int]()
    var selectedStopIndexArr = [Int]()
    
    var selectedClockStartIndexArr = [Int]()
    var selectedClockStopIndexArr = [Int]()
    
    let d1 = ["name": "hi", "isHidden" : true] as [String : AnyObject]
    var arrObjTravel = [Dictionary<String, AnyObject>]()
    var arrObjClock = [Dictionary<String, AnyObject>]()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var selectedDate : String?
    var todayStr = String()
    //MARK:- ViewController LifeCycleT
    override func viewDidLoad() {
        super.viewDidLoad()
        titleString = "My Appointments"
        viewModel.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(addSessionSuccess), name: Notification.Name("UserLoggedIn"), object: nil)
        
        
        for _ in 0...100{
            ConstantObj.Data.names.append(d1)
            ConstantObj.Data.clock.append(d1)
        }
        
        self.calendarVw.select(Date())
        
        self.calendarVw.scope = .week
        
        // For UITest
        self.calendarVw.accessibilityIdentifier = "calendar"
        todayStr = dateFormatter.string(from: today)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if  UserDefaults.standard.value(forKey: "ConstantObj") as? [Dictionary<String, AnyObject>] != nil {
            arrObjTravel = UserDefaults.standard.value(forKey: "ConstantObj") as! [Dictionary<String, AnyObject>]
            ConstantObj.Data.names = arrObjTravel
        }
        if  UserDefaults.standard.value(forKey: "ConstantObjClock") as? [Dictionary<String, AnyObject>] != nil {
            arrObjClock = UserDefaults.standard.value(forKey: "ConstantObjClock") as! [Dictionary<String, AnyObject>]
            ConstantObj.Data.clock = arrObjClock
        }
        getAppointmentsList()
        appointmentTableView.reloadData()
    }
    
    @objc private func addSessionSuccess(notification: NSNotification){
        getAppointmentsList()
    }
    
    
    //MARK:- UIButton Action Methodes
    @IBAction func addSessionAction(_ sender: Any) {
        let submittedquotevc = UIStoryboard.appointmentStoryboard().instantiateViewController(withIdentifier: "AddAppointmentVC") as! AddAppointmentVC
        self.navigationController?.pushViewController(submittedquotevc, animated: true)
    }
    
    @IBAction func calenderAction(_ sender: CTDayWeekCalender) {
        getAppointmentsList()
    }
    
    
    func getAppointmentsList() {
        guard let date = selectedDate, !date.isEmpty else {
            self.displayServerError(withMessage: "Selected Appointment date cannot be empty!")
            return
        }
        appointmentData.removeAll()
        viewModel.getAppointmentListData("2023-05-09")
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "hh:mm a"
        return  dateFormatter.string(from: date)
    }
    
    func convertDateFormater2(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return  dateFormatter.string(from: date)
    }
    
}

extension DashBoardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardTableViewCell
        let appData = appointmentData[indexPath.row]
        
        cell.labelActivity.text = appData.cptCode // needs to be changed
        cell.labelAppType.text = appData.billable // needs to be changed
        
        if appData.billable != "billable" {
            cell.imageViewMotorCycle.isHidden = true
            cell.imageViewClockGif.isHidden = true
        }
        
        if let startDate = appData.sessionStartDateTimeUTC,
           let endDate = appData.sessionEndDateTimeUTC {
            let convertedStartTime = convertDateFormater(startDate)
            let convertedEndTime = convertDateFormater(endDate)
            cell.labelSessionHours.text = convertedStartTime + " to " + convertedEndTime
        }
        
        let currentDate = Date().string(format: "MM-dd-yyyy")
        
        if currentDate == convertDateFormater2(appData.sessionStartDateTimeUTC ?? currentDate) {
            if arrObjTravel.count != 0 {
                if (ConstantObj.Data.names[indexPath.row]["isHidden"] as? Bool) == true {
                    cell.imageViewMotorCycle.isHidden = true
                }
                else {
                    do {
                        let gif = try UIImage(gifName: "motorcycle.gif")
                        cell.imageViewMotorCycle.isHidden = false
                        cell.imageViewMotorCycle.setGifImage(gif)
                        cell.imageViewMotorCycle.delegate = self
                    }
                    catch
                    {
                        
                    }
                }
            }
            else{
                
                if (ConstantObj.Data.names[indexPath.row]["isHidden"] as? Bool) == true {
                    cell.imageViewMotorCycle.isHidden = true
                }
                else {
                    do {
                        let gif = try UIImage(gifName: "motorcycle.gif")
                        cell.imageViewMotorCycle.isHidden = false
                        cell.imageViewMotorCycle.setGifImage(gif)
                        cell.imageViewMotorCycle.delegate = self
                    }
                    catch
                    {
                        
                    }
                }
            }
            
            if arrObjClock.count != 0 {
                if (ConstantObj.Data.clock[indexPath.row]["isHidden"] as! Bool) == true {
                    cell.imageViewClockGif.isHidden = true
                }
                else {
                    do {
                        let gif = try UIImage(gifName: "ClickAnimation.gif")
                        cell.imageViewClockGif.isHidden = false
                        cell.imageViewClockGif.setGifImage(gif)
                        cell.imageViewClockGif.delegate = self
                    }
                    catch
                    {
                    }
                }
            }
            else{
                
                if (ConstantObj.Data.clock[indexPath.row]["isHidden"] as! Bool) == true {
                    cell.imageViewClockGif.isHidden = true
                }
                else {
                    do {
                        let gif = try UIImage(gifName: "ClickAnimation.gif")
                        cell.imageViewClockGif.isHidden = false
                        cell.imageViewClockGif.setGifImage(gif)
                        cell.imageViewClockGif.delegate = self
                    }
                    catch
                    {
                    }
                }
            }
        }
        else
        {
            cell.imageViewClockGif.isHidden = true
            cell.imageViewMotorCycle.isHidden = true
        }
        
        if let status = appData.sessionStatus,
           let appStatus = AppStatus(rawValue: status) {
            switch appStatus {
            case .rendered: cell.viewSessionStatus.backgroundColor = UIColor.curismedRendered
            case .confirmed: cell.viewSessionStatus.backgroundColor = UIColor.curismedConfirmed
            case .others:    cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            case .hold:      cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            case .noShow:    cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            case .cancelledByProvide: cell.viewSessionStatus.backgroundColor = UIColor.curismedCancelled
            case .cancelledByClient: cell.viewSessionStatus.backgroundColor = UIColor.curismedCancelled
            }
            if appStatus != .confirmed {
                cell.imageViewMotorCycle.isHidden = true
                cell.imageViewClockGif.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.appointmentStoryboard().instantiateViewController(withIdentifier: "Appointment") as! AppointmentViewController
        let modelAppointment = appointmentData[indexPath.row]
        let appInfo = modelAppointment
        let appData = appInfo
        vc.appointmentData = modelAppointment
        vc.status = appData.sessionStatus
        vc.delegate = self
        vc.indexx = indexPath.row
        vc.arrObj = arrObjTravel
        vc.arrObjClock = arrObjClock
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DashBoardViewController: AppointmentDelegate{
  
    func appointmentSuccess(message: String) {
        
    }
   
    func getAuthorization(data: [AuthorizationsDatum]) {
        
    }
    
    func getActivityData(data: [CommonData]) {
        
    }
    
    func getPatientList(list: [CommonData]) {
        
    }
    
    func getProviderList(list: [CommonData]) {
        
    }
    
    func getPointOfService(data: [PointOfService]) {
        
    }
    
    func getAppointmentStatus(data: [String]) {
        
    }

    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData: AppointmentMobileMapAddResponse) {
        
    }
    
    func updateSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func nonBillableClientName(_ clientName: [NonBillableDatum]) {
        
    }
    
    func addSessionResponse(_ addSession: AddNewSessionResponse) {
        
    }
    
    func clientListData(_ clientNameData: [PatientDatum]) {
        
    }
    
    func appointmentListData(_ appointmentData: [AppointmentsListData]) {
        
        self.appointmentData = appointmentData
        for _ in 0..<appointmentData.count{
            ConstantObj.Data.names.append(d1)
            ConstantObj.Data.clock.append(d1)
        }
        if  UserDefaults.standard.value(forKey: "ConstantObj") as? [Dictionary<String, AnyObject>] != nil {
            arrObjTravel = UserDefaults.standard.value(forKey: "ConstantObj") as! [Dictionary<String, AnyObject>]
            ConstantObj.Data.names = arrObjTravel
        }
        if  UserDefaults.standard.value(forKey: "ConstantObjClock") as? [Dictionary<String, AnyObject>] != nil {
            arrObjClock = UserDefaults.standard.value(forKey: "ConstantObjClock") as! [Dictionary<String, AnyObject>]
            ConstantObj.Data.clock = arrObjClock
        }
        
        appointmentTableView.reloadData()
    }
    
    func appointmentFailure(message: String) {
        self.appointmentData.removeAll()
        appointmentTableView.reloadData()
        displayServerError(withMessage: message)
    }
}

extension DashBoardViewController: SwiftyGifDelegate {
    
    func gifURLDidFinish(sender: UIImageView) {
        
    }
    
    func gifURLDidFail(sender: UIImageView) {
        
    }
    
    func gifDidStart(sender: UIImageView) {
        
    }
    
    func gifDidLoop(sender: UIImageView) {
        
    }
    
    func gifDidStop(sender: UIImageView) {
        
    }
}

extension DashBoardViewController: UpdateAppointmenteDelegateMethode{
    
    
    func updateAppointementSucess(_ message: String) {
//        if UserProfile.shared.currentUser?.role  == "Admin" {
//            
//            if let practiceID = UserProfile.shared.currentUser?.practiceID {
//                
//                let request = AppointmentsListRequest(clientName: "", appType: "", statusName: "", providerName: "", locationName: "", fromDate: selectedDate ?? todayStr, toDate: selectedDate ?? todayStr, providerID: "0", practiceID: String(practiceID))
//                
//                viewModel.getAppointmentListData(request)
//                
//            }
//            
//        }
//        else {
//            if let providerID = UserProfile.shared.currentUser?.providerID,let practiceID = UserProfile.shared.currentUser?.practiceID {
//                
//                let request = AppointmentsListRequest(clientName: "", appType: "", statusName: "", providerName: "", locationName: "", fromDate: selectedDate ?? todayStr, toDate: selectedDate ?? todayStr, providerID: String(providerID), practiceID: String(practiceID))
//                
//                viewModel.getAppointmentListData(request)
//                
//            }
//        }
    }
    
    
}
extension DashBoardViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectedDate = self.dateFormatter.string(from: date)
        
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        self.appointmentData.removeAll()
        
        getAppointmentsList()  //checking wait
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    
    
}

class ConstantObj : NSObject {
    struct Data {
        static var names = [Dictionary<String, AnyObject>]()
        static var clock = [Dictionary<String, AnyObject>]()
    }
}
