//
//  Token.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

struct Token: Codable {
	
	var token: String
	
	init(token: String) {
		self.token = token
	}
	
}
