//
//  SearchRequest.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/2/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

class SearchRequest<T: SpotifyObject>: SpotifyRequest {
    
    /// Specifies the keyword to search in the Spotify webservice.
    var keyword = ""

    /// The index of the first result to return.
    /// Maximum offset: 100.000.
    ///
    /// Default: 0 (i.e., the first result)
    var offset: Int = 0

    /// Specifies the maximum number of result
    ///
    /// Defaults to 10 items.
    var limit: Int = 20
    
    /// Starts an asynchronous call to perform a search on the Spotify webservice.
    /// The completion block will be executed on main thread.
    ///
    /// - parameter completion: The block to execute when the operation completes (regardless of success or failure).
    func executeRequest(completion: @escaping ((SearchResult<T>?, Error?) -> ())) {
        
        var parameters = [String: String]()
        
        parameters["q"] = self.keyword
        
        var resultKey = ""
        if T.self == Album.self {
            parameters["type"] = "album"
            resultKey = "albums"
        }
        
        if self.offset > 0 {
            parameters["offset"] = "\(self.offset)"
        }
        
        if self.offset > 0 {
            parameters["limit"] = "\(self.limit)"
        }
        
        self.connect(with: "search", parameters: parameters, limitTag: "search") { (data, error) in
            var result: SearchResult<T>?
            
            if let dict = data as? [String: Any],
                let albums = dict[resultKey] as? [String: Any] {
               result = SearchResult(with: albums)
            }
            
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
    }

}
