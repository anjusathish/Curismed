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
        getAppointmentsList()
        
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
        
        self.appointmentTableView.reloadData()
    }
    
    @objc private func addSessionSuccess(notification: NSNotification){
        
        getAppointmentsList()
    }
    
    
    //MARK:- UIButton Action Methodes
    @IBAction func addSessionAction(_ sender: Any) {
        
        let submittedquotevc = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "SideMenuController")
        self.navigationController?.pushViewController(submittedquotevc, animated: true)
    }
    
    @IBAction func calenderAction(_ sender: CTDayWeekCalender) {
        
        self.appointmentData.removeAll()
        
        getAppointmentsList()
        
    }
    
    
    func getAppointmentsList(){
        
        var providerID: Int = 0
        
        if let _providerID = UserProfile.shared.currentUser?.providerID,let practiceID = UserProfile.shared.currentUser?.practiceID{
            
            if let role = UserProfile.shared.currentUser?.role {
                
                if role == "Admin"{
                    providerID = 0
                }else{
                    providerID = _providerID
                }
            }
            
            let request = AppointmentsListRequest(clientName: "", appType: "", statusName: "", providerName:"" , locationName: "", fromDate: selectedDate ?? todayStr, toDate: selectedDate ?? todayStr, providerID: String(providerID), practiceID: String(practiceID))
            
            viewModel.getAppointmentListData(request)
        }
        
    }
    
    func convertDateFormater(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateFormat = "hh:mm a"
        return  dateFormatter.string(from: date)
    }
    
    func convertDateFormater2(_ date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
        let modelAppointment = appointmentData[indexPath.row]
        
        
        let appInfo = modelAppointment.appointment?[0]
        let appData = appInfo?.appInfo?[0]
        cell.labelAppType.text = appData?.patientName
        
        if appData?.appType == "billable" {
            if let filterPathData = appInfo?.patInfo?.filter({$0.auths == appData?.auth}){
                
                if filterPathData.isEmpty {
                }else{
                    if let name = appInfo?.appInfo?[0].name{
                        cell.labelActivity.text = name
                    }}
            }
        }else{
            
            cell.labelActivity.text = appData?.activity
            cell.imageViewMotorCycle.isHidden = true
            cell.imageViewClockGif.isHidden = true
        }
        
        
        
        let convertStartTime = convertDateFormater(appData?.startDate ?? "")
        let convertEndTime = convertDateFormater(appData?.endDate ?? "")
        cell.labelSessionHours.text = convertStartTime + " to " + convertEndTime
        
        let currentDate = Date().string(format: "MM-dd-yyyy")
        
        if currentDate == convertDateFormater2((appData?.startDate)!) {
            
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
        if let appStatus = AppStatus(rawValue: appData?.status ?? ""){
            switch appStatus {
            case .rendered: cell.viewSessionStatus.backgroundColor = UIColor.curismedRendered
            case .confirmed: cell.viewSessionStatus.backgroundColor = UIColor.curismedConfirmed
            case .cancelledByProvide: cell.viewSessionStatus.backgroundColor = UIColor.curismedCancelled
            case .cancelledByClient: cell.viewSessionStatus.backgroundColor = UIColor.curismedCancelled
            case .others:    cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            case .hold:      cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            case .noShow:    cell.viewSessionStatus.backgroundColor = UIColor.curismedOthers
            }
            if appStatus != .confirmed{
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
        let appInfo = modelAppointment.appointment?[0]
        let appData = appInfo?.appInfo?[0]
        vc.appointmentData = modelAppointment
        vc.status = appData?.status
        vc.delegate = self
        vc.appointmentDataList = appData
        vc.indexx = indexPath.row
        vc.arrObj = arrObjTravel
        vc.activity = appData?.activity ?? ""
        vc.arrObjClock = arrObjClock
        if appData?.appType == "non-billable"{
            vc.activityLabel = appInfo?.patInfo?[0].activities?[0].label ?? ""
        }
        if let filterPathData = appInfo?.patInfo?.filter({$0.auths == appData?.auth}){
            if filterPathData.isEmpty{
            }
            else{
                if appData?.appType == "billable" {
                    let _activity = filterPathData[0].activities?[0]
                    vc.activity = _activity?.label ?? ""
                    vc.activityID = appInfo?.appInfo?[0].activity ?? ""
                    vc.activityArray = filterPathData[0].activities!
                    vc.activityLabel = appInfo?.appInfo?[0].name ?? ""
                    
                }
                    
                else{
                    vc.activity = appData?.activity ?? ""
                }
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension DashBoardViewController: AppointmentDelegate{
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
        if UserProfile.shared.currentUser?.role  == "Admin" {
            
            if let practiceID = UserProfile.shared.currentUser?.practiceID {
                
                let request = AppointmentsListRequest(clientName: "", appType: "", statusName: "", providerName: "", locationName: "", fromDate: selectedDate ?? todayStr, toDate: selectedDate ?? todayStr, providerID: "0", practiceID: String(practiceID))
                
                viewModel.getAppointmentListData(request)
                
            }
            
        }
        else {
            if let providerID = UserProfile.shared.currentUser?.providerID,let practiceID = UserProfile.shared.currentUser?.practiceID {
                
                let request = AppointmentsListRequest(clientName: "", appType: "", statusName: "", providerName: "", locationName: "", fromDate: selectedDate ?? todayStr, toDate: selectedDate ?? todayStr, providerID: String(providerID), practiceID: String(practiceID))
                
                viewModel.getAppointmentListData(request)
                
            }
        }
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
