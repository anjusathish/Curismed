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
    let status, accountType, message, accessToken: String?
    let tokenType: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case status
        case accountType = "account_type"
        case message
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, email: String?
    let profilePhotoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case profilePhotoURL = "profile_photo_url"
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
