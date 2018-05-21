//
//  SchdeuleViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class ScheduleViewController: UITableViewController {
	var schedule: TeamSchedule? { didSet { DispatchQueue.main.async { self.tableView?.reloadData() }}}
	var team: Team!
	
	convenience init(team: Team) {
		self.init(style: .plain)
		self.schedule = DataStore.instance.schedule(for: team) { sched in
			self.schedule = sched
		}
		self.team = team
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = 100
		self.tableView.register(cellClass: ScheduleTableViewCell.self)
		self.tableView.register(cellClass: LoadingTableViewCell.self)
		self.title = self.team.nameOnly + " Schedule"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.schedule?.games.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if self.schedule == nil {
			return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath)
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as! ScheduleTableViewCell
		let scheduledGame = self.schedule?.games[indexPath.row]
		
		cell.scheduledGame = scheduledGame
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
}

