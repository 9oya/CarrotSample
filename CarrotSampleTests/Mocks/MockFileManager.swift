//
//  MockFileManager.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
@testable import CarrotSample

class MockFileManager: FileManagerProtocol {
    
    var cachedDict: [String: Data] = [:]
    
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool {
        cachedDict[path] = data
        return true
    }
    
    func fileExists(atPath path: String) -> Bool {
        if cachedDict[path] != nil {
            return true
        }
        return false
    }
}
