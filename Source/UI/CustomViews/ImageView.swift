//
//  ImageView.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 11/3/16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    
    private var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var dataTask : URLSessionDataTask?
    private var privateURL : URL? {
        didSet {
            if privateURL?.absoluteString.isEmpty == false {
                self.showActivityIndicator()
                
                self.downloadImage(url: self.privateURL!, completion: { (image, error) in
                        
                        if let code = (error as? NSError)?.code, code == NSURLErrorCancelled {
                            // No need to stop animating..whoever cancelled us needs to do it.
                            return
                        }
                        
                        super.image = image
                        
                        self.activityIndicator.stopAnimating()
                })
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    var url: URL? {
        get {
            return self.privateURL
        }
        set (newURL) {
            super.image = nil
            self.privateURL = newURL
        }
    }
    
    override var image: UIImage? {
        didSet {
            self.dataTask?.cancel()
            self.privateURL = nil
        }
    }
    
   private func downloadImage(url: URL, completion:@escaping (UIImage?, Error?) -> ()) {
        
        let urlRequest: URLRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0)
        
        self.dataTask?.cancel()
        self.dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let privateURL = self.privateURL?.absoluteString,
                let responseURL = response?.url?.absoluteString,
                responseURL == privateURL else {
                // This object has been asked to re-target a different URL, so bail -
                //		we don't want to call completion since it would not be desired by caller.
                return
            }
            
            var image: UIImage?
            if let d = data {
                image = UIImage(data: d)
            }
            
            DispatchQueue.main.async() {
                    completion(image, error)
            }
            
        }
        self.dataTask?.resume()
    }
    
    private func showActivityIndicator() {
        
        if self.activityIndicator.superview == nil {
            self.activityIndicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            self.activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.activityIndicator.hidesWhenStopped = true
            self.addSubview(self.activityIndicator)
        }
        
        self.activityIndicator.startAnimating()
    }
}
