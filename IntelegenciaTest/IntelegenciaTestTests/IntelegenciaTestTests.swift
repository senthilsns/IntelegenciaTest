//
//  IntelegenciaTestTests.swift
//  IntelegenciaTestTests
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import IntelegenciaTest
@testable import Mocker


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
    
    
    
    // Mock Test
    func testImageList(){
        
        let originalURL = URL(string:kImage_List_URL)!

        let mock = Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
            .get : MockedData.exampleJSON.data // Data containing the JSON response
        ])
        mock.register()

        URLSession.shared.dataTask(with: originalURL) { (data, response, error) in
            guard let data = data, let _ = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                return
            }

            // Check with original and mock Response
            XCTAssertEqual(data,MockedData.exampleJSON.data)

        }.resume()

    }
    
    
    // Cancellation of requests with a delayed mock.
      func testDelayedMockCancelation() {
          let expectation = self.expectation(description: "Data request should be cancelled")
          var mock = Mock(dataType: .json, statusCode: 200, data: [.get: Data()])
          mock.delay = DispatchTimeInterval.seconds(5)
          mock.register()

          let task = URLSession.shared.dataTask(with: mock.request) { (_, _, error) in
              XCTAssert(error?._code == NSURLErrorCancelled)
              expectation.fulfill()
          }

          task.resume()

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
              task.cancel()
          })
          waitForExpectations(timeout: 10.0, handler: nil)
      }


    //Two mocks for the same URL if the HTTP method is different.
     func testDifferentHTTPMethodSameURL() {
         let url = URL(string:kImage_List_URL)!
         Mock(url: url, dataType: .json, statusCode: 200, data: [.get: Data()]).register()
         Mock(url: url, dataType: .json, statusCode: 200, data: [.put: Data()]).register()
         var request = URLRequest(url: url)
         request.httpMethod = Mock.HTTPMethod.get.rawValue
         XCTAssertNotNil(Mocker.mock(for: request))
         request.httpMethod = Mock.HTTPMethod.put.rawValue
         XCTAssertNotNil(Mocker.mock(for: request))
     }

    // Requested from the mock when we pass in an Error.
       func testMockReturningError() {
           let expectation = self.expectation(description: "Data request should succeed")
           let originalURL = URL(string: kImage_List_URL)!

           enum TestExampleError: Error {
               case example
           }

           Mock(url: originalURL, dataType: .json, statusCode: 500, data: [.get: Data()], requestError: TestExampleError.example).register()

           URLSession.shared.dataTask(with: originalURL) { (data, urlresponse, err) in

               XCTAssertNil(data)
               XCTAssertNil(urlresponse)
               XCTAssertNotNil(err)
               if let err = err {
                   XCTAssertEqual("example", String(describing: err))
               }

               expectation.fulfill()
           }.resume()

           waitForExpectations(timeout: 10.0, handler: nil)
       }

    
    // Remove all registered mocks correctly.
        func testRemoveAll() {
            let mock = Mock(dataType: .json, statusCode: 200, data: [.get: Data()])
            mock.register()
            Mocker.removeAll()
            XCTAssertTrue(Mocker.shared.mocks.isEmpty)
        }



}


