//
//  UserAPIProvider.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Moya

enum UserAPIProvider {
	case getUser(id: Int)
	case getUserByUsername(username: String)
	case updateUser(name: String, email: String)
	case updatePassword(password: String)
	case getQueuesCreatedBy(userId: Int)
	case getQueuesUsedBy(userId: Int)
	case register(username: String, password: String, email: String, name: String)
}

extension UserAPIProvider: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://queue-api.brakh.men")!
	}
	
	var path: String {
		switch self {
		case .getUser:
			return "/api/user"
		case .getUserByUsername:
			return "/api/user"
		case .updateUser, .updatePassword:
			return "/api/user"
		case .getQueuesCreatedBy(let userId):
			return "/api/users/\(userId)/queues/created"
		case .getQueuesUsedBy(let userId):
			return "/api/users/\(userId)/queues/used"
		case .register:
			return "/api/users/registration"
		}
	}
	
	var method: Method {
		switch self {
		case .getUser, .getUserByUsername, .getQueuesCreatedBy, .getQueuesUsedBy:
			return .get
		case .updateUser, .updatePassword:
			return .put
		case .register:
			return .post
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case .getUser(let id):
			
			return .requestParameters(
				parameters: [
					"id": id
				],
				encoding: URLEncoding.default
			)
		case .getUserByUsername(let username):
			
			return .requestParameters(
				parameters: [
					"username": username
				],
				encoding: URLEncoding.default
			)
		case .updateUser(let name, let email):
			return .requestParameters(
				parameters: [
					"name": name,
					"email": email
				],
				encoding: JSONEncoding.default
			)
		case .updatePassword(let password):
			return .requestParameters(
				parameters: [
					"password": password
				],
				encoding: JSONEncoding.default
			)
		case .getQueuesCreatedBy(_):
			return .requestPlain
		case .getQueuesUsedBy(_):
			return .requestPlain
		case .register(let username, let password, let email, let name):
			return .requestParameters(
				parameters: [
					"username": username,
					"password": password,
					"email": email,
					"name": name
				],
				encoding: JSONEncoding.default
			)
		}
	}
	
	var headers: [String : String]? {
		switch self {
		case .register:
			return ["Content-Type": "application/json"]
		case .getUser, .getUserByUsername,  .getQueuesCreatedBy, .getQueuesUsedBy:
			return ["Authorization": "\(AuthManager.shared.token ?? "")"]
		case .updateUser, .updatePassword:
			return ["Authorization": "\(AuthManager.shared.token ?? "")",
							"Content-Type": "application/json"]
		}
	}
	
	var validationType: ValidationType {
		return .successCodes
	}

}
