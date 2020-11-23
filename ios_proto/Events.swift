//
//  Events.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 18/11/20.
//

import UIKit

class Events: Codable, Equatable {
    
    var id: String?
    var eventName: String? = ""
    var eventDateTime: Date?
    var numberOfPlayers: Int?
    var locationName: String? = ""
    var long: Double?
    var lat: Double?
    var annotationImg: String? = ""
    var status: String? = ""
    var minNumPlayers: Int?
    var sport: String? = ""
    var uuid: String? = ""
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventName
        case eventDateTime
        case numberOfPlayers
        case locationName
        case long
        case lat
        case annotationImg
        case status
        case minNumPlayers
        case sport
        case uuid
    }
    
    static func == (lhs: Events, rhs: Events) -> Bool {
        return lhs.id == rhs.id
    }
}
