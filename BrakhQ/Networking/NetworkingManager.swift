//
//  NetworkingManager.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Moya

final class NetworkingManager {
	
	static let shared = NetworkingManager()
	
	private init() {}
	
	let authProvider = MoyaProvider<AuthProvider>()
	let notificationsProvider = MoyaProvider<NotificationsAPIProvider>()
	let queueProvider = MoyaProvider<QueueAPIProvider>()
	let userProvider = MoyaProvider<UserAPIProvider>()
	
}
