//
//  StandingsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Gulliver

class StandingsViewController: UITableViewController {
	var division: Division!
	var standings: DivisionStandings? { didSet { DispatchQueue.main.async { self.tableView?.reloadData() }}}

	convenience init(division: Division) {
		self.init(style: .plain)
		self.division = division
		self.title = division.name
		self.standings = DataStore.instance.standings(for: division) { standings in
			self.standings = standings
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.register(cellClass: StandingsTableViewCell.self)
		self.tableView.register(cellClass: LoadingTableViewCell.self)
	}

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.standings?.standings.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if self.standings == nil {
			return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath)
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: StandingsTableViewCell.identifier, for: indexPath) as! StandingsTableViewCell
		
		cell.standing = self.standings?.standings[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return StandingsHeaderView.createHeaderView(in: tableView)
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return StandingsHeaderView.height
	}
}
