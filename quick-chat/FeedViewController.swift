//
//  FeedViewController.swift
//  quick-chat
//
//  Created by Luchao Cao on 2016-06-29.
//  Copyright © 2016 Luchao Cao. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    static var imageCache = Cache<AnyObject,AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Auto adjust height
        tableView.estimatedRowHeight = 358
        
        DataService.ds.REF_POSTS.observe(.value, with: { snapshot in
            //print(snapshot.value)
            
            self.posts = []//completely replace all the data so empty out the array first
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    
                    // Convert each one to a dictionary
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: For testing purpose
        let post = posts[indexPath.row]
//        print(post.postDescription)
//        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.request?.cancel()
            var img: UIImage?
            if let url = post.imageUrl {
                //use url as the key of the cache
                img = FeedViewController.imageCache.object(forKey: url) as? UIImage
            }
            
            cell.configureCell(post: post, img: img)
            return cell
        } else {
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
}
