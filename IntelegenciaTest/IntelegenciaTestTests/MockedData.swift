//
//  MockedData.swift
//  IntelegenciaTestTests
//
//  Created by Senthil Kumar2 on 30/11/20.
//  Copyright © 2020 Personal. All rights reserved.
//


import Foundation
import UIKit

/* Contains all available Mocked data. */
public final class MockedData {
    public static let botAvatarImageFileUrl: URL = Bundle(for: MockedData.self).url(forResource: "firstImage", withExtension: "jpg")!
    

    public static let exampleJSON: URL = Bundle(for: MockedData.self).url(forResource: "example", withExtension: "json")!
    


}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
