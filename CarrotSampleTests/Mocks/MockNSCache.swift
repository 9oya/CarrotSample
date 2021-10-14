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
    
    override func setObject(_ obj: UIImage, forKey key: NSString) {
        cachedDict[key] = obj
    }
    
    override func object(forKey key: NSString) -> UIImage? {
        return cachedDict[key]
    }
}
