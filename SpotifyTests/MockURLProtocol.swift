//
//  MockURLProtocol.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/3/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

class MockURLProtocol: URLProtocol {
    
    static var mockStatusCode = 200
    static var mockResponseData: Data? = nil
    static var mockHeaders: [String: String]? = nil
    static var nextURLCompletion: ((URL?) -> Void)? = nil
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        if (nextURLCompletion != nil) {
            DispatchQueue.main.async {
                nextURLCompletion?(request.url)
            }
        }
        
        return true
    }
    
    override func startLoading() {
        
        let response = HTTPURLResponse(url: self.request.url!, statusCode: MockURLProtocol.mockStatusCode, httpVersion: "HTTP/1.1", headerFields: MockURLProtocol.mockHeaders)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        
        if let data = MockURLProtocol.mockResponseData {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    static func register(with data: Data) {
        MockURLProtocol.register(with: 200, headers: ["Content-Type": "application/json; charset=utf-8"], responseData: data)
        
    }
    
    static func register(with statusCode: Int, headers: [String: String], responseData: Data)  {
        
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.mockHeaders = headers
        MockURLProtocol.mockStatusCode = statusCode
        MockURLProtocol.mockResponseData = responseData
    }
    
    static func register(nextURLCompletion: ((URL?) -> Void)? = nil)  {
        
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.nextURLCompletion = nextURLCompletion
    }
    
    static func unregister() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        MockURLProtocol.mockHeaders = nil
        MockURLProtocol.mockResponseData = nil
        MockURLProtocol.nextURLCompletion = nil
    }
    
}
