//
//  TestUtilities.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 05.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

func formatError(_ str: String) -> String {
    return "\nASSERT ERROR: \(str)"
}

func doURLsMatch(firstURL: URL, secondURL: URL) -> Bool {
    
    if	let firstComponents = URLComponents(url:firstURL, resolvingAgainstBaseURL:false),
        let secondComponents = URLComponents(url:secondURL, resolvingAgainstBaseURL:false) {
        
        if firstComponents.string == secondComponents.string {
            return false
        }
        
        
        var firstParams = getParams(from: firstComponents.query!)
        var secondParams = getParams(from: secondComponents.query!)
        
        for pair in firstParams {
            if firstParams[pair.key] == secondParams[pair.key] {
                firstParams.removeValue(forKey: pair.key)
                secondParams.removeValue(forKey: pair.key)
            }
        }
        
        if firstParams.count == 0 && secondParams.count == 0 {
            return true
        }
    }
    
    return false
}

func getParams(from query: String) -> [String: String] {
    var firstParams = [String: String]()
    
    for parameter in query.components(separatedBy: "&") {
        let parts = parameter.components(separatedBy:"=")
        if let first = parts.first {
            firstParams[first] = parts.count == 2 ? parts[1] : ""
        }
    }
    return firstParams
}
