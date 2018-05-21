//
//  SchdeuleViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController {
	var schedule: [ScheduledGame] = []
	var team: Team!
	
	convenience init(team: Team) {
		self.init(style: .plain)
		self.schedule = DataStore.instance.cache.teamSchedules[team.id] ?? []
		self.team = team
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = 100
		self.tableView.register(cellClass: ScheduleTableViewCell.self)
		self.title = self.team.nameOnly + " Schedule"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.schedule.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
		let scheduledGame = self.schedule[indexPath.row]
		
		cell.scheduledGame = scheduledGame
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}

