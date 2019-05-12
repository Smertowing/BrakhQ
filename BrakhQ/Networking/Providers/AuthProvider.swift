//
//  AuthProvider.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Moya

enum AuthProvider {
	case auth(password: String, username: String)
	case checkToken(token: String)
	case updateToken(refreshToken: String, tokenType: TokenType)
	case authVK(callback: String)
}

extension AuthProvider: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://queue-api.brakh.men")!
	}
	
	var path: String {
		switch self {
		case .auth:
			return "/api/auth"
		case .checkToken:
			return "/api/auth/checkToken"
		case .updateToken:
			return "/api/auth/token"
		case .authVK:
			return "/api/auth/vk"
		}
	}
	
	var method: Method {
		return .get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case .auth(let password, let username):
			return .requestParameters(
				parameters: [
					"password": password,
					"username": username
				],
				encoding: URLEncoding.default
			)
		case .checkToken(let token):
			return .requestParameters(
				parameters: [
					"token": token
				],
				encoding: URLEncoding.default
			)
		case .updateToken(let refreshToken, let tokenType):
			return .requestParameters(
				parameters: [
					"refreshToken": refreshToken,
					"tokenType": tokenType
				],
				encoding: URLEncoding.default
			)
		case .authVK(let callback):
			return .requestParameters(
				parameters: [
					"callback": callback
				],
				encoding: URLEncoding.default
			)
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
}
