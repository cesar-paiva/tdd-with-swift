//
//  ToDoItem.swift
//  ToDo
//
//  Created by Cesar Paiva on 10/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {
    
    
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timestampKey = "timestampKey"
    private let locationKey = "locationKey"
    
    var plistDict: NSDictionary {
        
        var dict = [String: Any]()
        dict[titleKey] = title
        
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }
        return dict as NSDictionary
        
    }
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil) {
        
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    init?(dict: NSDictionary) {
        
        guard let title = dict[titleKey] as? String else { return nil }
        
        self.title = title
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as? NSDictionary {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
        
        
    }
    
    static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        
        if lhs.location != rhs.location {
            return false
        }
        if lhs.timestamp != rhs.timestamp {
               return false
        }
        if lhs.itemDescription != rhs.itemDescription {
               return false
        }
        if lhs.title != rhs.title {
               return false
        }
        return true
    }
}

