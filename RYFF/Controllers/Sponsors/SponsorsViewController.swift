//
//  SponsorsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import SafariServices

class SponsorsViewController: UITableViewController {
	var sponsors: [Sponsor] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.sponsors = DataStore.instance.cache.sponsors
		
		self.tableView.register(cellClass: SponsorTableViewCell.self)
		self.title = "Sponsors"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.sponsors.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SponsorTableViewCell.identifier, for: indexPath) as! SponsorTableViewCell
		let sponsor = self.sponsors[indexPath.row]
		
		cell.sponsor = sponsor
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sponsor = self.sponsors[indexPath.row]
		guard let url = URL(string: sponsor.link_url) else { return }
		let controller = SFSafariViewController(url: url)
		
		self.navigationController?.presentController(controller)
		
	}
	
}

