//
//  AddEventDelegate.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 20/11/20.
//

import Foundation

protocol AddEventDelegate: AnyObject {
    func addEvent(newEvent: Events) -> Bool
}
