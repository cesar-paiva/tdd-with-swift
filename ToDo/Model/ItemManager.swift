//
//  ItemManager.swift
//  ToDo
//
//  Created by Cesar Paiva on 10/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit

@objc protocol ItemManagerSettable {
       var itemManager: ItemManager? { get set }
}

class ItemManager: NSObject {
    
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    func addItem(_ item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    func itemAtIndex(_ index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func checkItemAtIndex(_ index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }
    
    func doneItemAtIndex(_ index: Int) -> ToDoItem {
           return doneItems[index]
    }
    
    func uncheckItemAtIndex(_ index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }
    
    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
    
    @objc func save() {
        
        var nsToDoItems = [Any]()
        
        for item in toDoItems {
            nsToDoItems.append(item.plistDict)
        }
        
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).write(to: toDoPathURL, atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: toDoPathURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}


