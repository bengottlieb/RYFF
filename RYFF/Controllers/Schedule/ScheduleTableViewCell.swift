//
//  ScheduleTableViewCell.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Gulliver
import MapKit

class ScheduleTableViewCell: UITableViewCell {
	var scheduledGame: ScheduledGame? { didSet { self.updateUI() }}
	
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var fieldLabel: UILabel!
	@IBOutlet var teamsLabel: UILabel!
	
	func updateUI() {
		guard let game = self.scheduledGame else { return }
		
		self.dateLabel.text = game.dt.localTimeString(dateStyle: .short, timeStyle: .short)
		self.fieldLabel.text = "Field: " + game.field_name
		
		let font = UIFont.systemFont(ofSize: 15)
		let string = NSMutableAttributedString(string: game.away_team_name, attributes: [.font: font])
		string.append(string: "\nvs.\n")
		string.append(string: game.home_team_name)
		
		self.teamsLabel.attributedText = string
	}
	
	@IBAction func showMap() {
		guard let game = self.scheduledGame, let lat = Double(game.field_lat), let lon = Double(game.field_long) else { return }
		let controller = MapViewController(lat: lat, lon: lon)
		controller.title = "Field: " + game.field_name
		self.viewController?.navigationController?.pushViewController(controller, animated: true)
	}
}
