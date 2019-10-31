//
//  StoryboardTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 24/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
@testable import ToDo

class StoryboardTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialViewController_IsItemListViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is ItemListViewController)
    }

}
