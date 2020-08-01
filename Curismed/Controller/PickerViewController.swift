//
//  PickerViewController.swift
//  Auto Salaah
//
//  Created by CIPL0590 on 09/08/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    
    @IBOutlet var timePicker: UIDatePicker!
    @IBOutlet var timeToolbar: UIToolbar!
    
    let window = UIApplication.shared.keyWindow
    
    var dismissBlock: ((Date) -> Void)?
    
    var mode : UIDatePicker.Mode?
    var currentDate : Date?
    var calender : Calendar?
    var allowOnlyAM: Bool?
    var status: String?
    
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        
        if let _mode = mode
        {
            timePicker.datePickerMode = _mode
            timePicker.countDownDuration = 60
            timePicker.date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "hh:mm a"
            let startDateStr = UserDefaults.standard.value(forKey: "startTime")
            let date = dateFormatter.date(from: startDateStr as? String ?? dateFormatter.string(from: Date()))
            
            (status == "clickedEndTime") ? (timePicker.date = date ?? Date()) : (timePicker.date = Date())
        }
        
        if let _date = currentDate
        {
            timePicker.setDate(_date, animated: false)
        }
        
        if let _allowOnlyAM = allowOnlyAM, _allowOnlyAM {
            
            if let _date = currentDate {
                setPickerToAM(withDate: _date)
            }
            else {
                setPickerToAM(withDate: Date())
            }
        }
        
        if let _calender = calender {
            timePicker.calendar = _calender
        }
        
        self.contentSizeInPopup = CGSize(width: window!.frame.width, height: 300)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let dismiss = self.dismissBlock {
                dismiss(self.timePicker.date)
            }
        })
    }
    
    func setPickerToAM(withDate date:Date) {
        
        let startHour: Int = 0
        let endHour: Int = 11
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        let components: NSDateComponents = gregorian.components(([.day, .month, .year]), from: date) as NSDateComponents
        components.hour = startHour
        components.minute = 0
        components.second = 0
        let startDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        components.hour = endHour
        components.minute = 59
        components.second = 59
        let endDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        timePicker.minimumDate = startDate as Date
        timePicker.maximumDate = endDate as Date
    }
    
}
