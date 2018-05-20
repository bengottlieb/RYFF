//
//  DataStore.swift
//  RYFF
//
//  Created by Ben Gottlieb on 5/19/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import Foundation
import Gulliver

class DataStore {
	struct Notifications {
		static let divisionDataAvailable = Notifier("divisionDataAvailable")
		static let scheduleDataAvailable = Notifier("scheduleDataAvailable")
		static let standingDataAvailable = Notifier("standingDataAvailable")
		static let sponsorDataAvailable = Notifier("sponsorDataAvailable")
		static let announcementDataAvailable = Notifier("announcementsDataAvailable")
	}
	static let instance = DataStore()
	
	let cacheURL = FileManager.libraryDirectoryURL.appendingPathComponent("cache.dat")
	var cache = Cache()
	
	var hasUpdatedSchedules = false
	var hasUpdatedStandings = false
	
	init() {
		if let data = try? Data(contentsOf: self.cacheURL), let cache = try? JSONDecoder().decode(Cache.self, from: data) {
			self.cache = cache
		}
		
		self.fillCache()
	}
	
	weak var saveTimer: Timer?
	var queueCount = 0
	func queueCacheSave() {
		self.saveTimer?.invalidate()
		
		self.queueCount += 1
		if self.queueCount > 5 {
			self.queueCount = 0
			self.cache.save(to: self.cacheURL)
		} else {
			self.saveTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
				self.cache.save(to: self.cacheURL)
			}
		}
	}
	
	func fillCache() {
		if !self.cache.hasDivisionData {
			Division.fetch { divisions in
				if let divs = divisions {
					self.cache.divisions = divs
					self.cache.divisionsCachedAt = Date()
					Notifications.divisionDataAvailable.notify()
					self.queueCacheSave()
				}
				self.fillCache()
			}
			return
		}
		
		if !self.cache.hasAnnouncementData {
			Announcement.fetch { announcements in
				if let announce = announcements {
					self.cache.announcementsCachedAt = Date()
					self.cache.announcements = announce
					Notifications.announcementDataAvailable.notify()
					self.queueCacheSave()
				}
				self.fillCache()
			}
			return
		}
		
		if !self.cache.hasSponsorData {
			Sponsor.fetch { sponsors in
				if let spons = sponsors {
					self.cache.sponsors = spons
					self.cache.sponsorsCachedAt = Date()
					Notifications.sponsorDataAvailable.notify()
					self.queueCacheSave()
				}
				self.fillCache()
			}
			return
		}
		
		if !self.cache.hasFullScheduleData {
			for div in self.cache.divisions {
				for team in div.teams {
					if self.cache.teamSchedules[team.id] == nil {
						team.fetchSchedule { schedule in
							if let sched = schedule {
								self.cache.divisions[div.id]?.teams[team.id]?.scheduleCachedAt = Date()
								self.cache.teamSchedules[team.id] = sched
								self.queueCacheSave()
							}
							self.fillCache()
						}
						return
					}
				}
			}
		}
		if !self.hasUpdatedSchedules {
			self.hasUpdatedSchedules = true
			Notifications.scheduleDataAvailable.notify()
		}

		if !self.cache.hasFullStandingsData {
			for div in self.cache.divisions {
				if self.cache.divisionStandings[div.id] == nil {
					div.fetchStandings { standings in
						if let stand = standings {
							self.cache.divisions[div.id]?.standingsCachedAt = Date()
							self.cache.divisionStandings[div.id] = stand
							self.queueCacheSave()
						}
						self.fillCache()
					}
					return
				}
			}
		}
		if !self.hasUpdatedStandings {
			self.hasUpdatedStandings = true
			Notifications.standingDataAvailable.notify()
		}
	}
	
	struct Cache: Codable {
		var divisionsCachedAt: Date?
		var sponsorsCachedAt: Date?
		var announcementsCachedAt: Date?
		
		var hasDivisionData: Bool { return self.divisions.count > 0 }
		var hasSponsorData: Bool { return self.sponsors.count > 0 }
		var hasAnnouncementData: Bool { return self.announcements.count > 0 }
		var hasStandingsData: Bool { return self.divisionStandings.count > 0 }
		var hasScheduleData: Bool { return self.divisionStandings.count > 0 }

		var hasFullStandingsData: Bool { return self.hasDivisionData && self.divisionStandings.count == self.divisions.count }
		var hasFullScheduleData: Bool { return self.hasDivisionData && self.teamSchedules.count == self.numberOfTeams }
		
		var divisions: [Division] = []
		var divisionStandings: [String: [Standing]] = [:]
		var teamSchedules: [String: [ScheduledGame]] = [:]
		var sponsors: [Sponsor] = []
		var announcements: [Announcement] = []

		var numberOfTeams: Int { return self.divisions.reduce(0) { $0 + $1.teams.count }}
		
		func save(to url: URL) {
			if let data = try? JSONEncoder().encode(self) {
				try? data.write(to: url)
			}
		}
	}
}
