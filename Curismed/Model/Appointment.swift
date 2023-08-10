
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

struct AddBillableAppointmentRequest: Codable {
    let billable, clientID, authorizationID, activityID: Int?
    let providerID, location, daily: Int?
    let fromTime, formTimeSession, toTimeSession, status, endDate: String?
    let chkrecurrence: Int?
    let dayName: [String]?

    enum CodingKeys: String, CodingKey {
        case billable
        case clientID = "client_id"
        case authorizationID = "authorization_id"
        case activityID = "activity_id"
        case providerID = "provider_id"
        case location
        case fromTime = "from_time"
        case formTimeSession = "form_time_session"
        case toTimeSession = "to_time_session"
        case status, chkrecurrence, daily
        case endDate = "end_date"
        case dayName = "day_name"
    }
}

struct AddNonBillableAppointmentRequest: Codable {
    let billable: Int?
    let providerMulID: [Int]?
    let location: Int?
    let fromTime, formTimeSession, toTimeSession, status: String?
    let chkrecurrence, daily: Int?
    let endDate: String?
    let dayName: [String]?
    
    enum CodingKeys: String, CodingKey {
        case billable
        case providerMulID = "provider_mul_id"
        case location
        case fromTime = "from_time"
        case formTimeSession = "form_time_session"
        case toTimeSession = "to_time_session"
        case status, chkrecurrence, daily
        case endDate = "end_date"
        case dayName = "day_name"
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
//struct AppointmentsListResponse: Codable {
//  let status: Int?
//  let message: String?
//  let data: [AppointmentsListData]?
//}
//
//// MARK: - Datum
//struct AppointmentsListData: Codable {
//  let appID: Int?
//  let patientName, phoneMobile, phoneHome, address: String?
//  let appointment: [AppointmentInfo]?
//
//  enum CodingKeys: String, CodingKey {
//    case appID
//    case patientName = "patient_name"
//    case phoneMobile = "phone_mobile"
//    case phoneHome = "phone_home"
//    case address, appointment
//  }
//}
//
//// MARK: - Appointment
//struct AppointmentInfo: Codable {
//  let patInfo: [APatInfo]?
//  let locInfo: [ALOCInfo]?
//  let appInfo: [AppInfo]?
//
//  enum CodingKeys: String, CodingKey {
//    case patInfo = "pat_info"
//    case locInfo = "loc_info"
//    case appInfo = "app_info"
//  }
//}
//
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
  let key: String?
  let label: String
}


// MARK: - AppointmentsListRequest
struct AppointmentsListResponse: Codable {
    let status, message, retrievedAt: String?
    let appointments: Appointments?

    enum CodingKeys: String, CodingKey {
        case status, message
        case retrievedAt = "retrieved_at"
        case appointments
    }
}

// MARK: - Appointments
struct Appointments: Codable {
    let currentPage: Int?
    let data: [AppointmentsListData]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct AppointmentsListData: Codable {
    let sessionID: Int?
    let billable: String?
    let patientID, authID, serviceID, insuranceID: Int?
    let providerID, sessionTimeDuration: Int?
    let sessionStartDateTimeUTC, sessionEndDateTimeUTC, cptCode, sessionStatus: String?
    let sessionCreatedDateTimeUTC, sessionLastUpdatedDateTimeUTC, patientName, serviceName: String?

    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case billable
        case patientID = "patient_id"
        case authID = "auth_id"
        case serviceID = "service_id"
        case insuranceID = "insurance_id"
        case providerID = "provider_id"
        case sessionTimeDuration = "session_time_duration"
        case sessionStartDateTimeUTC = "session_start_date_time_UTC"
        case sessionEndDateTimeUTC = "session_end_date_time_UTC"
        case cptCode = "cpt_code"
        case sessionStatus = "session_status"
        case sessionCreatedDateTimeUTC = "session_created_date_time_UTC"
        case sessionLastUpdatedDateTimeUTC = "session_last_updated_date_time_UTC"
        case patientName = "patient_name"
        case serviceName = "service_name"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
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

// MARK: - PatientListModel
struct PatientListModel: Codable {
    let status, message: String?
    let CommonData: [CommonData]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case CommonData = "patient_data"
    }
}

// MARK: - PatientDatum
struct CommonData: Codable {
    let id: Int?
    let text: String?
}

// MARK: - PatientListModel
struct ProviderListModel: Codable {
    let status, message: String?
    let providerData: [CommonData]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case providerData = "provider_data"
    }
}

// MARK: - PointOfServiceModel
struct PointOfServiceModel: Codable {
    let status, message: String?
    let pointOfService: [PointOfService]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case pointOfService = "point_of_service"
    }
}

// MARK: - PointOfService
struct PointOfService: Codable {
    let id: Int?
    let posName, posCode: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posName = "pos_name"
        case posCode = "pos_code"
    }
}

// MARK: - AppointmentStatusModel
struct AppointmentStatusModel: Codable {
    let status, message: String?
    let statusList: [String]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case statusList = "status_list"
    }
}

struct AuthByClientIdRequest: Codable {
    let client_id: Int
}

struct ActivityByAuthIdRequest: Codable {
    let authorization_id: Int
}

// MARK: - AuthorizationModel
struct AuthorizationModel: Codable {
    let status, message: String?
    let authorizationsData: [AuthorizationsDatum]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case authorizationsData = "authorizations_data"
    }
}

// MARK: - AuthorizationsDatum
struct AuthorizationsDatum: Codable {
    let id, isValid: Int?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case id
        case isValid = "is_valid"
        case text
    }
}

// MARK: - ActivityServiceModel
struct ActivityServiceModel: Codable {
    let status, message: String?
    let serviceData: [CommonData]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case serviceData = "service_data"
    }
}

struct AppointmentModel: Codable {
    let status, message: String?
}

// MARK: - UpdateAppointmentRequest
struct UpdateAppointmentRequest: Codable {
    let appID, clientID, authorizationID, activityID: Int?
    let providerID, location: Int?
    let fromTime, formTimeSession, toTimeSession, status: String?

    enum CodingKeys: String, CodingKey {
        case appID = "app_id"
        case clientID = "client_id"
        case authorizationID = "authorization_id"
        case activityID = "activity_id"
        case providerID = "provider_id"
        case location
        case fromTime = "from_time"
        case formTimeSession = "form_time_session"
        case toTimeSession = "to_time_session"
        case status
    }
}
