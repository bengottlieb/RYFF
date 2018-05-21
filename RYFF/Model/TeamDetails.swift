//
//  TeamDetails.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Plug


struct TeamDetails: Codable {
	let id: String
	let name: String
	let division_id: String
	let is_competitive: String
	let logo_filename: String
	let information: String?
	let reg_code: String?
	let division: String
	let coach_name: String
	let coach_email: String
	let coach_phone: String
	
	struct Payload: Codable {
		let team_info: TeamDetails
	}
}

extension Team {
	func fetchInfo(completion: @escaping (TeamDetails?) -> Void) {
		let url = Server.instance.buildURL(for: "team_info", ["team_id": self.id])
		Connection(url: url)!.completion { conn, data in
			do {
				let payload = try JSONDecoder().decode(TeamDetails.Payload.self, from: data.data)
				completion(payload.team_info)
			} catch {
				ErrorHandler.instance.handle(error, note: "decoding team info for \(self)")
				completion(nil)
			}
			}.error { conn, error in
				ErrorHandler.instance.handle(error, note: "downloading team info for \(self)")
				completion(nil)
		}
	}
}
