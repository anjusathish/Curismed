//
//  AddSessionViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import BEMCheckBox
import DropDown
import GooglePlaces

enum BillableDropDownType: Int {
  case patientName = 0
  case authorization = 1
  case activity = 2
  case location = 3
}

enum Location: String {
    case home = "12"
    case office = "11"
    case school = "03"
    case community = "99"
    case others = "-1"
    case TeleTherapy = "02"
}
class AddSessionTypeViewController: BaseViewController {
  
  @IBOutlet weak var viewBillableSession: UIView!
  @IBOutlet weak var viewNonBillableSession: UIView!
  @IBOutlet weak var txtClient: CTTextField!
  @IBOutlet weak var txtAuthorization: CTTextField!
  @IBOutlet weak var txtActivity: CTTextField!
  @IBOutlet weak var txtLocation: CTTextField!
  @IBOutlet weak var txtNonBillableActivity: CTTextField!
  @IBOutlet weak var txtNonBillableClientName: CTTextField!
  
  @IBOutlet weak var billableSessionBox: BEMCheckBox!{
    didSet{
      billableSessionBox.boxType = .circle
    }
  }
  
  @IBOutlet weak var nonBillableSessionBox: BEMCheckBox!{
    didSet{
      nonBillableSessionBox.boxType = .circle
    }
  }
  
  let dropDown = DropDown()
  var arrayClientName = [PatientDatum]()
  var arrayNonBillable = [NonBillableDatum]()
    
    var arrayAuthorization = [String]()
  
  lazy var viewModel : AppointmentViewModel = {
    return AppointmentViewModel()
  }()
  
  private var patientName: String = ""
  private var patientID: String = ""
  private var authNo: String = ""
  private var activityNo: String = ""
  private var location: String = ""
  private var sessionType: String = ""
  
  private var arrayNonBillableActivity:[String] = ["Delivery Time","Regular Time","Training and Admin","Fill-in","Other","Paid Time off","UnPaid"]
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    titleString = "Add Session"
    location = "12"
    viewNonBillableSession.isHidden = true
    billableSessionBox.on = true
    viewModel.delegate = self
    sessionType = "billable"
    
    if let practiceID = UserProfile.shared.currentUser?.practiceID {
      let request = ClientListRequest(token: "P6kqxOsEzVV2QxOkGR3HcqlKPlk1J5XaSV2hhLQp", practiceID: practiceID)
      print(request)
      viewModel.getClientNameList(info: request)
    }
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? AddSessionViewController {
      vc.patientName = patientName
      vc.patientID = patientID
      vc.authNo = authNo
      vc.activityNo = activityNo
      vc.location = location
      vc.sessionType = sessionType
     vc.nonClientName = txtNonBillableClientName.text ?? ""
     vc.nonActivity  = txtNonBillableActivity.text ?? ""
      //  vc.delegate = self
    }
    
  }
  
  //MARK:- UIButton Action Methodes
  @IBAction func addSessionAction(_ sender: UIButton) {
    
    if sessionType == "billable" {
      
      if patientName.isEmpty {
        self.displayError(withMessage: .invalidClientName)
        
      }else if authNo.isEmpty{
        self.displayError(withMessage: .invalidAuthorization)
        
      }else if activityNo.isEmpty {
        self.displayError(withMessage: .invalidActivity)
        
      }else if location.isEmpty{
        self.displayError(withMessage: .invalidLocation)
      }else{
        
        self.performSegue(withIdentifier: "PushAddSession", sender: self)
      }
    }else{

        if patientName.isEmpty {
          self.displayError(withMessage: .invalidClientName)
          
        }
        else{
           // authNo = arrayNonBillable[0].patientInfo.map({$0.authoNo},
//            authNo = arrayNonBillable[0].auth ?? ""
            let patientdata = arrayNonBillable[0].patientInfo
            patientID = "\(String(describing: patientdata[0].id))"
            self.performSegue(withIdentifier: "PushAddSession", sender: self)
        }
    }
  }
  
  //MARK:- Rememberme Action
  @IBAction func sessionBoxAction(_ sender: BEMCheckBox) {
    
    if sender.tag == 0{
      
      billableSessionBox.on = true
      nonBillableSessionBox.on = false
      viewBillableSession.isHidden = false
      viewNonBillableSession.isHidden = true
      
      sessionType = "billable"
      
    }else{
      
      billableSessionBox.on = false
      nonBillableSessionBox.on = true
      viewBillableSession.isHidden = true
      viewNonBillableSession.isHidden = false
      
      sessionType = "non-billable"
      
      if let practiceID = UserProfile.shared.currentUser?.practiceID {
        let request = ClientListRequest(token: "P6kqxOsEzVV2QxOkGR3HcqlKPlk1J5XaSV2hhLQp", practiceID: practiceID)
        viewModel.getNonBillableClientNameList(info: request)
      }
      
    }
  }
  
  //MARK:- ShowDropDown
  func showDropDown(sender : UITextField, content : [String]) {
    
    let dropDown = DropDown()
    dropDown.direction = .any
    dropDown.anchorView = sender
    dropDown.dismissMode = .automatic
    dropDown.dataSource = content
    
    dropDown.selectionAction = { (index: Int, item: String) in
      
      if sender == self.txtAuthorization {
//        sender.text = self.arrayClientName[0].patInfo.filter({$0.authsVal == item}).map({$0.auths}).first
        let allAuthNos = self.arrayClientName.filter({$0.patientName == self.patientName})[0].patInfo.map({$0.auths})
        sender.text = allAuthNos[index]
      }else if sender == self.txtLocation {
        if item == "Others" {
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                UInt(GMSPlaceField.placeID.rawValue))!
            autocompleteController.placeFields = fields
            
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            autocompleteController.autocompleteFilter = filter
            self.location = Location.others.rawValue
            
            self.present(autocompleteController, animated: true, completion: nil)
            
        }
        else if item == "Home"{
            self.location = Location.home.rawValue
            sender.text = item
        }
        else if item == "Office"{
            self.location = Location.office.rawValue
            sender.text = item
        }
        else if item == "School"{
            self.location = Location.school.rawValue
            sender.text = item
        }
        else if item == "Community"{
            self.location = Location.community.rawValue
            sender.text = item
        }
        else if item == "TeleTherapy"{
            self.location = Location.TeleTherapy.rawValue
            sender.text = item
        }
      }
      else{
        sender.text = item
      }
      
      if let selectedDropDown = BillableDropDownType(rawValue: sender.tag) {
        
        switch selectedDropDown {
          
        case .patientName:
          
          self.patientName = sender.text ?? ""
          
          if let _patientID = self.arrayClientName.filter({$0.patientName == sender.text}).map({$0.patientID}).first {
            
            self.patientID = "\(_patientID ?? 0)"
          }
          
        case .authorization:
//            self.authNo = self.arrayClientName[0].patInfo.filter({$0.authsVal == item}).map({$0.auths}).first!
            var allAuthNos = self.arrayClientName.filter({$0.patientName == self.patientName})[0].patInfo.map({$0.auths})
            self.authNo = allAuthNos[index]
        case .activity:
          
//          let arrayActivity = self.arrayClientName[0].patInfo.filter({$0.auths == self.txtAuthorization.text}).map({$0.activities}).first
          let arrayActivity = self.arrayClientName.filter({$0.patientName == self.patientName})[0].patInfo.map({$0.activities}).first

          
          
          if let _activityNo = arrayActivity?.filter({$0.label == item}).map({$0.key}).first {
            
            self.activityNo = "\(_activityNo)"
          }
          
        case .location: break
          
        }
      }
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
  
    
 
  
}

extension AddSessionTypeViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case txtClient:
            
            showDropDown(sender: txtClient, content: self.arrayClientName.map({$0.patientName}))
            txtAuthorization.text = ""
            txtActivity.text = ""
            return false
            
        case txtAuthorization:
            
//            let arrayAuthorization = self.arrayClientName[0].patInfo.map({$0.authsVal})
            if patientName != ""
             {
                 arrayAuthorization = self.arrayClientName.filter({$0.patientName == patientName})[0].patInfo.map({$0.authsVal})
                showDropDown(sender: txtAuthorization, content: arrayAuthorization)
            }
            return false
            
        case txtActivity:
            
            if patientName != ""
            {
                if let arrayActivity = self.arrayClientName.filter({$0.patientName == patientName})[0].patInfo.map({$0.activities}).first {
                    let _arrayActivity = arrayActivity.map({$0.label})
                    
                    showDropDown(sender: txtActivity, content: _arrayActivity)
                }
            }

            
            return false
            
        case txtLocation:
            
            var arrayIntLocation: [String] = []
            
            
            //      arrayIntLocation.append(contentsOf: self.arrayClientName[0].locInfo.filter({$0.home == 1}).map({$0.home}))
            //      arrayIntLocation.append(contentsOf: self.arrayClientName[0].locInfo.filter({$0.office == 1}).map({$0.office}))
            //      arrayIntLocation.append(contentsOf: self.arrayClientName[0].locInfo.filter({$0.school == 1}).map({$0.school}))
            //      arrayIntLocation.append(contentsOf: self.arrayClientName[0].locInfo.filter({$0.community == 1}).map({$0.community}))
            
            //  arrayStringLocation.first(where: { $0["home"] == "abbey"})
            if patientName != ""
            {
                let home = self.arrayClientName.filter({$0.patientName == patientName})[0].locInfo.map({$0.home}).first
                let office = self.arrayClientName.filter({$0.patientName == patientName})[0].locInfo.map({$0.office}).first
                let school = self.arrayClientName.filter({$0.patientName == patientName})[0].locInfo.map({$0.school}).first
                let community = self.arrayClientName.filter({$0.patientName == patientName})[0].locInfo.map({$0.community}).first

                var arrayStringLocation = arrayIntLocation.map { String($0) }
    //            arrayStringLocation.append("Home")
                
                if home == 1 { arrayStringLocation.append("Home") }
                if office == 1 { arrayStringLocation.append("Office") }
                if school == 1 { arrayStringLocation.append("School") }
                if community == 1 { arrayStringLocation.append("Community") }
                arrayStringLocation.append("Others")
                arrayStringLocation.append("TeleTherapy")

                
                
                
                showDropDown(sender: txtLocation, content: arrayStringLocation)
            }

            //      let locationOffice = self.arrayClientName[0].locInfo.filter({$0.office == 1}).map({$0.office})
            //      let locationSchool = self.arrayClientName[0].locInfo.filter({$0.school == 1}).map({$0.school})
            //      let locationCommunity = self.arrayClientName[0].locInfo.filter({$0.community == 1}).map({$0.community})
            
            
            
            
            //      let autocompleteController = GMSAutocompleteViewController()
            //      autocompleteController.delegate = self
            //
            //      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            //        UInt(GMSPlaceField.placeID.rawValue))!
            //      autocompleteController.placeFields = fields
            //
            //      let filter = GMSAutocompleteFilter()
            //      filter.type = .address
            //      autocompleteController.autocompleteFilter = filter
            //
            //      present(autocompleteController, animated: true, completion: nil)
            
            return false
            
            
        case txtNonBillableActivity:
            
            showDropDown(sender: txtNonBillableActivity, content: arrayNonBillableActivity)
            return false
            
        case txtNonBillableClientName:
            
            let _arrayClientName = arrayNonBillable[0].patientInfo.map({$0.fullName})
            
            showDropDown(sender: txtNonBillableClientName, content: _arrayClientName)
            
            return false
            
        default: break
            
        }
        return true
    }
    
}

extension AddSessionTypeViewController: AppointmentDelegate{
    func updateClockSession(_ updateSuccess: AppointmentUpdateResponse) {
        
    }
    
    func getCurrentLocationSuccess(_ appointmentMobileMapAddData: AppointmentMobileMapAddResponse) {
        
    }
    
  func updateSession(_ updateSuccess: AppointmentUpdateResponse) {
    
  }
  
  
  func nonBillableClientName(_ clientName: [NonBillableDatum]) {
    
    arrayNonBillable = clientName
    
  }
  
  
  func addSessionResponse(_ addSession: AddNewSessionResponse) {
    
  }
  
  
  func clientListData(_ clientNameData: [PatientDatum]) {
    self.arrayClientName = clientNameData
  }
  
  func appointmentListData(_ appointmentData: [AppointmentsListData]) {
  }
  
  func appointmentFailure(message: String) {
    
    displayServerError(withMessage: message)
  }
  
}

extension AddSessionTypeViewController: GMSAutocompleteViewControllerDelegate{
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    let addressValue =  place.name
    self.txtLocation.text = addressValue
    self.location = addressValue!
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

extension AddSessionViewController: AddAppointmenteDelegateMethode{
  func addAppointementSucess(_ message: String) {
    
  }
  
  
}
