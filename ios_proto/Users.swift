//
//  user.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 18/11/20.
//

import UIKit

class Users: Codable, Equatable {
   
    var id: String?
    var firstName: String? = ""
    var LastName: String? = ""
    var gender: String? = ""
    var dateOfBirth: Date?
    var address: String? = ""
    var state: String? = ""
    var postcode: Int?
    var registerationDate: Date?
    var profileImg: String? = ""
    var uuid: String? = ""
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case LastName
        case gender
        case dateOfBirth
        case address
        case state
        case postcode
        case registerationDate
        case profileImg
        case uuid
    }
    
    static func == (lhs: Users, rhs: Users) -> Bool {
        return lhs.id == rhs.id
    }
}
