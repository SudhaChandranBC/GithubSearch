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
    var session: URLSession!
    
    override func setUp() {
        searchAPI = GithubSearch()
        session = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        session = nil
        searchAPI = nil
        super.tearDown()
    }
    
    func testJSONMapping() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Repositories", withExtension: "json")!
        let json = try Data(contentsOf: url)
        let repo = try JSONDecoder().decode(RepositoriesResponse.self, from: json)
        let repositories: [Repository] = repo.items!
        XCTAssertFalse(repositories.isEmpty)
        
        let exampleRepo: Repository = repositories.first!
        XCTAssertEqual(exampleRepo.language, "Java")
        XCTAssertEqual(exampleRepo.description, "Performance Tracking for Android Apps")
        XCTAssertEqual(exampleRepo.name, "android-perftracking")
        XCTAssertFalse(exampleRepo.private)

    }
    
    func testStaticUrl() {
        let url =
            URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
           if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    func testSearchAPISuccess() {
        let promise = expectation(description: "Status code: 200")

        searchAPI.searchRepositories(matching: "android", filterBy: "rakutentech") { (repositories, error) in
            if let repos = repositories?.items {
                if repos.count > 0 {
                    promise.fulfill()
                }
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testSearchAPIFailure() {
        let promise = expectation(description: "No Repositories found!")
        
        searchAPI.searchRepositories(matching: "", filterBy: "") { (repositories, error) in
            XCTAssertNil(repositories?.items)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
}
