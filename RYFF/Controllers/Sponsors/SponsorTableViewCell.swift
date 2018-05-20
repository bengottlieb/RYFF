//
//  SponsorTableViewCell.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Hoard

class SponsorTableViewCell: UITableViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var detailsLabel: UILabel!
	@IBOutlet var sponsorImageView: HoardImageView!
	
	var sponsor: Sponsor? { didSet { self.updateUI() }}
	
	override func awakeFromNib() {
		self.selectionStyle = .none
	}
	
	func updateUI() {
		guard let sponsor = self.sponsor else { return }
		
		self.nameLabel.text = sponsor.name
		self.detailsLabel.text = sponsor.details

		self.sponsorImageView.url = URL(string: sponsor.image_url)
	}
}
