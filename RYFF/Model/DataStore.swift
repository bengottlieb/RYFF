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
		let maxDivisionCacheAge = TimeInterval.secondsPerDay * 30
		if self.cache.divisionsCachedAt == nil || abs(self.cache.divisionsCachedAt!.timeIntervalSinceNow) > maxDivisionCacheAge {
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
		
		let maxAnnouncementCacheAge = TimeInterval.secondsPerHour * 6
		if self.cache.announcementsCachedAt == nil || abs(self.cache.announcementsCachedAt!.timeIntervalSinceNow) > maxAnnouncementCacheAge {
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
		
		let maxSponsorCacheAge = TimeInterval.secondsPerDay
		if self.cache.sponsorsCachedAt == nil || abs(self.cache.sponsorsCachedAt!.timeIntervalSinceNow) > maxSponsorCacheAge {
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
		
//		if !self.cache.hasFullScheduleData {
//			for div in self.cache.divisions {
//				for team in div.teams {
//					if self.cache.teamSchedules[team.id] == nil {
//						team.fetchSchedule { schedule in
//							if let sched = schedule {
//								self.cache.divisions[div.id]?.teams[team.id]?.scheduleCachedAt = Date()
//								self.cache.teamSchedules[team.id] = sched
//								self.queueCacheSave()
//							}
//							self.fillCache()
//						}
//						return
//					}
//				}
//			}
//		}
//		if !self.hasUpdatedSchedules {
//			self.hasUpdatedSchedules = true
//			Notifications.scheduleDataAvailable.notify()
//		}

//		if !self.cache.hasFullStandingsData {
//			for div in self.cache.divisions {
//				if self.cache.divisionStandings[div.id] == nil {
//					div.fetchStandings { standings in
//						if let stand = standings {
//							self.cache.divisions[div.id]?.standingsCachedAt = Date()
//							self.cache.divisionStandings[div.id] = stand
//							self.queueCacheSave()
//						}
//						self.fillCache()
//					}
//					return
//				}
//			}
//		}
//		if !self.hasUpdatedStandings {
//			self.hasUpdatedStandings = true
//			Notifications.standingDataAvailable.notify()
//		}
	}
	
	func details(for team: Team, completion: @escaping (TeamDetails?) -> Void) -> TeamDetails? {
		if let details = self.cache.teamDetails[team.id], !details.isStale {
			completion(details)
			return details
		}
		
		team.fetchInfo { details in
			self.cache.teamDetails[team.id] = details
			self.queueCacheSave()
			completion(details)
		}
		
		return nil
	}
	
	func schedule(for team: Team, completion: @escaping (TeamSchedule?) -> Void) -> TeamSchedule? {
		if let schedule = self.cache.teamSchedules[team.id], !schedule.isStale {
			completion(schedule)
			return schedule
		}
		
		team.fetchSchedule { sched in
			self.cache.teamSchedules[team.id] = sched
			self.cache.teamSchedules[team.id]?.cachedAt = Date()
			self.queueCacheSave()
			completion(sched)
		}
		
		return nil
	}
	
	func standings(for div: Division, completion: @escaping (DivisionStandings?) -> Void) -> DivisionStandings? {
		if let standings = self.cache.divisionStandings[div.id], !standings.isStale {
			completion(standings)
			return standings
		}
		
		div.fetchStandings { standings in
			self.cache.divisionStandings[div.id] = standings
			self.cache.divisionStandings[div.id]?.cachedAt = Date()
			self.queueCacheSave()
			completion(standings)
		}
		
		return nil
	}

	struct Cache: Codable {
		var divisionsCachedAt: Date?
		var sponsorsCachedAt: Date?
		var announcementsCachedAt: Date?
		
		var teamDetails: [String: TeamDetails] = [:]
		
		var hasDivisionData: Bool { return self.divisions.count > 0 }
		var hasSponsorData: Bool { return self.sponsors.count > 0 }
		var hasAnnouncementData: Bool { return self.announcements.count > 0 }
		var hasStandingsData: Bool { return self.divisionStandings.count > 0 }
		var hasScheduleData: Bool { return self.divisionStandings.count > 0 }

		var hasFullStandingsData: Bool { return self.hasDivisionData && self.divisionStandings.count == self.divisions.count }
		var hasFullScheduleData: Bool { return self.hasDivisionData && self.teamSchedules.count == self.numberOfTeams }
		
		var divisions: [Division] = []
		var divisionStandings: [String: DivisionStandings] = [:]
		var teamSchedules: [String: TeamSchedule] = [:]
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
