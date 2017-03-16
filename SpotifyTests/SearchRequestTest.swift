//
//  SearchRequestTest.swift
//  SpotifyTests
//
//  Created by Andrii Kurshyn on 11/3/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit
import XCTest
@testable import Spotify

class SearchRequestTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_VerifySearchRequest_URL() {
    
        let mocURL = URL(string: "https://api.spotify.com/v1/search?q=ten%20ten&type=album&limit=5&offset=1")!
        
        let expectation = self.expectation(description: "executeRequestWithCompletion did not complete")
        
        MockURLProtocol.register { (url) in
            
            XCTAssertNotNil(url, formatError("url is nil for request."))
            XCTAssert(doURLsMatch(firstURL: mocURL, secondURL: url!), formatError("url is wrong for request\nexpected: \(mocURL.absoluteString)\n  actual: \(url!.absoluteString)"))
            
            expectation.fulfill()
        }
        
        let request = SearchRequest<Album>()
        request.keyword = "ten ten"
        request.limit = 5
        request.offset = 1
        request.executeRequest { (result, error) in }
        
        self.waitForExpectations(timeout: 10, handler: { error in
            MockURLProtocol.unregister()
        })
    }
    
    func test_VerifySearchResult_Albums() {
        
        let moc = MockAlbumSearch.oneAlbum
        MockURLProtocol.register(with: moc.jsonData)
        
        let expectation = self.expectation(description: "executeRequestWithCompletion did not complete")
        SearchRequest<Album>().executeRequest { (result, error) in
            
            XCTAssertNil(error, formatError("execute completion should not have returned an error"))
            XCTAssertNotNil(result, formatError("execute completion should have returned valid results"))
            XCTAssert((result?.items.count ?? 0) > 0, formatError("execute completion's result.item.count should be > 0"))
            SearchResultValidation.validated(result!, dict: moc.dict)
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: { error in
                MockURLProtocol.unregister()
        })
    }
    
    
}
