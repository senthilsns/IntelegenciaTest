//
//  IntelegenciaTestTests.swift
//  IntelegenciaTestTests
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import IntelegenciaTest

class IntelegenciaTestTests: XCTestCase {
    
    var viewControllerUnderTest: ViewController!


    override func setUp() {
   
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testHasATableView() {
        XCTAssertNotNil(self.viewControllerUnderTest.intelliTableview)
       }
       
       func testTableViewHasDelegate() {
        XCTAssertNotNil(self.viewControllerUnderTest.intelliTableview.delegate)
       }
       
       func testTableViewConfromsToTableViewDelegateProtocol() {
           XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
           XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:didSelectRowAt:))))
       }
       
       func testTableViewHasDataSource() {
           XCTAssertNotNil(viewControllerUnderTest.intelliTableview.dataSource)
       }
       
       func testTableViewConformsToTableViewDataSourceProtocol() {
           XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
           XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
           XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
       }
    
    
    
    //MARK: Image List
    func testResetPasswordonlyUrl(){
                var valid : Bool
                var invalid : Bool
                
                let string = kImage_List_URL
                if string.isValidURL {
                   valid = true
                   invalid = false
                   
                   // Success Case
                   XCTAssertTrue(valid)
                   XCTAssertEqual(valid, true)
                   XCTAssertEqual(invalid, false)
                }else {
                    valid = false
                    invalid = true
                   
                   // Fail Case
                   XCTAssertTrue(invalid)
                   XCTAssertEqual(valid, false)
                   XCTAssertEqual(invalid, true)
                }
                       

            }
    
    func testImageList() {
            
            let registerURL : String = kImage_List_URL
            let testAppURL = NSURL(string: registerURL)
            
          
            // Success Case
            XCTAssertTrue(UIApplication.shared.canOpenURL(testAppURL! as URL))

            // Invalid URL
          guard URL(string: registerURL) != nil else {
                XCTFail("Invalid URL '\(registerURL)'")
                return
            }
            // Status Code with timeout
            var httpResponse: HTTPURLResponse?
            var responseError: Error?
            
            
            URLSession.shared.dataTask(with: URL.init(string: (testAppURL?.absoluteString)!)!){(data,response,err) in
                
                if err != nil {
                  XCTAssertNotNil(err)
                   return
                }
                
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode == 200 {
                    httpResponse = response as? HTTPURLResponse
                    XCTAssertEqual(httpResponse?.statusCode, 200)

                } else {
                    responseError = err
                    XCTFail("Status code: \(statusCode)")
                }
                
            }.resume()
                      
            // Success
            XCTAssertNil(responseError)
            
        }
        

}


//MARK: URL Validation
extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
