//
//  PostCell.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-23.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView?
    @IBOutlet weak var showCaseImage:UIImageView?
    @IBOutlet weak var descriptionBody:UITextView?
    @IBOutlet weak var likesLabel:UILabel?
    
    var post:Post!
    
    var request:Request?
    override func awakeFromNib() {
     
}
    
    override func drawRect(rect: CGRect) {
           profileImage!.layer.cornerRadius = profileImage!.frame.size.width/2
           profileImage?.clipsToBounds = true
        
        showCaseImage?.clipsToBounds = true
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    func configureCell(post: Post, img: UIImage?){
        
    self.post = post
        
        
        descriptionBody?.text = post.body
      
        likesLabel?.text = String(post.likes)
        
        if post.url.isEmpty == false{
            if img != nil {
                self.showCaseImage?.image = img}
            else {
            request = Alamofire.request(.GET, post.url).validate(contentType: ["image/s"]).response(completionHandler: { (request, response, data, error) in
                if error == nil {
                
                    if let img = UIImage(data: data!) {
                    self.showCaseImage?.image = img
                        FeedVC.imageCache.setObject(img, forKey: self.post.url)
                    }                }
            })
            }
        }
        
        else {
        self.showCaseImage?.hidden = true
        }
        
    
        
    
    }
}
