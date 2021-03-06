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
import FirebaseDatabase



class PostCell: UITableViewCell {
    @IBOutlet weak var profileImage:UIImageView?
    @IBOutlet weak var showCaseImage:UIImageView?
    @IBOutlet weak var descriptionBody:UITextView?
    @IBOutlet weak var likesLabel:UILabel?
    @IBOutlet weak var name:UILabel?
    @IBOutlet weak var likePicture:UIImageView?
    
    var post:Post!
    var animation:UIViewAnimationTransition?
    
    var ref:FIRDatabaseReference!
    
    
    
    var request:Request?
    override func awakeFromNib() {
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(PostCell.changeLikeButton(_:)))
        likePicture?.addGestureRecognizer(tapGesture)
        
       
        
    }
    
    func changeLikeButton(_ sender:UITapGestureRecognizer) {
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(currentUserId!).child("likes").child(post.postKey).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
            if let doesNotExist = snapshot.value as? NSNull{
                self.likePicture!.image = UIImage(named:"heart-full")
                self.post.addLikes(true)
                  self.ref.child("users").child(currentUserId!).child("likes").child(self.post.postKey).setValue(true)
            }
            
            else {
                self.likePicture!.image = UIImage(named:"heart-empty")
                self.post.addLikes(false)
                  self.ref.child("users").child(currentUserId!).child("likes").child(self.post.postKey).removeValue()
                
            }
          
            
        })
        
    }
    
    override func draw(_ rect: CGRect) {
        profileImage!.layer.cornerRadius = profileImage!.frame.size.width/2
        profileImage?.clipsToBounds = true
        
        showCaseImage?.clipsToBounds = true
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func configureCell(_ post: Post, img: UIImage?){
        
        self.post = post
        var response: DefaultDataResponse?
        
        descriptionBody?.text = post.body
        
        likesLabel?.text = String(post.likes)
        
        name?.text = post.author
        
        
        if post.url.isEmpty == false{
            
            if img != nil {
                
                self.showCaseImage?.image = img}
            else {
                request = Alamofire.request(post.url).validate(contentType: ["image/*"]).response(completionHandler: { (resp) in
                    response = resp
                    if (response?.error == nil) {
                        
                        let img = UIImage(data: (response?.data)!)
                        self.showCaseImage?.image = img
                        FeedVC.imageCache.setObject(img!, forKey: self.post.url as AnyObject)
                        
                    }
                    else {
                        print("err:\n")
                        print(response?.error)
                    }
                    
                })

                
            }
        }
            
        else {
            self.showCaseImage?.isHidden = true
        }
        
        ref = FIRDatabase.database().reference()
        
        ref.child("users").child(currentUserId!).child("likes").child(post.postKey).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print(snapshot.value)
          
                        if let doesNotExist = snapshot.value as? NSNull{
                            self.likePicture?.image = UIImage(named:"heart-empty")
                        print("liked")
                        }
                        else {
                            self.likePicture?.image = UIImage(named:"heart-full")
                        print("not liked")
                        }
                        if let doesNotExistLike = snapshot.value as? NSNull{
                        //self.likePicture?.image = UIImage(named: "heart-empty")
                        }
                        
                        else {
                          
                        //self.likePicture?.image = UIImage(named: "heart-full")
                        }
            
        })
        
        
        
    }
}
