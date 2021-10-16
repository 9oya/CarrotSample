//
//  MemoryCacheServiceTests.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import XCTest
@testable import CarrotSample

class MemoryCacheServiceTests: XCTestCase {
    
    var cache: MockNSChache!
    var service: MemoryCacheServiceProtocol!

    override func setUpWithError() throws {
        cache = MockNSChache()
        service = MemoryCacheService(imageCache: cache)
    }

    override func tearDownWithError() throws {
        cache = nil
        service = nil
    }
    
    func testStore_withKey() {
        // given
        let key = "9781617294136.png"
        let image = UIImage(named: "default-book")!
        
        // when
        service.store(key: key, image: image)
        
        // then
        XCTAssertEqual(key as NSString, cache.key)
        XCTAssertEqual(image, cache.object(forKey: key as NSString)! as UIImage)
    }
    
    func testFetch_withKey() {
        // given
        let key = "9781617294136.png"
        
        // when
        let _ = service.fetch(key: key)
        
        // then
        XCTAssertEqual(key as NSString, cache.key)
    }

}
