//
//  ApiKeys.swift
//  Twittermenti
//
//  Created by Philip Yu on 4/30/20.
//  Copyright © 2020 London App Brewery. All rights reserved.
//

import Foundation

func fetchFromPlist(forResource resource: String, forKey key: String) -> String? {
    
    let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value = plist?.object(forKey: key) as? String
    
    return value
    
}
