//
//  WebSocketApi.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

struct WebSocketResponse: Codable {
    
	var event: WSEvents
	var queue: Queue?
	var place: Place?
	
}

struct WebSocketConnectById: Codable {
	
	var id: Int
	
}

struct WebSocketConnectByURL: Codable {
	
	var url: String
	
}
