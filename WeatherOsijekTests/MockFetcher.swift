//
//  MockFetcher.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 14/08/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation
@testable import WeatherOsijek

class FetcherMock: FetchesJSON {
    
    var currentTask: URLSessionTask?
    
    var shouldSucceed = true
    
    func fetch(fromUrl url: URL, completion: @escaping (([String: Any]) -> Void)) {
        
        if shouldSucceed {
            completion(MockData.mockJson)
        } else {
            completion([:])
        }
    }
}
