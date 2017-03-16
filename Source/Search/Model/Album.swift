//
//  Album.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/2/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation

class Album: SpotifyObject {
    
    var albumType: String
    var artists = [Artist]()
    var markets = [String]()
    var images = [SpotifyImage]()
    
    required init?(with json: [String: Any]) {
        
        self.albumType = json["album_type"] as? String ?? ""
        
        super.init(with: json)
        
        if let availableMarkets = json["available_markets"] as? [String] {
            self.markets = availableMarkets
        }
        
        if let artists = json["artists"] as? [[String: Any]] {
            self.artists = artists.flatMap({ Artist(with: $0) })
        }
        
        if let images = json["images"] as? [[String: Any]] {
            self.images = images.flatMap({ SpotifyImage(with: $0) })
        }
    }
    
    func imageURL(by imageUsageType: ImageUsageType) -> String {
        return self.image(by: imageUsageType)?.url ?? ""
    }
    
    func image(by imageUsageType: ImageUsageType) -> SpotifyImage? {
        if imageUsageType.rawValue >= self.images.count {
            return nil
        }
        
        return self.images[imageUsageType.rawValue]
    }
}
