//
//  SpotifyRequest.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/2/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

class SpotifyRequest: NSObject {
    
    let webServiceBaseUrl = "https://api.spotify.com"

    /// Web Service API version
    ///
    /// Defaults to v1.
    var version: Int = 1

    /// Specifies the desired timeout for each webservice operation (if any) that
    ///  is used to fulfil this request, in part or in whole.
    ///
    /// Defaults to 15 seconds.
    var timeoutInterval: TimeInterval = 15
    
    
    /// For performing an async connection to path with query parameters on a background worker thread.
    /// The completion block will be executed on URLSession copletion thread.
    ///
    /// - parameter path:       the path
    /// - parameter parameters: query parameters of dictonary
    /// - parameter limitTag:   Used to make sure that only one request will be running at a time.
    /// - parameter completion: returns the json object and/or error.
    func connect(with path: String, parameters: [String: String]?, limitTag: String?, completion: @escaping ((Any?, Error?) -> ())) {
        
        var url = "\(self.webServiceBaseUrl)/v\(self.version)/\(path)"
        
        if let parameters = parameters {
            var isFirst = true
            for parameter in parameters {
                url += isFirst ? "?" : "&"
                isFirst = false
                let key = parameter.key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let value = parameter.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                url += "\(key)=\(value)"
            }
        }
        
        var reques = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        reques.httpMethod = "GET"
        
        self.connect(with: reques, limitTag: limitTag, completion: completion)
    }
    
    /// For performing an async connection to path with query parameters on a background worker thread.
    /// The completion block will be executed on URLSession copletion thread.
    ///
    /// - parameter reques:     the URLRequest
    /// - parameter parameters: query parameters of dictonary
    /// - parameter limitTag:   Used to make sure that only one request will be running at a time.
    /// - parameter completion: returns the json object and/or error.
    func connect(with reques: URLRequest, limitTag: String?, completion: @escaping ((Any?, Error?) -> ())) {
        
        NetworkingSession.shared.connect(to: reques, limitTag: limitTag) { (data, error) -> Void in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    completion(json, error)
                } catch let error as NSError {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
