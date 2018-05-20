//
//  AnnouncementsViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.register(cellClass: AnnouncementTableViewCell.self)
		self.title = "Announcements"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DataStore.instance.cache.announcements.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncementTableViewCell.identifier, for: indexPath) as! AnnouncementTableViewCell
		let announcement = DataStore.instance.cache.announcements[indexPath.row]
		
		cell.announcement = announcement
		return cell
	}
	
}
