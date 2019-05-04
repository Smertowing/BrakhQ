//
//  Queue.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

enum QueueType: String {
	case random = "Random"
	case def = "Default"
}

struct Queue: Mappable {
	
	let busy_places: [Place]
	let description: String
	let event_date: String
	let full: Bool
	let id: Int
	let mixed: Bool
	let name: String
	let owner: User
	let places_count: Int
	let queue_type: QueueType
	let regActive: Bool
	let regEnded: Bool
	let regStarted: Bool
	let reg_end: String
	let reg_start: String
	let url: String
	
	init(map: Mapper) throws {
		try busy_places = map.from("busy_places")
		try description = map.from("description")
		try event_date = map.from("event_date")
		try full = map.from("full")
		try id = map.from("id")
		try mixed = map.from("mixed")
		try name = map.from("name")
		try owner = map.from("owner")
		try places_count = map.from("places_count")
		try queue_type = map.from("queue_type")
		try regActive = map.from("regActive")
		try regEnded = map.from("regEnded")
		try regStarted = map.from("regStarted")
		try reg_end = map.from("reg_end")
		try reg_start = map.from("reg_start")
		try url = map.from("url")
	}
    
}
