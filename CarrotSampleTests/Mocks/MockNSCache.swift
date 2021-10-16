//
//  MockNSCache.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
import UIKit

class MockNSChache: NSCache<NSString, UIImage> {
    
    var cachedDict: [NSString: UIImage] = [:]
    var key: NSString = ""
    
    override func setObject(_ obj: UIImage, forKey key: NSString) {
        self.cachedDict[key] = obj
        self.key = key
    }
    
    override func object(forKey key: NSString) -> UIImage? {
        self.key = key
        return cachedDict[key]
    }
}
