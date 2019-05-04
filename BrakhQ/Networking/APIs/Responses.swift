//
//  Responses.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

struct ResponseState: Mappable {
    
	let success: Bool
	let message: String?
	
	init(map: Mapper) throws {
		try success = map.from("success")
		message = map.optionalFrom("message")
	}
    
}

struct ResponseStateRegistration: Mappable {
    
	let success: Bool
	let errors: [String:String]?
	
	init(map: Mapper) throws {
		try success = map.from("success")
		errors = map.optionalFrom("errors")
	}
    
}

struct TokensResponse: Mappable {
    
	let refreshToken: String
	let success: Bool
	let token: String
	
	init(map: Mapper) throws {
		try refreshToken = map.from("refreshToken")
		try success = map.from("success")
		try token = map.from("token")
	}
    
}

struct TokenValidationResponse: Mappable {
    
	let expired: Bool
	let expires: String
	let type: TokenType
	let valid: Bool
	
	init(map: Mapper) throws {
		try expired = map.from("expired")
		try expires = map.from("expires")
		try type = map.from("type")
		try valid = map.from("valid")
	}
    
}

struct ModelResponseQueue: Mappable {
    
	let message: String
	let response: Queue?
	let success: Bool
	
	init(map: Mapper) throws {
		try message = map.from("message")
		response = map.optionalFrom("response")
		try success = map.from("success")
	}
    
}

struct ModelResponseUser: Mappable {
    
	let message: String
	let response: User?
	let success: Bool
	
	init(map: Mapper) throws {
		try message = map.from("message")
		response = map.optionalFrom("response")
		try success = map.from("success")
	}
    
}

struct ModelResponseCollectionQueue: Mappable {
    
	let message: String
	let response: [Queue]?
	let success: Bool
	
	init(map: Mapper) throws {
		try message = map.from("message")
		response = map.optionalFrom("response")
		try success = map.from("success")
	}
    
}


