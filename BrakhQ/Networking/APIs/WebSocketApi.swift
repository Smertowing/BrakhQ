//
//  WebSocketApi.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/9/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

enum WSEvents: String {
	case regStart = "REG_START"
	case regEnd = "REG_END"
	case placeTake = "PLACE_TAKE"
	case placeFree = "PLACE_FREE"
	case queueChange = "QUEUE_CHANGE"
	case queueMix = "QUEUE_MIX"
}

struct WebSockerResponse: Mappable {
    
	let event: WSEvents
	let queue: Queue?
	let place: Place?
	
	init(map: Mapper) throws {
		try event = map.from("event")
		queue = map.optionalFrom("queue")
		place = map.optionalFrom("place")
	}

}
