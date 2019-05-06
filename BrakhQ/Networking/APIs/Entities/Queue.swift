//
//  Queue.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

struct Queue: Codable {
	
	var busy_places: [Place]
	var description: String
	var event_date: String
	var full: Bool
	var id: Int
	var mixed: Bool
	var name: String
	var owner: User
	var places_count: Int
	var queue_type: QueueType
	var regActive: Bool
	var regEnded: Bool
	var regStarted: Bool
	var reg_end: String
	var reg_start: String
	var url: String
    
}
