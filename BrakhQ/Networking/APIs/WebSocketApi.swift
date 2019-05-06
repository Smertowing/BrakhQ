//
//  WebSocketApi.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

enum WSEvents: String, Codable {
	case regStart = "REG_START"
	case regEnd = "REG_END"
	case placeTake = "PLACE_TAKE"
	case placeFree = "PLACE_FREE"
	case queueChange = "QUEUE_CHANGE"
	case queueMix = "QUEUE_MIX"
}

struct WebSockerResponse: Codable {
    
	var event: WSEvents
	var queue: Queue?
	var place: Place?
	
}
