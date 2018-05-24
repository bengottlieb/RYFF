//
//  TeamTableViewCell.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Hoard

class TeamTableViewCell: UITableViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var coachLabel: UILabel!
	@IBOutlet var teamImageView: HoardImageView!

	var team: Team? { didSet { self.updateUI() }}

	override func awakeFromNib() {
	}
	
	func updateUI() {
		guard let team = self.team else { return }
		
		self.nameLabel.text = team.nameOnly
		self.coachLabel.text = team.coachName

		self.teamImageView.url = URL(string: team.logo)
	}
}
