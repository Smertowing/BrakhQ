//
//  NetworkErrorsEnums.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 7/4/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case unknownError
	case connectionError
	case invalidCredentials
	case invalidRequest
	case notFound
	case invalidResponse
	case serverError
	case serverUnavailable
	case timeOut
	case unsuppotedURL
}
