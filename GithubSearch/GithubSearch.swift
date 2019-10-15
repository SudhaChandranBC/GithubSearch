//
//  GithubSearch.swift
//  GithubSearch
//
//  Created by Chandran, Sudha | SDTD on 14/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import Foundation

// MARK: Repository Models
struct RepositoriesResponse: Decodable {
    let total_count: Int?
    let incompleteResults : Bool?
    let items: [Repository]?
}

struct Repository: Decodable {
    let name: String?
    let `private`: Bool
    let language: String?
    let description: String?
}

// MARK: Search Endpoint Model
struct GithubSearchEndpoint {
    let queryItems: [URLQueryItem]
    let path = "/search/repositories"
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    /**
     Creates an endpoint for search with a query or organization
     - parameter query: The string for finding repository.
     - parameter org: The organization that owns the repositories.
     */
    static func search(matching query: String,
                       filterBy org: String) -> GithubSearchEndpoint {
        return GithubSearchEndpoint(
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "org", value: org)
            ]
        )
    }
}

public class GithubSearch {

    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /**
     Fetches repositories for a query or organization
     - parameter query: The string for finding repository.
     - parameter org: The organization that owns the repositories.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func searchRepositories(matching query: String,
                            filterBy org: String,
                            completion: @escaping ((RepositoriesResponse?, Error?) -> Swift.Void)) {

        guard let url = GithubSearchEndpoint.search(matching: query, filterBy: org).url else {return}
        
        let task = session.dataTask(with: url) {
            data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let repo = try JSONDecoder().decode(RepositoriesResponse.self, from: data)
                repo.items?.forEach { repo in
                    guard let descr = repo.description else {return}
                    print("->\(descr)")
                }
                DispatchQueue.main.async {
                    completion(repo, nil)
                }
            } catch let jsonErr {
                DispatchQueue.main.async {
                    completion(nil, jsonErr)
                }
            }
        }
        
        task.resume()
    }
}
