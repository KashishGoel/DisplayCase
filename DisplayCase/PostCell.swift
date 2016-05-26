//
//  PostCell.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-23.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView?
    @IBOutlet weak var showCaseImage:UIImageView?
    @IBOutlet weak var descriptionBody:UITextView?
    @IBOutlet weak var likesLabel:UILabel?
    
    var post:Post!
    override func awakeFromNib() {
     
}
    
    override func drawRect(rect: CGRect) {
           profileImage!.layer.cornerRadius = profileImage!.frame.size.width/2
           profileImage?.clipsToBounds = true
        
        showCaseImage?.clipsToBounds = true
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
    }
    
    func configureCell(post: Post){
        
    self.post = post
        
        
        descriptionBody?.text = post.body
      
        likesLabel?.text = String(post.likes)
        
        
        
        
    
    }
}
