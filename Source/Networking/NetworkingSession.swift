//
//  NetworkingSession.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/2/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

private extension UIApplication {
    
    static var activityCount: Int = 0
    
    func toggleNetworkActivityIndicator(isVisible: Bool) {
        
        UIApplication.activityCount = isVisible ? UIApplication.activityCount+1 : UIApplication.activityCount-1
        DispatchQueue.main.async {
            self.isNetworkActivityIndicatorVisible = UIApplication.activityCount > 0
        }
        
        if UIApplication.activityCount < 0 {
            UIApplication.activityCount = 0
        }
    }
}

class NetworkingSession: NSObject {
    
    
    /// Get the shared instance of NetworkingSession.
    static let shared = NetworkingSession()
    
    private var session = URLSession.shared
    private var oneRequestAtATimeQueue = [String: URLSessionDataTask]()
    
    /// For performing an async connection to URLRequest on a background worker thread.
    /// The completion block will be executed on URLSession copletion thread.
    ///
    /// - parameter request:    The request URLRequest
    /// - parameter limitTag:   Used to make sure that only one request will be running at a time.
    /// - parameter completion: Returns the response and/or error.
    func connect(to request: URLRequest, limitTag: String?, completion: @escaping ((Data?, Error?) -> Void) ){
        UIApplication.shared.toggleNetworkActivityIndicator(isVisible: true)
        
        let dataTask = self.session.dataTask(with: request, completionHandler: { (responseData, response, error) -> Void in
            UIApplication.shared.toggleNetworkActivityIndicator(isVisible: false)
            
            if (error as? NSError)?.code == NSURLErrorCancelled {
                return
            }
            
            if let limitTag = limitTag {
                self.oneRequestAtATimeQueue[limitTag] = nil
            }
            
            completion(responseData, error)
        })
        
        if let limitTag = limitTag {
            if let oldTag = self.oneRequestAtATimeQueue[limitTag] {
                oldTag.cancel()
            }
            self.oneRequestAtATimeQueue[limitTag] = dataTask
        }
        
        dataTask.resume()
    }
}
