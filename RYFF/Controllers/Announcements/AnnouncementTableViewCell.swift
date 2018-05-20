//
//  AnnouncementTableViewCell.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/20/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit
import Gulliver

class AnnouncementTableViewCell: UITableViewCell {
	@IBOutlet var label: UILabel!
	
	var announcement: Announcement? { didSet { self.updateUI() }}

	func updateUI() {
		guard let ann = self.announcement else { return }
		let attrString = NSMutableAttributedString(string: ann.title, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
		
		attrString.append(string: "\n" + ann.content, attributes: [.font: UIFont.systemFont(ofSize: 14)])
		self.label.attributedText = attrString
	}
}
