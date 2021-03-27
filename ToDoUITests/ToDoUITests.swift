//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Cesar Paiva on 29/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testSaveItem_ShouldSaveItem() {
//        
//        let app = XCUIApplication()
//        app.navigationBars["Task List View"].buttons["Add"].tap()
//        
//        let titleTextField = app.textFields["Title"]
//        titleTextField.tap()
//        titleTextField.typeText("Beca iOS")
//        
//        let dateTextField = app.textFields["Date"]
//        dateTextField.tap()
//        dateTextField.typeText("29/10/2019")
//        
//        let locationNameTextField = app.textFields["Location Name"]
//        locationNameTextField.tap()
//        locationNameTextField.typeText("everis")
//        
//        let addressTextField = app.textFields["Address"]
//        addressTextField.tap()
//        addressTextField.typeText("Av. Dr Chucri Zaidan, 70")
//        
//        let descriptionTextField = app.textFields["Description"]
//        descriptionTextField.tap()
//        descriptionTextField.typeText("TDD Course with swift")
//        app.buttons["Save"].tap()
//        
//        XCTAssertTrue(app.tables.staticTexts["Beca iOS"].exists)
//        XCTAssertTrue(app.tables.staticTexts["29/10/2019"].exists)
//        XCTAssertTrue(app.tables.staticTexts["everis"].exists)
//    }

}
