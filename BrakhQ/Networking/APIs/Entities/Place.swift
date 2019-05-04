//
//  Place.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 4/8/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation
import Mapper

struct Place: Mappable {
    
    let place: Int
    let user: User
    
    init(map: Mapper) throws {
        try place = map.from("place")
        try user = map.from("user")
    }
    
}
