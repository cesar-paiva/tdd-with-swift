//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by Cesar Paiva on 23/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()
        
        sut = APIClient()
        
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Login_MakesRequestWithUsernameAndPassword() {
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdöm", password: "%&34", completion: completion)
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else { XCTFail(); return }
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = NSCharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let expectedUsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
            "username=\(expectedUsername)&password=\(expectedPassword)")
    }
    
    func testLogin_CallsResumeOfDataTask() {
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    func testLogin_SetsToken() {
        
        let mockKeychainManager = MockKeychainMananger()
        sut.keychainManager = mockKeychainManager
        
        let completion = { (error: Error?) in }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        
        let responseDict = ["token": "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        let token = mockKeychainManager.passwordForAccount("token")
        
        XCTAssertEqual(token, responseDict["token"])
    }
    
    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        
        let responseData = Data()
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenDataIsNil() {
        
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        
        mockURLSession.completionHandler?(nil, nil, nil)
        
         XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenResponseHasError() {
        
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        
        let responseDict = ["token": "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        mockURLSession.completionHandler?(responseData, nil, error)
        
        XCTAssertNotNil(theError)
        
    }

}

extension APIClientTests {
    
    class MockURLSession: ToDoURLSession {
        
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()
        
        func dataTaskWithURL(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            self.url = url
            self.completionHandler = completionHandler
            
            return dataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
}

class MockKeychainMananger: KeychainAccessible {
    
    var passwordDict = [String:String]()
    
    func setPassword(_ password: String, account: String) {
        passwordDict[account] = password
    }
    
    func deletePasswordForAccount(_ account: String) {
        passwordDict.removeValue(forKey: account)
    }
    
    func passwordForAccount(_ account: String) -> String? {
        return passwordDict[account]
    }
    
    
}
