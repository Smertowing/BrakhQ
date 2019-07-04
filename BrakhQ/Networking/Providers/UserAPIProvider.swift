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
	case updateAvatar(avatar: Data)
	case getQueuesBy(userId: Int)
	case register(username: String, password: String, email: String, name: String)
}

extension UserAPIProvider: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://queue-api.brakh.men/api/v2")!
	}
	
	var path: String {
		switch self {
		case .getUser, .getUserByUsername:
			return "/user"
		case .updateUser, .updatePassword:
			return "/user"
		case .updateAvatar:
			return "/user/avatar"
		case .getQueuesBy(let userId):
			return "/users/\(userId)/queues"
		case .register:
			return "/users/registration"
		}
	}
	
	var method: Method {
		switch self {
		case .getUser, .getUserByUsername, .getQueuesBy:
			return .get
		case .updateUser, .updatePassword:
			return .put
		case .register, .updateAvatar:
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
		case .updateAvatar(let avatar):
			return .uploadMultipart([Moya.MultipartFormData(provider: .data(avatar), name: "file", fileName: "avatar.png", mimeType: "image/png")])
		case .getQueuesBy:
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
		case .getUser, .getUserByUsername, .getQueuesBy, .updateAvatar:
			return ["Authorization": "\(AuthManager.shared.token ?? "")"]
		case .updateUser, .updatePassword:
			return ["Authorization": "\(AuthManager.shared.token ?? "")",
							"Content-Type": "application/json"]
		}
	}
	
	var validationType: ValidationType {
		switch self {
		case .register:
			return .customCodes([201])
		default:
			return .customCodes([200])
		}
	}

}
