//
//  WebSockets.swift
//  BrakhQ
//
//  Created by Kiryl Holubeu on 5/12/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import Starscream

fileprivate enum WSConnectionType {
	case url
	case id
}

protocol WebSocketModelDelegate: class {
	
	func webSocketModel(isListening: Bool)
	func regStarts()
	func regEnds()
	func take(place: Place)
	func free(place: Place)
	func changed(queue: Queue)
	func mixed(queue: Queue)
	func webSocketModel(didRecievedError: String)
}

final class WebSocketModel: WebSocketDelegate {
	
	weak var delegate: WebSocketModelDelegate?
	
	var socket: WebSocket!
	private let connectionType: WSConnectionType
	var id: Int!
	var url: String!
	
	init(queueId: Int) {
		connectionType = .id
		id = queueId
		socket = WebSocket(url: URL(string: WSHost.url.rawValue)!)
		socket.delegate = self
		socket.connect()
	}
	
	init(queueUrl: String) {
		connectionType = .url
		url = queueUrl
		socket = WebSocket(url: URL(string: WSHost.url.rawValue)!)
		socket.delegate = self
		socket.connect()
	}
	
	var isConnected: Bool {
		get {
			return socket.isConnected
		}
	}

	func disconnect() {
		socket.disconnect()
	}
	
	func websocketDidConnect(socket: WebSocketClient) {
		switch connectionType {
		case .url:
			socket.write(data: try! JSONEncoder().encode(WebSocketConnectByURL(url: url)))
		case .id:
			socket.write(data: try! JSONEncoder().encode(WebSocketConnectById(id: id)))
		}
		
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		delegate?.webSocketModel(isListening: false)
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		if text == "Ok" {
			delegate?.webSocketModel(isListening: true)
		} else if let result = text.parse(to: WebSocketResponse.self) {
			switch result.event {
			case .regStart:
				delegate?.regStarts()
			case .regEnd:
				delegate?.regEnds()
			case .placeTake:
				delegate?.take(place: result.place!)
			case .placeFree:
				delegate?.free(place: result.place!)
			case .queueChange:
				delegate?.changed(queue: result.queue!)
			case .queueMix:
				delegate?.mixed(queue: result.queue!)
			}
		} else {
			delegate?.webSocketModel(didRecievedError: "Invalid server response")
		}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print(data)
	}

}
