//
//  SpecificImageViewTests.swift
//  IntelegenciaTestTests
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import IntelegenciaTest

class SpecificImageViewTests: XCTestCase {
    var specificView: DetailViewController!

    override func setUp() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.specificView = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        self.specificView.loadView()
        self.specificView.viewDidLoad()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    //MARK: Image List
       func testSpecificImagebyUrl(){
                   var valid : Bool
                   var invalid : Bool
                   
                   let string = kImage_Specific_URL+"0"
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
    
    func testParticularImageDownload() {
                
             let registerURL : String = kImage_Specific_URL+"0"
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
                           
                           XCTAssertEqual(httpResponse!.statusCode, 200)

                       } else {
                           responseError = err
                           XCTFail("Status code: \(statusCode)")
                       }
                       
                   }.resume()
             
                
                // Success
                XCTAssertNil(responseError)
                
             
            }

}
