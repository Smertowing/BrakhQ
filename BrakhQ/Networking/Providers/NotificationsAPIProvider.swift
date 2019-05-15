//
//  NotificationsAPIProvider.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/15/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Moya

enum NotificationsAPIProvider {
	case subscribe(token: String)
	case unsubscribe
	case test
}

extension NotificationsAPIProvider: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://queue-api.brakh.men")!
	}
	
	var path: String {
		switch self {
		case .subscribe:
			return "/notifications"
		case .unsubscribe:
			return "/notifications"
		case .test:
			return "/notifications/test"
		}
	}
	
	var method: Method {
		switch self {
		case .subscribe:
			return .post
		case .unsubscribe:
			return .delete
		case .test:
			return .get
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self {
		case .subscribe(let token):
			return .requestParameters(
				parameters: [
					"token": token,
					"type": "APPLE_TOKEN"
				],
				encoding: URLEncoding.default
			)
		case .unsubscribe:
			return .requestParameters(
				parameters: [
					"type": "APPLE_TOKEN"
				],
				encoding: URLEncoding.default
			)
		case .test:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		return ["Authorization": AuthManager.shared.token ?? ""]
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
}
