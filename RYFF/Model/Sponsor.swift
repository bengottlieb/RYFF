//
//  Sponsor.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug


struct Sponsor: Codable {
	static func fetch(completion: @escaping ([Sponsor]?) -> Void) {
		let url = Server.instance.buildURL(for: "sponsors")
		Connection(url: url)!.completion { conn, data in
			do {
				let payload = try JSONDecoder().decode(Payload.self, from: data.data)
				completion(payload.sponsors)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding sponsors")
				completion(nil)
			}
		}.error { conn, error in
			ErrorHandler.instance.handle(error, note: "downloading sponsors")
			completion(nil)
		}
	}

	let link_url: String
	let image_url: String
	let name: String
	let details: String
	
	
	struct Payload: Codable {
		var sponsors: [Sponsor]
	}
}


