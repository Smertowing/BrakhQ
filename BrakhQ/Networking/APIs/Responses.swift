//
//  Responses.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

struct ResponseState: Codable {
    
	var success: Bool
	var message: String?
    
}

struct ResponseStateRegistration: Codable {
    
	var success: Bool
	var errors: [String:String]?
    
}

struct AuthResponse: Codable {
	
	var message: String?
	var refreshToken: String?
	var success: Bool
	var token: String?

}

struct TokenValidationResponse: Codable {
    
	var expired: Bool?
	var expires: String?
	var type: TokenType?
	var valid: Bool
    
}

struct ModelResponseQueue: Codable {
    
	var message: String
	var response: Queue?
	var success: Bool
    
}

struct ModelResponseUser: Codable {
    
	var message: String?
	var response: User?
	var success: Bool

}

struct ModelResponseCollectionQueue: Codable {
    
	var message: String
	var response: [Queue]?
	var success: Bool

}


