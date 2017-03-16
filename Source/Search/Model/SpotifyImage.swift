//
//  SpotifyImage.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 02.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

enum ImageUsageType: Int {
    case large = 0
    case middle = 1
    case small = 2
}

class SpotifyImage: NSObject {
    
    var height: Double
    var width: Double
    var url: String
    
    var externalURLs = [String: String]()
    
    init?(with json: [String: Any]) {
        
        guard let width = json["width"] as? NSNumber,
              let height = json["height"] as? NSNumber,
              let url = json["url"] as? String else {
                return nil
        }
        
        self.width = width.doubleValue
        self.height = height.doubleValue
        self.url = url
    }
    
}
