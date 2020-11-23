//
//  FirebaseController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 19/11/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    //Reference : lab firebase
    //firestore storage for image https://stackoverflow.com/questions/37374868/how-to-get-url-from-firebase-storage-getdownloadurl
    //firestore image https://stackoverflow.com/questions/39398282/retrieving-image-from-firebase-storage-using-swift
    //upload image firestore https://stackoverflow.com/questions/44060518/uploading-image-to-firebase-storage-and-database
    let DEFAULT_USER_NAME = "Sheridan"
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var eventsRef: CollectionReference?
    var sportsRef: CollectionReference?
    var eventList: [Events]
    var sportList: [Sports]
    var userList: [Users]
    
    override init() {
        // To use Firebase in our application we first must run the
        // FirebaseApp configure method
        FirebaseApp.configure()
        // We call auth and firestore to get access to these frameworks
        authController = Auth.auth()
        database = Firestore.firestore()
        eventList = [Events]()
        sportList = [Sports]()
        userList = [Users]()
        
        super.init()
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase authentication failed")
            }
            // Once we have authenticated we can attach our listeners to
            // the firebase firestore
            self.setUpEventListener()
        }
    }
    
    // MARK:- Setup code for Firestore listeners
    
    //gets the events from firestore
    func setUpEventListener() {
        eventsRef = database.collection("event")
        eventsRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseEventsSnapshot(snapshot: querySnapshot)
            self.setUpSportsListener()
        }
    }
    
    //gets the sports from firestore
    func setUpSportsListener() {
        sportsRef = database.collection("sport")
        sportsRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseSportsSnapshot(snapshot: querySnapshot)
            self.setUpUsersListener()
        }
    }
    
    //gets the users from firestore
    func setUpUsersListener() {
        usersRef = database.collection("users")
        usersRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.parseUsersSnapshot(snapshot: querySnapshot)
        }
    }
    
    
    // MARK:- Parse Functions for Firebase Firestore responses
    func parseEventsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let eventID = change.document.documentID
            
            var parsedEvent: Events?
            
            do {
                parsedEvent = try change.document.data(as: Events.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let event = parsedEvent else {
                print("Document doesn't exist")
                return;
            }
            
            event.id = eventID
            if change.type == .added {
                eventList.append(event)
                //print(event.eventName)
            }
            else if change.type == .modified {
                let index = getEventIndexByID(eventID)!
                eventList[index] = event
            }
            else if change.type == .removed {
                if let index = getEventIndexByID(eventID) {
                    eventList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.events ||
                listener.listenerType == ListenerType.all {
                listener.onEventListChange(change: .update, events: eventList)
            }
        }
    }
    
    func parseUsersSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let userID = change.document.documentID
            print(userID)
            
            var parsedUser: Users?
            
            do {
                parsedUser = try change.document.data(as: Users.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let user = parsedUser else {
                print("Document doesn't exist")
                return;
            }
            
            user.id = userID
            if change.type == .added {
                userList.append(user)
            }
            else if change.type == .modified {
                let index = getUserIndexByID(userID)!
                userList[index] = user
            }
            else if change.type == .removed {
                if let index = getUserIndexByID(userID) {
                    userList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.events ||
                listener.listenerType == ListenerType.all {
                listener.onEventListChange(change: .update, events: eventList)
            }
        }
    }
    
    func parseSportsSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            let sportID = change.document.documentID
            print(sportID)
            
            var parsedSport: Sports?
            
            do {
                parsedSport = try change.document.data(as: Sports.self)
            } catch {
                print("Unable to decode hero. Is the hero malformed?")
                return
            }
            
            guard let sport = parsedSport else {
                print("Document doesn't exist")
                return;
            }
            
            sport.id = sportID
            if change.type == .added {
                sportList.append(sport)
            }
            else if change.type == .modified {
                let index = getSportIndexByID(sportID)!
                sportList[index] = sport
            }
            else if change.type == .removed {
                if let index = getSportIndexByID(sportID) {
                    sportList.remove(at: index)
                }
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.events ||
                listener.listenerType == ListenerType.all {
                listener.onSportListChange(change: .update, sports: sportList)
            }
        }
    }
    
    // MARK:- Utility Functions
    func getEventIndexByID(_ id: String) -> Int? {
        if let event = getEventByID(id) {
            return eventList.firstIndex(of: event)
        }
        
        return nil
    }
    
    func getEventByID(_ id: String) -> Events? {
        for event in eventList {
            if event.id == id {
                return event
            }
        }
        
        return nil
    }
    
    func getSportIndexByID(_ id: String) -> Int? {
        if let sport = getSportByID(id) {
            return sportList.firstIndex(of: sport)
        }
        
        return nil
    }
    
    func getSportByID(_ id: String) -> Sports? {
        for sport in sportList {
            if sport.id == id {
                return sport
            }
        }
        return nil
    }
    
    func getUserIndexByID(_ id: String) -> Int? {
        if let user = getUserByID(id) {
            return userList.firstIndex(of: user)
        }
        
        return nil
    }
    
    func getUserByID(_ id: String) -> Users? {
        for user in userList {
            if user.id == id {
                return user
            }
        }
        return nil
    }
    // MARK:- Required Database Functions
    func cleanup() {
        
    }
    
    // add sport to user
    func addSportToUser(sport: Sports, user: Users) -> Bool {
        guard let sportID = sport.id, let userID = user.id else {
            return false
        }
        if let newSportRef = sportsRef?.document(sportID) {
            usersRef?.document(userID).updateData(
                ["sports" : FieldValue.arrayUnion([newSportRef])]
            )
        }
        return true
    }
    
    //add event to user
    func addEventToUser(event: Events, user: Users) -> Bool {
        guard let eventID = event.id, let userID = user.id else {
            return false
        }
        if let newEventRef = eventsRef?.document(eventID) {
            usersRef?.document(userID).updateData(
                ["events" : FieldValue.arrayUnion([newEventRef])]
            )
        }
        return true
    }
    
    // add user to event
    func addUserToEvents(user: Users, event: Events) -> Bool {
        guard let userID = user.id, let eventID = event.id else {
            return false
        }
        if let newUserRef = usersRef?.document(userID) {
            eventsRef?.document(eventID).updateData(
                ["users" : FieldValue.arrayUnion([newUserRef])]
            )
        }
        return true
    }
    
    // add sport to event
    func addSportToEvent(sport: Sports, event: Events) -> Bool {
        guard let sportID = sport.id, let eventID = event.id else {
            return false
        }
        if let newSportRef = sportsRef?.document(sportID) {
            eventsRef?.document(eventID).updateData(
                ["sport" : FieldValue.arrayUnion([newSportRef])]
            )
        }
        return true
    }
    
    
    // adds user to firestore
    func addUser(firstName: String, LastName: String, gender: String, dateOfBirth: String, state: String, postcode: Int, registerationDate: String, profileImg: String, uuid: String) -> Users {
        let user = Users()
        user.firstName = firstName
        user.lastName = LastName
        user.gender = gender
        user.dateOfBirth = dateOfBirth
        user.state = state
        user.postcode = postcode
        user.registerationDate = registerationDate
        user.profileImg = profileImg
        user.uuid = uuid
        
        do {
            if let userRef = try usersRef?.addDocument(from: user) {
                user.id = userRef.documentID
            }
        } catch {
            print("Failed to serialize hero")
        }
        
        return user
    }
    
    //adds events to firestore
    func addEvent(eventName: String, eventDateTime: Date, numberOfPlayers: Int, locationName: String, long: Double, lat: Double, annotationImg: String, status: String, minNumPlayers: Int, sport: String, uuid: String) -> Events {
        let event = Events()
        event.eventName = eventName
        event.eventDateTime = eventDateTime
        event.numberOfPlayers = numberOfPlayers
        event.locationName = locationName
        event.long = long
        event.lat = lat
        event.annotationImg = annotationImg
        event.status = status
        event.minNumPlayers = minNumPlayers
        event.sport = sport
        event.uuid = uuid
        
        do {
            if let eventRef = try eventsRef?.addDocument(from: event) {
                event.id = eventRef.documentID
            }
        } catch {
            print("Failed to serialize hero")
        }
        
        return event
    }
    
    //add sport to firestore
    func addSport(sportName: String, sportsImg: String) -> Sports {
        let sport = Sports()
        sport.sportName = sportName
        sport.sportsImg = sportsImg
        
        do {
            if let sportRef = try sportsRef?.addDocument(from: sport) {
                sport.id = sportRef.documentID
            }
        } catch {
            print("Failed to serialize hero")
        }
        
        return sport
    }
    
    func deleteUser(user: Users) {
        if let userID = user.id {
            usersRef?.document(userID).delete()
        }
    }
    
    func deleteEvent(event: Events) {
        if let eventID = event.id {
            eventsRef?.document(eventID).delete()
        }
    }
    
    func deleteSport(sport: Sports) {
        if let sportID = sport.id {
            sportsRef?.document(sportID).delete()
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == ListenerType.users ||
            listener.listenerType == ListenerType.all {
            listener.onUserListChange(change: .update, users: userList)
        }
        
        if listener.listenerType == ListenerType.events ||
            listener.listenerType == ListenerType.all {
            listener.onEventListChange(change: .update, events: eventList)
        }
        
        if listener.listenerType == ListenerType.sports ||
            listener.listenerType == ListenerType.all {
            listener.onSportListChange(change: .update, sports: sportList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
}
