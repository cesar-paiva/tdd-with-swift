//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 22/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
import  CoreLocation
@testable import ToDo

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!

    override func setUp() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController)
        
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        
    }
    
    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }
        
    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField() {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "29/10/2019"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"
        
        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        
        mockInputViewController.itemManager = ItemManager()
        
        let testExpecation = expectation(description: "bla")
        mockInputViewController.completionHandler = {
            testExpecation.fulfill()
        }
        
        mockInputViewController.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851,
            -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        let item = mockInputViewController.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test Title",
            itemDescription: "Test Description",
            timestamp: 1572318000,
            location: Location(name: "Office", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else { return XCTFail() }
        
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_GeocoderWorksAsExpected() {
        
        let expectationGeocode = expectation(description: "Wait for geocode")
        
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
            (placemarks, error) -> Void in
            let placemark = placemarks?.first
            
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else { return XCTFail() }
            
            guard let longitude = coordinate?.longitude else { return XCTFail() }
            
            XCTAssertEqual(latitude, 37.3316561, accuracy: 0.000001)
            XCTAssertEqual(longitude, -122.0301426, accuracy: 0.000001)
            
            expectationGeocode.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        
        mockInputViewController.titleTextField.text = "Test title"
        mockInputViewController.save()
        
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
}

extension InputViewControllerTests {
        
    class MockGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    class MockInputViewController: InputViewController {
        
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
}
