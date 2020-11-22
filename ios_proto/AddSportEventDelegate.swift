//
//  AddSportEventDelegate.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 22/11/20.
//

import Foundation

protocol AddSportEventDelegate: AnyObject {
    func addSportEvent(newSport: Sports) -> Bool
}
