
//
//  AppointmentsList.swift
//  Curismed
//
//  Created by PraveenKumar R on 05/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import Foundation

//MARK:- Add Reg
struct AddRegisterRequest {
  let user_name: String
  let profile_image: String
  let full_name: String
  let password: String
  let confirmPassword: String
  let email: String
  let phone: String
  let zipcode: String
}

// MARK: - AddNewSessionRequest
struct AddNewSessionRequest: Codable {
  let appType, patientName, addNewSessionRequestDescription, statusApp: String
  let startDate, endDate, patientID, providerName: String
  let providerID, authNo, activity, pos: String
  let repeatSunday, repeatMonday, repeatTuesday, repeatWednesday: Int
  let repeatThursday, repeatFriday, repeatSaturday: Int
  let repeatFrequency: String
  let repeatCountOccurrance: Int
  let practiceID: String
  
  enum CodingKeys: String, CodingKey {
    case appType = "app_type"
    case patientName
    case addNewSessionRequestDescription = "description"
    case statusApp
    case startDate = "start_date"
    case endDate = "end_date"
    case patientID, providerName, authNo, activity
    case pos = "POS"
    case providerID
    case repeatSunday = "repeat_sunday"
    case repeatMonday = "repeat_monday"
    case repeatTuesday = "repeat_tuesday"
    case repeatWednesday = "repeat_wednesday"
    case repeatThursday = "repeat_thursday"
    case repeatFriday = "repeat_friday"
    case repeatSaturday = "repeat_saturday"
    case repeatFrequency = "repeat_frequency"
    case repeatCountOccurrance = "repeat_count_occurrance"
    case practiceID = "practice_id"
  }
}

// MARK: - AddNewSessionResponse
struct AddNewSessionResponse: Codable {
  let status: Int
  let message: String
  let data: [Int]
}



// MARK: - AppointmentsListRequest
struct AppointmentsListRequest: Codable {
  let clientName, appType,statusName,providerName: String
  let locationName, fromDate, toDate: String
  let providerID: String
  let practiceID: String
  
  
  enum CodingKeys: String, CodingKey {
    case clientName
    case appType = "app_type"
    case statusName, locationName, fromDate, toDate,providerName
    case providerID = "provider_id"
    case practiceID = "practice_id"
    
  }
}

/*// MARK: - AppointmentsListResponse
 struct AppointmentsListResponse: Codable {
 let status: Int?
 let message: String?
 let data: [AppointmentsListData]?
 }
 
 // MARK: - Datum
 struct AppointmentsListData: Codable {
 let appID: Int?
 let appType: String?
 let sessionCount: Int?
 let clientName: String?
 let authNum: String?
 let activity: String?
 let providerName: String?
 let phoneMobile: String?
 let fromDate, fromTime, toTime, hours: String?
 let appStatus: String?
 let loc: String?
 let address: String?
 
 enum CodingKeys: String, CodingKey {
 case appID
 case appType = "app_type"
 case sessionCount = "session_count"
 case clientName
 case authNum = "auth_num"
 case activity, providerName
 case phoneMobile = "phone_mobile"
 case fromDate, fromTime, toTime, hours, appStatus, loc
 case address = "Address"
 }
 }*/


// MARK: - AppointmentsListResponse
struct AppointmentsListResponse: Codable {
  let status: Int?
  let message: String?
  let data: [AppointmentsListData]?
}

// MARK: - Datum
struct AppointmentsListData: Codable {
  let appID: Int?
  let patientName, phoneMobile, phoneHome, address: String?
  let appointment: [AppointmentInfo]?
  
  enum CodingKeys: String, CodingKey {
    case appID
    case patientName = "patient_name"
    case phoneMobile = "phone_mobile"
    case phoneHome = "phone_home"
    case address, appointment
  }
}

// MARK: - Appointment
struct AppointmentInfo: Codable {
  let patInfo: [APatInfo]?
  let locInfo: [ALOCInfo]?
  let appInfo: [AppInfo]?
  
  enum CodingKeys: String, CodingKey {
    case patInfo = "pat_info"
    case locInfo = "loc_info"
    case appInfo = "app_info"
  }
}

// MARK: - AppInfo
struct AppInfo: Codable {
  let id: Int?
  let appType, startDate, endDate, renderedStartDate,renderedEndDate: String
  let  clockIn, clockOut: String?
  let isNotPayable, isNotBillable: Int?
  let patientName, auth, activity, location: String?
  let  provider, desc, status: String
  let patientID, providerID, isDeleted, isPayroll: Int?
  let createdAt, updatedAt,otherLOC,name: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case appType = "app_type"
    case startDate = "start_date"
    case endDate = "end_date"
    case renderedStartDate = "rendered_start_date"
    case renderedEndDate = "rendered_end_date"
    case clockIn = "clock_in"
    case clockOut = "clock_out"
    case isNotPayable = "is_not_payable"
    case isNotBillable = "is_not_billable"
    case patientName = "patient_name"
    case auth, activity, location
    case otherLOC = "other_loc"
    case provider, desc, status
    case patientID = "patient_id"
    case providerID = "provider_id"
    case isDeleted = "is_deleted"
    case isPayroll = "is_payroll"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case name      = "name"
  }
}

// MARK: - LOCInfo
struct ALOCInfo: Codable {
  let id, patientID, home, office: Int?
  let school, community: Int?
  let createdAt, updatedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case patientID = "patient_id"
    case home, office, school, community
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

// MARK: - PatInfo
struct APatInfo: Codable {
  let auths: String?
  let activities: [AActivity]?
}

// MARK: - Activity
struct AActivity: Codable {
  let key: Int?
  let label: String
}







// MARK: - ClientListRequest
struct ClientListRequest: Codable {
  let token: String
  let practiceID: Int
  
  enum CodingKeys: String, CodingKey {
    case token = "_token"
    case practiceID = "practice_id"
  }
}

// MARK: - ClientListResponse
struct ClientListResponse: Codable {
  let status: Int?
  let message: String?
  let data: [PatientDatum]?
}

// MARK: - Datum
struct PatientDatum: Codable {
  let patientID: Int?
  let patientName: String
  let patInfo: [PatInfo]
  let locInfo: [LOCInfo]
  
  enum CodingKeys: String, CodingKey {
    case patientID = "patient_id"
    case patientName = "patient_name"
    case patInfo = "pat_info"
    case locInfo = "loc_info"
  }
}

// MARK: - LOCInfo
struct LOCInfo: Codable {
  let id, patientID, home, office: Int
  let school, community: Int
  let createdAt, updatedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case patientID = "patient_id"
    case home, office, school, community
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}

// MARK: - PatInfo
struct PatInfo: Codable {
  let auths, authsVal: String
  let activities: [Activity]
}

// MARK: - Activity
struct Activity: Codable {
  let key: Int
  let label: String
}


// MARK: - NonBillableClientResponse
struct NonBillableClientResponse: Codable {
  let status: Int?
  let message: String?
  let data: [NonBillableDatum]?
}

// MARK: - Datum
struct NonBillableDatum: Codable {
  let patientInfo: [PatientInfo]
  let auth: String?
  
  enum CodingKeys: String, CodingKey {
    case patientInfo = "patient_info"
    case auth
  }
}

// MARK: - PatientInfo
struct PatientInfo: Codable {
  let key: Int?
  let label: String?
  let id: Int
  let fullName, dob, gender, relationship: String
  let ssn: String?
  let martialStatus, medicalRecord, employment, employer,authoNo: String?
  let reference: String?
  let isActive, nonBillableClient, isDeleted: Int?
  let addrStreet1: String?
  let addrStreet2: String?
  let addrCity, addrState: String?
  let addrCountry: String?
  let addrZip: String?
  let email, phoneHome, phoneWork, phoneMobile: String?
  let notifyemail, notifyPhone, isFinancialResp, primaryCarePhy: Int?
  let referringPhy, referringNpi: String?
  let defaultServiceLOC, chartNum: String?
  let emergencyContact, emergencyPhone, emergencyEmail: String?
  let createdBy, lastEditedBy: Int?
  let conduct: String?
  let practiceID: Int?
  let createdAt, updatedAt: String?
  
  enum CodingKeys: String, CodingKey {
    case key, label, id
    case fullName = "full_name"
    case dob, gender, relationship, ssn
    case martialStatus = "martial_status"
    case medicalRecord = "medical_record"
    case employment, employer, reference,authoNo
    case isActive = "is_active"
    case nonBillableClient = "non_billable_client"
    case isDeleted = "is_deleted"
    case addrStreet1 = "addr_street1"
    case addrStreet2 = "addr_street2"
    case addrCity = "addr_city"
    case addrState = "addr_state"
    case addrCountry = "addr_country"
    case addrZip = "addr_zip"
    case email
    case phoneHome = "phone_home"
    case phoneWork = "phone_work"
    case phoneMobile = "phone_mobile"
    case notifyemail
    case notifyPhone = "notify_phone"
    case isFinancialResp = "is_financial_resp"
    case primaryCarePhy = "primary_care_phy"
    case referringPhy = "referring_phy"
    case referringNpi = "referring_npi"
    case defaultServiceLOC = "default_service_loc"
    case chartNum = "chart_num"
    case emergencyContact = "emergency_contact"
    case emergencyPhone = "emergency_phone"
    case emergencyEmail = "emergency_email"
    case createdBy = "created_by"
    case lastEditedBy = "last_edited_by"
    case conduct
    case practiceID = "practice_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
  }
}



// MARK: - AppointmentUpdateRequest
struct AppointmentUpdateRequest: Codable {
  let appType, appID, status, fromTime: String
  let toTime, breakTime, activity, notes: String
  let imgSign: String
  let practiceID: Int
  let providerID:Int
  let providerName:String
  let location:String
  
  enum CodingKeys: String, CodingKey {
    case appType = "app_type"
    case appID, status
    case fromTime = "from_time"
    case toTime = "to_time"
    case breakTime = "break_time"
    case activity, notes
    case imgSign = "img_sign"
    case practiceID = "practice_id"
    case providerID = "provider_id"
    case providerName = "provider_name"
    case location = "loc"
    
  }
}

// MARK: - AppointmentUpdateResponse
struct AppointmentUpdateResponse: Codable {
  let status: Int
  let message: String
  let data: [ String]?
}

// MARK: - AppointmentMobileMapAddRequest
struct AppointmentMobileMapAddRequest: Codable {
    let app_id, degrees, is_end: String
}

// MARK: - AppointmentMobileMapAddResponse
struct AppointmentMobileMapAddResponse: Codable {
  let status: Int
  let message, data: String?
}

// MARK: - AppointmentUpdateClockRequest
struct AppointmentUpdateClockRequest: Codable {
  let appType, appID, status, fromTime: String
  let toTime, breakTime, activity, notes: String
  let imgSign: String
  let clockIn: String
  let clockOut: String
  let practiceID: String
  let providerID:String
  let providerName:String
  let location:String
  
  enum CodingKeys: String, CodingKey {
    case appType = "app_type"
    case appID, status
    case fromTime = "from_time"
    case toTime = "to_time"
    case breakTime = "break_time"
    case activity, notes
    case imgSign = "img_sign"
    case practiceID = "practice_id"
    case providerID = "provider_id"
    case clockIn = "clock_in"
    case clockOut = "clock_out"
    case providerName = "provider_name"
    case location = "loc"
}
}
