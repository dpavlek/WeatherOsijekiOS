//
//  NetworkFetcher.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 20/07/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation

class Fetcher {

    let session = URLSession.shared

    init(fromUrl url: URL, completion: @escaping (([String: Any]) -> Void)){
       
        let task = session.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                return
            }
            let parsedData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            completion(parsedData!)
        }
        task.resume()
    }
}
