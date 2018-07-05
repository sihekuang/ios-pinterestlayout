//
//  NewsfeedCollectionViewController.swift
//  Facebook+Research
//
//  Created by Duc Tran on 3/20/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class NewsfeedCollectionViewController : UICollectionViewController
{
    var searchController: UISearchController!
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchPosts()
//        collectionView?.contentInset = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        if let pinterestLayout = collectionView?.collectionViewLayout as? PinterestLayout{
            pinterestLayout.delegate = self
        }
        
//        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = CGSize(width: 200, height: 300)
//        }
    }
    
    func fetchPosts()
    {
        self.posts = Post.fetchPosts()
        self.collectionView?.reloadData()
    }
}

extension NewsfeedCollectionViewController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCollectionViewCell
        cell.post = self.posts?[indexPath.item]
        return cell
    }
}


//MARK: Pinterest Layout Delegate
extension NewsfeedCollectionViewController: PinterestLayoutDelegate{
    var numberOfColumns: Int {
        return 3
    }
    
    var cellPadding: CGFloat {
        return 5
    }
    
    func cellHeight(at index: Int, cellWidth: CGFloat) -> CGFloat {
        guard let posts = self.posts else {return 0}
        guard let image = posts[index].image else {return 60}
        
        let boundingRect = CGRect(x: 0, y: 0, width: cellWidth, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: boundingRect)
        
        return rect.height + 60
        
    }
    
    
}














