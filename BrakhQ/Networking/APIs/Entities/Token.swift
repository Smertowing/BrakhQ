//
//  Token.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

struct Token: Mappable {
    
	let token: String
	
	init(map: Mapper) throws {
		try token = map.from("token")
	}
    
}
