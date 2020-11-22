//
//  DatabaseProtocol.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 19/11/20.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case users
    case events
    case sports
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    //    func onTeamChange(change: DatabaseChange, teamHeroes: [SuperHero])
    //    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero])
    func onEventListChange(change: DatabaseChange, events: [Events])
    func onSportListChange(change: DatabaseChange, sports: [Sports])
    //func onUserListChange(change: DatabaseChange, sports: [Sports])
}

protocol DatabaseProtocol: AnyObject {
    //var defaultTeam: Team {get}
    
    func cleanup()
    func addUser(firstName: String, LastName: String, gender: String, dateOfBirth: Date, address: String, state: String, postcode: Int, registerationDate: Date, profileImg: String, uuid: String) -> Users
    func addEvent(eventName: String, eventDateTime: Date, numberOfPlayers: Int, locationName: String, long: Double, lat: Double, annotationImg: String, status: String, minNumPlayers: Int, sport: String) -> Events
    func addSport(sportName: String, sportsImg: String) -> Sports
    func addSportToUser(sport: Sports, user: Users) -> Bool
    func addEventToUser(event: Events, user: Users) -> Bool
    func addUserToEvents(user: Users, event: Events) -> Bool
    func addSportToEvent(sport: Sports, event: Events) -> Bool
    func deleteUser(user: Users)
    func deleteEvent(event: Events)
    func deleteSport(sport: Sports)
    //    func removeHeroFromTeam(hero: SuperHero, team: Team)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
