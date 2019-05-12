//
//  WSEnums.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/12/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

public enum WSEvents: String, Codable {
	case regStart = "REG_START"
	case regEnd = "REG_END"
	case placeTake = "PLACE_TAKE"
	case placeFree = "PLACE_FREE"
	case queueChange = "QUEUE_CHANGE"
	case queueMix = "QUEUE_MIX"
}

public enum WSHost: String, Codable {
	case url = "wss://queue-api.brakh.men/ws/queues"
}
