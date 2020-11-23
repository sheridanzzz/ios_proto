//
//  Sports.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 18/11/20.
//

import UIKit

class Sports: Codable, Equatable {
    
    var id: String?
    var sportName: String? = ""
    var sportsImg: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case sportName
        case sportsImg
    }
    
    static func == (lhs: Sports, rhs: Sports) -> Bool {
        return lhs.id == rhs.id
    }
}
