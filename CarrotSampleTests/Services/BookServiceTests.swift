//
//  BookServiceTests.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import XCTest
import Alamofire
@testable import CarrotSample

class BookServiceTests: XCTestCase {
    
    var session: MockSession!
    var service: BookServiceProtocol!

    override func setUpWithError() throws {
        session = MockSession()
        service = BookService(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        service = nil
    }

    func testSearch_callSearchAPIWithParams() {
        // when
        _ = service.search(keywork: "Swift", page: 1) { _ in }
        
        // then
        let expectedURL = APIRouter.searchBooks(keyword: "Swift", page: 1).urlRequest?.url
        let actualURL = session.requestConvertible?.urlRequest?.url
        XCTAssertEqual(expectedURL, actualURL)
        
        let expectedMethod = HTTPMethod.get
        let actualMethod = session.requestConvertible?.urlRequest?.method
        XCTAssertEqual(expectedMethod, actualMethod)
    }
    
    func testDetail_callDetailAPIWithParams() {
        // given
        let isbn = "1112233"
        
        // when
        _ = service.detail(isbn: isbn) { _ in }
        
        // then
        let expectedURL = APIRouter.bookDetail(isbn: isbn).urlRequest?.url
        let actualURL = session.requestConvertible?.urlRequest?.url
        XCTAssertEqual(expectedURL, actualURL)
        
        let expectedMethod = HTTPMethod.get
        let actualMethod = session.requestConvertible?.urlRequest?.method
        XCTAssertEqual(expectedMethod, actualMethod)
    }
    
    func testDownloadImg_callAPIWithURL() {
        // given
        let url = "https://itbook.store/img/books/9781617294136.png"
        
        // when
        _ = service.downloadImage(url: url) { _ in }
        
        // then
        let actualURL = try! session.convertible?.asURL()
        XCTAssertEqual(URL(string: url), actualURL)
    }
}
