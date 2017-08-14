//
//  Protocols.swift
//  WeatherOsijek
//
//  Created by COBE Osijek on 14/08/2017.
//  Copyright © 2017 COBE Osijek. All rights reserved.
//

import Foundation

public protocol FetchesJSON{
    func fetch(fromUrl url: URL, completion: @escaping (([String: Any]) -> Void))
}
