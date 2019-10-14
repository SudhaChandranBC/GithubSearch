//
//  ViewController.swift
//  Example
//
//  Created by Chandran, Sudha | SDTD on 14/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit
import GithubSearch

class ViewController: UIViewController {

     var searchAPI: GithubSearch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAPI = GithubSearch()
        print(searchAPI.getRepositories(a: 1, b: 1))
        
    }


}

