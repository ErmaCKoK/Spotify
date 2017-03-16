//
//  SearchResult.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/2/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

class SearchResult<T: SpotifyObject> {
    
    private(set) var items = [T]()
    
    private(set) var next: String?
    private(set) var previous: String?
    
    private(set) var limit: Int = 0
    private(set) var total: Int = 0
    private(set) var offset: Int = 0
    
    init(with json: [String: Any]) {
        
        if let items = json["items"] as? [[String: Any]] {
            self.items = items.flatMap({ T.init(with: $0) })
        }
        
        self.next = json["next"] as? String
        self.previous = json["previous"] as? String
        
        self.limit = (json["limit"] as? NSNumber)?.intValue ?? 0
        self.total = (json["total"] as? NSNumber)?.intValue ?? 0
        self.offset = (json["offset"] as? NSNumber)?.intValue ?? 0
    }
}
