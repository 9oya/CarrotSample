//
//  DiskCacheServiceTests.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import XCTest
@testable import CarrotSample

class DiskCacheServiceTests: XCTestCase {
    
    var fileManager: MockFileManager!
    var service: DiskCacheServiceProtocol!

    override func setUpWithError() throws {
        fileManager = MockFileManager()
        service = DiskCacheService(fileManager: fileManager)
    }

    override func tearDownWithError() throws {
        fileManager = nil
        service = nil
    }

    func testStore_withKeyAndImage() {
        // given
        let key = "9781617294136.png"
        let image = UIImage(named: "default-book")!
        
        // when
        _ = service.store(key: key, image: image)
        
        // then
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError()
        }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        XCTAssertEqual(filePath.path, fileManager.path)
    }
    
    func testFetch_withKey() {
        // given
        let key = "9781617294136.png"
        
        // when
        _ = service.fetch(key: key)
        
        // then
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            fatalError()
        }
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(key)
        XCTAssertEqual(filePath.path, fileManager.path)
    }
}
