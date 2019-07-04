//
//  NotificationsProxy.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Moya

extension NetworkingManager {

	func subscribeOnNotifications(result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		notificationsProvider.request(.subscribe) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				if error.response?.statusCode == 401 {
					return result(.failure(.invalidCredentials))
				} else {
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func unsubscribeFromNotifications(result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		notificationsProvider.request(.unsubscribe) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				if error.response?.statusCode == 401 {
					return result(.failure(.invalidCredentials))
				} else {
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
	func testNotifications(result: @escaping (Result<(Bool), NetworkError>) -> Void) {
		notificationsProvider.request(.test) { (answer) in
			switch answer {
			case .success(_):
				return result(.success(true))
			case .failure(let error):
				if error.response?.statusCode == 401 {
					return result(.failure(.invalidCredentials))
				} else {
					return result(.failure(.unknownError))
				}
			}
		}
	}
	
}
