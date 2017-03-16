//
//  AlbumCollectionViewCell.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 02.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var album: Album? {
        didSet {
            guard let album = album else {
                return
            }
            
            self.nameLabel.text = album.name
            self.imageView.url = URL(string: album.imageURL(by: .middle))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.parentView.layer.cornerRadius = 5.0
        self.parentView.layer.shouldRasterize = true
        self.parentView.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.nameLabel.text = nil
    }
}
