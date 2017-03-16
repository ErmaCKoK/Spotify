//
//  ModelsValidation.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 05.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import Foundation
import XCTest

@testable import Spotify

class SearchResultValidation {
    
    class func validated(_ result: SearchResult<Album>, dict: [String: Any]) {
        
        // Validated items
        if let items = dict["items"] as? [[String: Any]] {
            
            XCTAssert(result.items.count == items.count, formatError("SearchResult<Album> validator's items.count should be \(items.count)"))
            for (index, item) in result.items.enumerated() {
                AlbumValidation.validated(item, dict: items[index], prefix: "SearchResult<Album>")
            }
            
        }
        
        let errorMessage = "SearchResult<Album> validator's failed for"
        
        // Validated properties of class
        XCTAssertEqual(result.next, dict["next"] as? String, formatError("\(errorMessage) next"))
        XCTAssertEqual(result.previous, dict["previous"] as? String, formatError("\(errorMessage) next"))
        
        XCTAssertEqual(result.limit, dict["limit"] as! Int, formatError("\(errorMessage) limit"))
        XCTAssertEqual(result.total, dict["total"] as! Int, formatError("\(errorMessage) total"))
        XCTAssertEqual(result.offset, dict["offset"] as! Int, formatError("\(errorMessage) offset"))
    }
}

class AlbumValidation {
    
    class func validated(_ album: Album, dict: [String: Any], prefix: String) {
        
        let albumPrefix = "\(prefix):AlbumValidation"
        
        // Validated Base class
        SpotifyObjectValidation.validated(album, dict: dict, prefix: albumPrefix)
        
        // Validated artists
        let artistsDict = dict["artists"] as! [[String: Any]]
        XCTAssert(album.artists.count == artistsDict.count, formatError("\(albumPrefix) validator's artists.count should be \(artistsDict.count)"))
        for (index, artist) in album.artists.enumerated() {
            ArtistValidation.validated(artist, dict: artistsDict[index], prefix: albumPrefix)
        }
        
        // Validated images
        let imagesDict = dict["images"] as! [[String: Any]]
        XCTAssert(album.images.count == imagesDict.count, formatError("\(albumPrefix) validator's images.count should be \(imagesDict.count)"))
        
        for (index, image) in album.images.enumerated() {
            SpotifyImageValidation.validated(image, dict: imagesDict[index], prefix: albumPrefix)
        }
        
        // Validated properties of class
        XCTAssert(album.markets == dict["available_markets"] as! [String], formatError("\(albumPrefix) validator's failed for markets"))
        XCTAssert(album.albumType == dict["album_type"] as! String, formatError("\(albumPrefix) validator's failed for albumType"))
    }
    
}

class ArtistValidation {
    
    class func validated(_ artist: Artist, dict: [String: Any], prefix: String) {
        // Validation Base class
        SpotifyObjectValidation.validated(artist, dict: dict, prefix: "\(prefix):ArtistValidation")
    }
    
}

class SpotifyObjectValidation {
    
    class func validated(_ object: SpotifyObject, dict: [String: Any], prefix: String) {
        let errorMessage = "\(prefix):SpotifyObject validator's failed for"
        
        // Validated properties of class
        XCTAssertEqual(object.href, dict["href"] as! String, formatError("\(errorMessage) href"))
        XCTAssertEqual(object.id, dict["id"] as! String, formatError("\(errorMessage) id"))
        XCTAssertEqual(object.name, dict["name"] as! String, formatError("\(errorMessage) name"))
        XCTAssertEqual(object.type, dict["type"] as! String, formatError("\(errorMessage) type"))
        XCTAssertEqual(object.uri, dict["uri"] as! String, formatError("\(errorMessage) uri"))
        XCTAssertEqual(object.externalURLs, dict["external_urls"] as! [String: String], formatError("\(errorMessage) externalURLs"))
    }
}

class SpotifyImageValidation {
    
    class func validated(_ object: SpotifyImage, dict: [String: Any], prefix: String) {
        let errorMessage = "\(prefix):spotifyImage validator's failed for"
        
        // Validated properties of class
        XCTAssertEqual(object.url, dict["url"] as! String, formatError("\(errorMessage) url"))
        XCTAssertEqual(object.width, dict["width"] as! Double, formatError("\(errorMessage) width"))
        XCTAssertEqual(object.height, dict["height"] as! Double, formatError("\(errorMessage) height"))
    }
}
