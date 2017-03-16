//
//  SpotifyObject.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 02.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation


class SpotifyObject: NSObject {
    
    var type: String
    var id: String
    var name: String
    var uri: String
    var href: String
    
    var externalURLs = [String: String]()
    
    required init?(with json: [String: Any]) {
        
        guard let id = json["id"] as? String,
            let type = json["type"] as? String,
            let uri = json["uri"] as? String,
            let href = json["href"] as? String else {
                return nil
        }
        
        self.id = id
        self.type = type
        self.uri = uri
        self.href = href
        
        self.name = json["name"] as? String ?? ""
        
        if let externalURLs = json["external_urls"] as? [String: String] {
            self.externalURLs = externalURLs
        }
    }
    
}
