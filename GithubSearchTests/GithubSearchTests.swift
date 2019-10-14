//
//  GithubSearchTests.swift
//  GithubSearchTests
//
//  Created by Chandran, Sudha | SDTD on 14/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import XCTest
@testable import GithubSearch

class GithubSearchTests: XCTestCase {

    var searchAPI: GithubSearch!
    
    
    override func setUp() {
        searchAPI = GithubSearch()
    }
    
    func testAdd() {
        XCTAssertEqual(searchAPI.getRepositories(a: 1, b: 1), 2)
    }

}
