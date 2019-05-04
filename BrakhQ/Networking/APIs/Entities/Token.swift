//
//  Token.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

enum TokenType: String {
    case authentication = "AUTHENTICATION_TOKEN"
    case refresh = "REFRESH_TOKEN"
    case undefined = "UNDEFINED_TOKEN"
}

struct Token: Mappable {
    
    let token: String
    
    init(map: Mapper) throws {
        try token = map.from("token")
    }
    
}
