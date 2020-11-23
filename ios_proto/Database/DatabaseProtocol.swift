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
    func onEventListChange(change: DatabaseChange, events: [Events])
    func onSportListChange(change: DatabaseChange, sports: [Sports])
    func onUserListChange(change: DatabaseChange, users: [Users])
}

protocol DatabaseProtocol: AnyObject {
    
    func cleanup()
    func addUser(firstName: String, LastName: String, gender: String, dateOfBirth: String, state: String, postcode: Int, registerationDate: String, profileImg: String, uuid: String) -> Users
    func addEvent(eventName: String, eventDateTime: Date, numberOfPlayers: Int, locationName: String, long: Double, lat: Double, annotationImg: String, status: String, minNumPlayers: Int, sport: String, uuid: String) -> Events
    func addSport(sportName: String, sportsImg: String) -> Sports
    func addSportToUser(sport: Sports, user: Users) -> Bool
    func addEventToUser(event: Events, user: Users) -> Bool
    func addUserToEvents(user: Users, event: Events) -> Bool
    func addSportToEvent(sport: Sports, event: Events) -> Bool
    func deleteUser(user: Users)
    func deleteEvent(event: Events)
    func deleteSport(sport: Sports)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
