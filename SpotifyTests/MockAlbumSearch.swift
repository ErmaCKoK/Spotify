//
//  MockAlbumSearch.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/3/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import XCTest

class MockAlbumSearch {
    
    class var oneAlbum: (jsonData: Data, dict: [String: Any]) {
        var dict = [String: Any]()
        
        dict["href"] = "https://api.spotify.com/v1/artists/1w5Kfo2jwwIPruYS2UWh56"
        dict["items"] = [MockAlbum.dict]
        dict["limit"] = 1
        dict["next"] = "https://api.spotify.com/v1/search?query=ten&offset=1&limit=1&type=album"
        dict["offset"] = 0
        dict["total"] = 16541
        
        let dataJSON = try! JSONSerialization.data(withJSONObject: ["albums": dict], options: .prettyPrinted)

        return (dataJSON, dict)
    }
    
}

class MockAlbum {
    
    class var dict: [String: Any] {
        var dict = [String: Any]()
        
        dict["href"] = "https://api.spotify.com/v1/artists/1w5Kfo2jwwIPruYS2UWh56"
        dict["album_type"] = "album"
        dict["artists"] = [MockArtist.dict]
        
        dict["available_markets"] = ["AD", "AR", "AT", "AU", "BE", "BG", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IS", "IT", "JP", "LI", "LT", "LU", "LV", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "PA", "PE", "PH", "PL", "PT", "PY", "SE", "SG", "SK", "SV", "TR", "TW", "US", "UY"]
        dict["external_urls"] = ["spotify" : "https://open.spotify.com/album/5B4PYA7wNN4WdEXdIJu58a"]
        
        dict["href"] = "https://api.spotify.com/v1/albums/5B4PYA7wNN4WdEXdIJu58a"
        dict["id"] = "5B4PYA7wNN4WdEXdIJu58a"
        dict["images"] = [ ["height" : 640.0,
                            "url" : "https://i.scdn.co/image/425e1fef6d70a48a103dfd168a556b7f72f72865",
                            "width" : 640.0],
                           ["height" : 300.0,
                            "url" : "https://i.scdn.co/image/23b5560068ee7324ee780841d0c20722ce9ecfde",
                            "width" : 300.0],
                           ["height" : 64.0,
                            "url" : "https://i.scdn.co/image/c06b7ebaeb4c30631a9a3e448e7e16bda9aab8a8",
                            "width" : 64.0] ]
        dict["name"] = "Ten"
        dict["type"] = "album"
        dict["uri"] = "spotify:album:5B4PYA7wNN4WdEXdIJu58a"
        
        return dict
    }
}

class MockArtist {
    
    class var dict: [String: Any] {
        var dict = [String: Any]()
        
        dict["external_urls"] = ["spotify" : "https://open.spotify.com/artist/1w5Kfo2jwwIPruYS2UWh56"]
        dict["href"] = "https://api.spotify.com/v1/artists/1w5Kfo2jwwIPruYS2UWh56"
        dict["id"] = "1w5Kfo2jwwIPruYS2UWh56"
        dict["name"] = "Pearl Jam"
        dict["type"] = "artist"
        dict["uri"] = "spotify:artist:1w5Kfo2jwwIPruYS2UWh56"
        
        return dict
    }
}

class MockSpotifyImage {
    
}



