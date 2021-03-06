//
//  MainMenuViewController.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
	enum Option: String { case announcements, schedule, standings, teams, sponsors
		var title: String { return self.rawValue.capitalized }
		var image: UIImage? {
			return UIImage(named: self.rawValue)
		}
		var isAvailable: Bool {
			switch self {
			case .announcements: return DataStore.instance.cache.hasAnnouncementData
			case .schedule: return DataStore.instance.cache.hasDivisionData
			case .standings: return DataStore.instance.cache.hasDivisionData
			case .teams: return DataStore.instance.cache.hasDivisionData
			case .sponsors: return DataStore.instance.cache.hasSponsorData
			}
		}
	}
	
	var menuOptions: [Option] = [.announcements, .schedule, .standings, .teams, .sponsors]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DataStore.Notifications.divisionDataAvailable.watch(self, message: #selector(divisionDataAvailable))
		DataStore.Notifications.sponsorDataAvailable.watch(self, message: #selector(sponsorDataAvailable))
		DataStore.Notifications.announcementDataAvailable.watch(self, message: #selector(announcementDataAvailable))

		let imageView = UIImageView(image: UIImage(named: "nav_image"))
		imageView.contentMode = .scaleAspectFit
		self.navigationItem.titleView = imageView
	}
	
	@objc func divisionDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}
	
	@objc func sponsorDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}
	
	@objc func announcementDataAvailable(note: Notification) {
		self.tableView.reloadData()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch self.menuOptions[indexPath.row] {
		case .announcements:
			self.navigationController?.pushViewController(AnnouncementsViewController(style: .plain), animated: true)
			
		case .teams:
			self.navigationController?.pushViewController(DivisionsViewController(kind: .teams), animated: true)
			
		case .schedule:
			self.navigationController?.pushViewController(DivisionsViewController(kind: .schedule), animated: true)
			
		case .standings:
			self.navigationController?.pushViewController(DivisionsViewController(kind: .standings), animated: true)
			
		case .sponsors:
			self.navigationController?.pushViewController(SponsorsViewController(style: .plain), animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.menuOptions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
		let option = self.menuOptions[indexPath.row]
		let enabled = option.isAvailable
		cell.textLabel?.text = option.title
		cell.imageView?.image = option.image
		cell.textLabel?.alpha = enabled ? 1.0 : 0.35
		cell.imageView?.alpha = enabled ? 1.0 : 0.35

		cell.accessoryType = .disclosureIndicator
		return cell
	}
}
