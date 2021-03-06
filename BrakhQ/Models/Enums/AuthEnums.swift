//
//  AuthEnums.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/6/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

public enum TokenType: String, Codable {
	case authentication = "AUTHENTICATION_TOKEN"
	case refresh = "REFRESH_TOKEN"
	case undefined = "UNDEFINED_TOKEN"
}
