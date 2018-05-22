//
//  StandingsHeaderView.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/22/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

class StandingsHeaderView: UIView {
	static let height: CGFloat = 27
	
	class func createHeaderView(in: UITableView) -> StandingsHeaderView {
		let xib = UINib(nibName: "StandingsHeaderView", bundle: nil)
		
		return xib.instantiate(withOwner: nil, options: nil).first as! StandingsHeaderView
	}
}
