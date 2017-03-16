//
//  AlbumsSearchViewController.swift
//  Spotify
//
//  Created by Andrii Kurshyn on 02.11.16.
//  Copyright © 2016 Andriik. All rights reserved.
//

import UIKit

class AlbumsSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    var request = SearchRequest<Album>()
    var albums = [Album]()
    var isSearchBarFirstResponder = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set top inset for status bar
        self.collectionView.contentInset.top = 20
        
        self.request.keyword = "ten"
        self.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let collectionViewLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        // counting the number of cells fit to view width
        let countCellInLine = floor(self.view.bounds.width / collectionViewLayout.itemSize.width)
        
        // calculation total of the remaining free space
        let totalSpacing = self.view.bounds.width - (collectionViewLayout.itemSize.width * countCellInLine)
        
        // calculation spacing for cell
        let spacing = floor(totalSpacing / (countCellInLine+1))
        
        self.collectionView.contentInset.left = spacing
        self.collectionView.contentInset.right = spacing
        
        collectionViewLayout.minimumInteritemSpacing = spacing
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let toOrientation = UIDevice.current.orientation
        if toOrientation == .landscapeLeft || toOrientation == .landscapeRight {
            self.collectionView.contentInset.top = 0
        } else {
            self.collectionView.contentInset.top = 20
        }
    }
    
    func load() {
        
        if self.request.offset == 0 && self.albums.count != 0 {
            
            // removed all albums for first result
            self.collectionView.performBatchUpdates({
                let count = self.albums.count
                self.collectionView.deleteItems(at: (0..<count).map({ IndexPath(item: $0, section: 0) }))
                self.albums.removeAll()
            }, completion: nil)
        }
        
        self.request.executeRequest { (result, error) in
            
            if let albums = result?.items {
                
                self.collectionView.performBatchUpdates({

                    let wasCount = self.albums.count
                    self.albums = self.albums + albums
 
                    let indexPaths = (wasCount..<self.albums.count).map({ IndexPath(item: $0, section: 0) })
                    self.collectionView.insertItems(at: indexPaths)
                    
                }, completion: nil)
                
            }
        }
        
    }
    
    //MARK: UISearchBar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.isSearchBarFirstResponder = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarResignFirstResponder()
        
        searchBar.text = self.request.keyword
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarResignFirstResponder()
        
        if let text = searchBar.text, text != self.request.keyword {
            self.request.offset = 0
            self.request.keyword = text
            self.load()
        }
    }
    
    func searchBarResignFirstResponder() {
        self.isSearchBarFirstResponder = false
        
        let headerView = self.collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? SearchBarCollectionReusableView
        headerView?.searchBar.resignFirstResponder()
        headerView?.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // MARK: UICollection DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        
        cell.album = self.albums[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if UICollectionElementKindSectionHeader == kind {
            let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"SearchHeader" ,for: indexPath) as! SearchBarCollectionReusableView
            header.searchBar.delegate = self
            header.searchBar.text = self.request.keyword
            return header
        }
        
        return self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"Bottom" ,for: indexPath)
    }
    
    // MARK: UICollection Delegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let offset = self.request.offset
        let limit = self.request.limit
        
        let row = indexPath.row + 1
        if row % limit == 0 {
            
            let count = self.albums.count
            
            if row >= offset - limit && count % limit == 0 {
                self.request.offset += limit
                self.load()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isSearchBarFirstResponder {
            self.searchBarResignFirstResponder()
        }
    }
    
}
