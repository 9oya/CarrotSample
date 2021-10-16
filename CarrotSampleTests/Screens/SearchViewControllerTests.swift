//
//  SearchViewControllerTests.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import XCTest
@testable import CarrotSample

class SearchViewControllerTests: XCTestCase {
    
    var viewInput: MockSearchViewInput!
    var viewOutput: MockSearchViewOuput!
    var interactorOutput: MockSearchInteractorOutput!
    var interactorInput: MockSearchInteractor!
    
    var viewController: SearchViewController!

    override func setUpWithError() throws {
        interactorOutput = MockSearchInteractorOutput()
        interactorInput = MockSearchInteractor(output: interactorOutput)
        viewInput = MockSearchViewInput()
        viewOutput = MockSearchViewOuput(view: viewInput,
                                         interactor: interactorInput)
        viewController = SearchViewController()
        viewController.output = viewOutput
    }

    override func tearDownWithError() throws {
        interactorOutput = nil
        interactorInput = nil
        viewInput = nil
        viewOutput = nil
        viewController = nil
    }

    func testViewDidLoad() {
        // when
        viewController.viewDidLoad()
        
        // then
        XCTAssertEqual(true, viewInput.isInitialStateSet)
    }
    
    func testSearchBar_withKeyword() {
        // given
        let keyword = "Swift"
        
        // when
        viewController.setupInitialState()
        let searchBar = viewController.searchBar!
        searchBar.text = keyword
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
        
        // then
        XCTAssertEqual(keyword, interactorInput.keyword)
    }
    
    func testTableViewDataSource_numberOfRowsInSection() {
        // given
        interactorInput.books = 14
        
        // when
        viewController.setupInitialState()
        _ = viewController.tableView(viewController.tv, numberOfRowsInSection: 0)
        
        // then
        XCTAssertEqual(14, interactorInput.books)
    }
    
    func testTableViewDataSource_cellForRowAt() {
        // given
        let indexPath = IndexPath(row: 3, section: 0)
        interactorInput.index = indexPath.row
        
        // when
        viewController.setupInitialState()
        _ = viewController.tableView(viewController.tv, cellForRowAt: indexPath)
        
        // then
        XCTAssertEqual(indexPath.row, interactorInput.index)
    }
    
    func testScrollViewDidScroll_not() {
        // given
        let keyword = "Swift"
        viewController.keyword = keyword
        
        // when
        viewController.setupInitialState()
        viewController.scrollViewDidScroll(viewController.tv)
        
        // then
        XCTAssertNotEqual(keyword, interactorInput.keyword)
        XCTAssertNotEqual(true, interactorInput.isScrolled)
    }
}

class MockSearchViewOuput: SearchViewOutput {
    
    var view: SearchViewInput
    var interactor: SearchInteractorInput
    
    init(view: SearchViewInput,
         interactor: SearchInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func searchBooksWith(keyword: String, isScrolled: Bool) {
        interactor.searchBooksWith(keyword: keyword, isScrolled: isScrolled)
    }
    
    func numberOfBooks() -> Int {
        interactor.numberOfBooks()
    }
    
    func configureTableCell(cell: BookTableCell, index: Int) {
        interactor.configureTableCell(cell: cell, index: index)
    }
    
    func isbn(index: Int) -> String {
        interactor.isbn(index: index)
    }
}

class MockSearchInteractorOutput: SearchInteractorOutput {
    var isTableViewUpdated: Bool = false
    var isScrollTableViewToTop: Bool = false
    
    func tableViewNeedUpdate() {
        isTableViewUpdated = true
    }
    
    func scrollTableViewToTop() {
        isScrollTableViewToTop = true
    }
}

class MockSearchInteractor: SearchInteractorInput {
    
    var output: SearchInteractorOutput
    
    var keyword: String = ""
    var isScrolled: Bool = false
    var isbn: String = ""
    var books: Int = 0
    
    var cell: BookTableCell!
    var index: Int!
    
    init(output: SearchInteractorOutput) {
        self.output = output
    }
    
    func searchBooksWith(keyword: String, isScrolled: Bool) {
        self.keyword = keyword
        self.isScrolled = isScrolled
        self.isbn = "9781617294136"
    }
    
    func numberOfBooks() -> Int {
        return books
    }
    
    func configureTableCell(cell: BookTableCell, index: Int) {
        self.cell = cell
        self.index = index
    }
    
    func isbn(index: Int) -> String {
        return self.isbn
    }
}

class MockSearchViewInput: SearchViewInput {
    
    var isInitialStateSet: Bool = false
    var isTableViewUpdated: Bool = false
    var isScrollTableViewToTop: Bool = false
    
    func setupInitialState() {
        isInitialStateSet = true
    }
    
    func tableViewNeedUpdate() {
        isTableViewUpdated = true
    }
    
    func scrollTableViewToTop() {
        isScrollTableViewToTop = true
    }
    
}
