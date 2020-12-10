//
//  SpecificImageViewTests.swift
//  IntelegenciaTestTests
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import XCTest
@testable import IntelegenciaTest
@testable import Mocker


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
    
    
  // Mocked Response
    
    func testImageURLDataRequest() {
        
        let fullUrl:String = kImage_Specific_URL+"0"
           let expectation = self.expectation(description: "Data request should succeed")
           let originalURL = URL(string: fullUrl)!
           
           let mock = Mock(url: originalURL, dataType: .imagePNG, statusCode: 200, data: [
               .get: MockedData.botAvatarImageFileUrl.data
           ])
           
           mock.register()
           URLSession.shared.dataTask(with: originalURL) { (data, _, error) in
               XCTAssert(error == nil)
               let image: UIImage = UIImage(data: data!)!
               let sampleImage: UIImage = UIImage(contentsOfFile: MockedData.botAvatarImageFileUrl.path)!
               
               XCTAssert(image.size == sampleImage.size, "Image should be returned mocked")
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
