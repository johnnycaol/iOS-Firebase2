//
//  PostCell.swift
//  quick-chat
//
//  Created by Luchao Cao on 2016-06-29.
//  Copyright © 2016 Luchao Cao. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var request: Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    //TODO: for testing purpose
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
    func configureCell(post: Post, img: UIImage?) {
        self.post = post
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            if img != nil {
                // load it from cache
                self.showcaseImg.image = img
            } else {
                // not in the cache, do the request
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, error) in
                    if error == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        // add to cache
                        FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    } else {
                        print(error)
                        self.showcaseImg.isHidden = true
                    }
                })
            }
        } else {
            self.showcaseImg.isHidden = true
        }
    }
}
