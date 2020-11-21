//
//  Sender.swift
//  ios_proto
//
//  Created by user173239 on 11/22/20.
//

import UIKit
import MessageKit

class Sender: SenderType {
    var senderId: String
    var displayName: String
    
    init(id: String, name: String) {
        senderId = id
        displayName = name
    }
}
