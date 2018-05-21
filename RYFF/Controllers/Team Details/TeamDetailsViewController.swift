//
//  TeamDetailsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Gulliver

class TeamDetailsViewController: UITableViewController {
	@IBOutlet var coachNameLabel: UILabel!
	@IBOutlet var coachEmailLabel: UILabel!
	@IBOutlet var coachPhoneLabel: UILabel!

	var team: Team!
	
	class func controller(with team: Team) -> TeamDetailsViewController {
		let controller = self.fromStoryboard()
		
		controller.team = team
		controller.title = team.nameOnly
		return controller
	}
	
	func load(info: TeamDetails?) {
		guard let details = info else { return }

		self.coachNameLabel.text = details.coach_name
		self.coachEmailLabel.text = details.coach_email
		self.coachPhoneLabel.text = details.coach_phone
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let details = DataStore.instance.details(for: self.team) { details in
			DispatchQueue.main.async { self.load(info: details) }
		}
		
		self.coachNameLabel.text = details?.coach_name
		self.coachEmailLabel.text = details?.coach_email
		self.coachPhoneLabel.text = details?.coach_phone
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 3 {
			let controller = ScheduleViewController(team: self.team)
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
}
