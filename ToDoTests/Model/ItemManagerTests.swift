//
//  ItemManagerTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 10/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {
    
    var sut: ItemManager!

    override func setUp() {
        sut = ItemManager()
    }

    override func tearDown() {
        super.tearDown()
        
        sut.removeAllItems()
        sut = nil
    }
    
    func testToDoCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDo count should be 0")
    }
    
    func testDoneCount_ShouldBeZero() {
        XCTAssertEqual(sut.doneCount, 0, "Initially done count should be 0")
    }
    
    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(ToDoItem(title: "Test title"))
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
    }
    
    func testItemAtIndex_ShouldReturnPreviousAddedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        let returnedItem = sut.itemAtIndex(0)
        XCTAssertEqual(item.title, returnedItem.title,
        "should be the same item")
    }
    
    func testCheckingItem_ChangesCountOfToDoAndOfDoneItems() {
           sut.addItem(ToDoItem(title: "First Item"))
           sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
    }
    
    func testCheckingItem_RemovesItFromTheToDoItemList() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.itemAtIndex(0).title, secondItem.title)
    }

    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        sut.checkItemAtIndex(0)
        let returnedItem = sut.doneItemAtIndex(0)
        XCTAssertEqual(item.title, returnedItem.title,
        "should be the same item")
    }
    
    func testRemoveAllItems_ShouldResultInCountsBeZero() {
           sut.addItem(ToDoItem(title: "First"))
           sut.addItem(ToDoItem(title: "Second"))
           sut.checkItemAtIndex(0)
           XCTAssertEqual(sut.toDoCount, 1,
               "toDoCount should be 1")
           XCTAssertEqual(sut.doneCount, 1,
               "doneCount should be 1")
         sut.removeAllItems()
        
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "doneCount should be 0")
    }
    
    func testAddingTheSameItem_DoesNotIncreaseCount() {
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "First"))
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ToDoItemsGetSerialized() {
        
        var itemManager: ItemManager? = ItemManager()
        
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "Second")
        itemManager!.addItem(secondItem)
        
        NotificationCenter.default.post(name: UIApplication.willResignActiveNotification, object: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        XCTAssertEqual(itemManager!.toDoCount, 2)
        XCTAssertEqual(itemManager!.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager!.itemAtIndex(1), secondItem)
    }
}
