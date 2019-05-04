//
//  User.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

struct User: Mappable {
    
	let avatar: String?
	let id: Int?
	let name: String?
	
	init(map: Mapper) throws {
		avatar = map.optionalFrom("avatar")
		try id = map.from("id")
		try name = map.from("url")
	}
    
}
