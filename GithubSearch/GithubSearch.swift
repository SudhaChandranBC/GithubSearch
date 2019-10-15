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
    let total_count: Int
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

public struct SearchOption {
    public var query: String?
    public var organisation: String?
    
}

public class GithubSearch {

    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public enum APIError: Error {
        case apiError
        case invalidEndpoint
        case noData
        case decodeError
    }
    
    
    /**
     Fetches repositories for a query or organization
     - parameter query: The string for finding repository.
     - parameter org: The organization that owns the repositories.
     - parameter completion: Callback for the outcome of the fetch.
     */
    func search(matching query: String,
                  filterBy org: String,
                  completion: @escaping (Result<[Repository], APIError>) -> ()) {
        
        guard let url = GithubSearchEndpoint.search(matching: query, filterBy: org).url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        session.dataTask(with: url) { (data, _, err) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(RepositoriesResponse.self, from: data)
                    if let repositories = response.items {
                        repositories.forEach({ (repository) in
                            guard let descr = repository.description else {return}
                            print("->\(descr)")
                        })
                        completion(.success(repositories))
                    } else {
                        completion(.failure(.noData))
                    }
                } catch {
                    completion(.failure(.decodeError))
                }
            } else {
                completion(.failure(.apiError))
                return
            }
        }.resume()
    }

}
