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
	var teams: [Team] = [] { didSet { self.tableView.reloadData() }}
	var searchResults: [Team]? { didSet { self.tableView.reloadData() }}
	
	var displayedTeams: [Team] { return self.searchResults ?? self.teams }
	
	convenience init(division: Division, kind: DivisionsViewController.Kind) {
		self.init(style: .plain)
		self.kind = kind
		self.division = division
		self.teams = division.teams
	}
	
	var searchController: UISearchController?
	var searchContainer: UIView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.register(cellClass: TeamTableViewCell.self)
		self.title = self.division.name
		
		self.searchContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 56))
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController?.delegate = self
		self.searchController?.searchResultsUpdater = self
		self.searchController?.dimsBackgroundDuringPresentation = false
		self.definesPresentationContext = true
		
		self.searchContainer.addSubview(self.searchController!.searchBar)
		self.tableView.tableHeaderView = self.searchContainer
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.displayedTeams.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier, for: indexPath) as! TeamTableViewCell
		let team = self.displayedTeams[indexPath.row]
		
		cell.team = team
		cell.accessoryType = .disclosureIndicator

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let team = self.displayedTeams[indexPath.row]

		switch self.kind {
		case .teams:
			let controller = TeamDetailsViewController.controller(with: team)
			
			self.navigationController?.pushViewController(controller, animated: true)

		case .schedule:
			let controller = ScheduleViewController(team: team)
			
			self.navigationController?.pushViewController(controller, animated: true)
			
		default: break
		}

	}
	
}

extension TeamsViewController: UISearchControllerDelegate {
	public func willDismissSearchController(_ searchController: UISearchController) {
		self.searchResults = nil
	}
}

extension TeamsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text?.lowercased(), !text.isEmpty else { return }
		
		let found = self.teams.filter { $0.name.lowercased().contains(text) }
		
		self.searchResults = found
	}
}
