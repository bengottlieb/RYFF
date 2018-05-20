//
//  TeamsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class TeamsViewController: UITableViewController {
	var kind: DivisionsViewController.Kind = .teams
	var division: Division!
	
	convenience init(division: Division, kind: DivisionsViewController.Kind) {
		self.init(style: .plain)
		self.kind = kind
		self.division = division
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.register(cellClass: TeamTableViewCell.self)
		self.title = self.division.name
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.division.teams.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier, for: indexPath) as! TeamTableViewCell
		let team = self.division.teams[indexPath.row]
		
		cell.team = team
		if self.kind == .teams {
			cell.selectionStyle = .none
		}

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.kind == .schedule {
			let team = self.division.teams[indexPath.row]
			let controller = ScheduleViewController(team: team)
			
			self.navigationController?.pushViewController(controller, animated: true)
		}

	}
	
}

