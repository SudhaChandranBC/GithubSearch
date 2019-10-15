//
//  GithubSearchTests.swift
//  GithubSearchTests
//
//  Created by Chandran, Sudha | SDTD on 14/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import XCTest
import OHHTTPStubs

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
    
  
    func test1() {
        let testHost = "te.st"
        let id = "42-abc"
        let stubbedJSON = [
            "total_count": 6,
            "incomplete_results": false,
            ] as [String : Any]
        
//        stub(condition: isHost(testHost) && isPath("/search/repositories/")) { _ in
//            return OHHTTPStubsResponse(
//                JSONObject: stubbedJSON,
//                statusCode: 200
//            )
//        }
        stub(condition: isPath("/search/repositories/")) { _ in
            let error = NSError(
                domain: "test",
                code: 42,
                userInfo: [:]
            )
            return OHHTTPStubsResponse(error: error)
        }
//        searchAPI.search(matching: "", filterBy: "") { (result) in
//        print(result)
//            let respos = try result.get()
//            XCTAssertNil(respos)
//        }
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            print(result)
        }
        
//        stub(condition: …) { _ in
//            /// Create some Chaos!
//            switch Int(arc4random_uniform(20)) {
//            case 1:
//                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil)
//                return OHHTTPStubsResponse(error: notConnectedError)
//            case 2:
//                let timeOutError = NSError(domain: NSURLErrorDomain, code: URLError.timedOut.rawValue, userInfo: nil)
//                return OHHTTPStubsResponse(error: timeOutError)
//            case 3:
//                let unavailable = NSError(domain: NSURLErrorDomain, code: URLError.cannotConnectToHost.rawValue, userInfo:nil)
//                return OHHTTPStubsResponse(error: unavailable)
//            default:
//                // But most of the time return the valid stubbed data instead of simulating an error
//                let stubPath = OHPathForFile("my-stub.json", type(of: self))!
//                return fixture(filePath: stubPath, headers: ["Content-Type":"application/json"])
//            }
//        }
    }
    
    func test3() {
        stub(condition: isHost("api.github.com")) { request in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            let error = OHHTTPStubsResponse(error:notConnectedError)
            guard let fixtureFile = OHPathForFile("Repositories.json", type(of: self)) else { return error }
            
            return OHHTTPStubsResponse(
                fileAtPath: fixtureFile,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        
        let promise = expectation(description: "Status code: 200")

        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success(let repositories):
                repositories.forEach({ (repository) in
                    print(repository.name!)
                })
                XCTAssertEqual(repositories[0].language, "Java")
                XCTAssertEqual(repositories[0].description, "Performance Tracking for Android Apps")
                XCTAssertEqual(repositories[0].name, "android-perftracking")
                XCTAssertFalse(repositories[0].private)
                promise.fulfill()
            case .failure( _): break
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func test4() {
        stub(condition: isHost("api.github.com")) { _ in
            let error = NSError(
                domain: "test",
                code: 42,
                userInfo: [:]
            )
            return OHHTTPStubsResponse(error: error)
        }
        
        let promise = expectation(description: "Status code: 200")
        
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success( _): break
            case .failure(let err):
                XCTAssertNotNil(err)
                XCTAssertEqual(err, GithubSearch.APIError.apiError)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func test5() {
        let stubbedJSON = [
            "total_count": 0,
            "incomplete_results": false,
            "items": []
            ] as [String : Any]
        
        stub(condition: isHost("api.github.com")) { _ in
            return OHHTTPStubsResponse(
                jsonObject: stubbedJSON,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        let promise = expectation(description: "Status code: 200")
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success(let repositories):
                XCTAssertNotNil(repositories)
                promise.fulfill()
            case .failure( _):break
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func test6() {
        stub(condition: isHost("api.github.com")) { request in
            let notConnectedError = NSError(domain:NSURLErrorDomain, code:Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo:nil)
            let error = OHHTTPStubsResponse(error:notConnectedError)
            guard let fixtureFile = OHPathForFile("Error.json", type(of: self)) else { return error }
            
            return OHHTTPStubsResponse(
                fileAtPath: fixtureFile,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        
        let promise = expectation(description: "Status code: 200")
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success( _): break
            case .failure(let err):
                XCTAssertNotNil(err)
                XCTAssertEqual(err, GithubSearch.APIError.decodeError)
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
    }
    
    func test7() {
        let stubbedJSON = [
            "total_count": 0,
            "incomplete_results": false,
            "items": []
            ] as [String : Any]
        
        stub(condition: isHost("api.github.com")) { _ in
            return OHHTTPStubsResponse(
                jsonObject: stubbedJSON,
                statusCode: 200,
                headers: ["Content-Type" : "application/json"]
            )
        }
        let promise = expectation(description: "Status code: 200")
        searchAPI.search(matching: "s", filterBy: "c") { (result) in
            switch result {
            case .success(let repositories):
                XCTAssertNotNil(repositories)
                promise.fulfill()
            case .failure( _):break
            }
        }
        wait(for: [promise], timeout: 5)
        OHHTTPStubs.removeAllStubs()
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
        searchAPI.search(matching: "android", filterBy: "rakutentech") { (result) in
            switch result {
            case .success(let repositories):
                XCTAssertNotNil(repositories)
                XCTAssertGreaterThan(repositories.count, 0)
                promise.fulfill()
            case .failure( _):break
            }
        }
        wait(for: [promise], timeout: 5)
    }
 
    
}
