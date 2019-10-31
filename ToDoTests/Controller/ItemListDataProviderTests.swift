//
//  ItemListDataProviderTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 13/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {
    
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!

    override func setUp() {
        super.setUp()
        
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = (storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController)
        
        _ = controller.view
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDown() {
        super.tearDown()
        
        sut.itemManager?.removeAllItems()
        sut.itemManager = nil
    }
    
    func testNumberOfSections_IsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberRowsInFirstSection_IsToDoCount() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        sut.itemManager?.addItem(ToDoItem(title: "Second"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberRowsInSecondSection_IsDoneCount() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        sut.itemManager?.addItem(ToDoItem(title: "Second"))
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRow_ReturnsItemCell() {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.reloadData()
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
        
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow() {
        
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
                
        let todoItem = ToDoItem(title: "First", itemDescription: "First description")
        sut.itemManager?.addItem(todoItem)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        
        XCTAssertEqual(cell.todoItem, todoItem)
    }
    
    func testCellInSectionTwo_GetsConfiguredWithDoneItem() {
        
        let mockTableView = MockTableView.mockTableViewWithDataSource(dataSource: sut)
                
        let firstItem = ToDoItem(title: "First", itemDescription: "First Description")
        sut.itemManager?.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "Second", itemDescription: "Second Description")
        sut.itemManager?.addItem(secondItem)
        
        sut.itemManager?.checkItemAtIndex(1)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        
        XCTAssertEqual(cell.todoItem, secondItem)
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleCheck() {
        
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(deleteButtonTitle, "Check")
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleUncheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView,
            titleForDeleteConfirmationButtonForRowAt:
            IndexPath(row: 0, section: 1))
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }
    
    func testCheckingAnItem_ChecksInTheItemManager() {
        
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }
    
    func testUnCheckingAnItem_UnChecksInTheItemManager() {
        
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
    
    func testSelectingACell_SendsNotification() {
        
        let item = ToDoItem(title: "First")
        sut.itemManager?.addItem(item)
        
        expectation(forNotification: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else { return false }
            
            return index == 0
        }
        
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 3, handler: nil)
        
        
    }
}

extension ItemListDataProviderTests {
    
    class MockTableView: UITableView {
        
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        class func mockTableViewWithDataSource(dataSource: UITableViewDataSource) -> MockTableView {
            
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            
            return mockTableView
        }
        
    }
    
    class MockItemCell: ItemCell {
        
        var todoItem: ToDoItem?
        
        override func configCellWith(item: ToDoItem, checked: Bool = false) {
            todoItem = item
        }
        
    }
}
