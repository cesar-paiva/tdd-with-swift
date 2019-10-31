//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 20/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController)
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        
        sut.itemInfo?.0.removeAllItems()
    }

    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }
    
    func testSettingItemInfo_SetsTextsToLabels() {
        
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title", itemDescription: "The description", timestamp: 1572392986, location: Location(name: "Home", coordinate: coordinate)))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "The title")
        XCTAssertEqual(sut.dateLabel.text, "29/10/2019")
        XCTAssertEqual(sut.locationLabel.text, "Home")
        XCTAssertEqual(sut.descriptionLabel.text, "The description")
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
    }
    
    func testCheckItem_ChecksItemInItemManager() {
        
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title"))
        
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}
