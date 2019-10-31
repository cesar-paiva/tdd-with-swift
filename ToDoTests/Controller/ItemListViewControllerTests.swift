//
//  ItemListViewControllerTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 13/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
    
    var sut: ItemListViewController!

    override func setUp() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyBoard.instantiateViewController(withIdentifier: String(describing: ItemListViewController.self)) as! ItemListViewController)
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)
    }
    
    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController, sut)
    }
    
    func testAddItem_PresentsAddItemViewController() {
        
        prepareViewController()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {
        
        prepareViewController()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        
        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func prepareViewController() {
        
        XCTAssertNil(sut.presentedViewController)
        
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return  }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.perform(addButton.action, with: addButton)
    }
    
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testItemSelectedNotification_PushesDetailViewController() {
        
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        sut.itemManager.addItem(ToDoItem(title: "First Item"))
        sut.itemManager.addItem(ToDoItem(title: "Second Item"))
        
        NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 1])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return }
        
        guard let detailItemManager = detailViewController.itemInfo?.0 else { XCTFail(); return }
        
        guard let index = detailViewController.itemInfo?.1 else { XCTFail(); return }
        
        detailViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager == sut.itemManager)
        XCTAssertEqual(index, 1)
    }
}

extension ItemListViewControllerTests {
    
    class MockNavigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
