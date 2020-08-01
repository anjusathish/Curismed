//
//  User.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 22/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    let isSuccess: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "isSuccess"
        case message = "message"
    }
}

//struct LoginResponse: Codable {
//    let isSuccess: Bool
//    let message: String?
//    let data: User?
//
//    enum CodingKeys: String, CodingKey {
//        case isSuccess = "isSuccess"
//        case message = "message"
//        case data
//    }
//}





// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Int?
    let message: String?
    let data: User?
}

// MARK: - DataClass
struct User: Codable {
    let providerID: Int?
    let providerName, sessionToken, role: String?
    let baseURL: String?
    let practiceID: Int?
    let practiceName: String?

    enum CodingKeys: String, CodingKey {
        case providerID = "provider_id"
        case providerName = "provider_name"
        case sessionToken = "session_token"
        case role
        case baseURL = "base_url"
        case practiceID = "practice_id"
        case practiceName = "practice_name"
    }
}



// MARK: - ForgotpasswordResponse
struct ForgotpasswordResponse: Codable {
    let status, email: String
}


struct NewFeatureResponse : Codable{
    let isSuccess: Bool?
    let message: String?
    let data: [NewFeature]
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "isSuccess"
        case message = "message"
        case data
    }
}

struct NewFeature : Codable{
    let featureId : Int
    let description : String
    let isActive : Bool
    let date : String
    
    enum CodingKeys: String, CodingKey{
        case featureId = "featureId"
        case description = "description"
        case isActive = "isActive"
        case date = "date"
    }
}
