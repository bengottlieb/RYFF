//
//  Announcement.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug

struct Announcement: IDBasedItem, Codable {
	var id: String
	let dt: Date
	let title: String
	let content: String

	static func fetch(completion: @escaping ([Announcement]?) -> Void) {
		let url = Server.instance.buildURL(for: "announcements")
		Connection(url: url)!.completion { conn, data in
			do {
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(DateFormatter.scheduleFormatter)
				let payload = try decoder.decode(Announcement.Payload.self, from: data.data)
				completion(payload.announcements)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding announcements")
				completion(nil)
			}
		}.error { conn, error in
			ErrorHandler.instance.handle(error, note: "downloading announcements")
			completion(nil)
		}
	}
	
	
	struct Payload: Codable {
		var announcements: [Announcement]
	}

}
