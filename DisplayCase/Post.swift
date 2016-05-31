//
//  Post.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-25.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class Post{

    
    var _author:String!
     var _body:String!
     var _likes:Int!
//     private var _uid:String!
    var _url:String?
     var _postKey:String!
    var _postRef:FIRDatabaseReference!
   
    
    var author:String {
        return _author
    }
    
    var body:String {
    return _body
    }
    
    var likes:Int {
        return _likes
    }
    
    var url:String {
    return _url!
   }
    
    var postKey:String{
    return _postKey
    }

   
    
    init (author:String,body:String, likes:Int, url:String) {
        self._author = author
        self._body = body
        //self._likes = likes
        self._url = url
    }
    
    init (postKey:String, dictionary:Dictionary <String,AnyObject>) {
    self._postKey = postKey
        if let likes = dictionary["likes"] as! Int?{
        self._likes = likes
        }
        
//        if let name = dictionary["author"]{
//            self._author = name as! String
//        
//        }
        if let url = dictionary["url"] {
        self._url = url as? String
        }
        if let description = dictionary["body"]{
        self._body = description as! String
        }
        
        if let name = dictionary["author"]{
        self._author = name as! String
            self._postRef =  FIRDatabase.database().reference().child("users").child(currentUserId!).child("likes").child(_postKey)
        }
        
        
    
    }
    
    
    func addLikes(add:Bool){
        if add == true {
        _likes = _likes + 1
            _postRef.child("likes").setValue(_likes)
        }
        else {
        _likes = _likes - 1
             _postRef.child("likes").setValue(_likes)
        }
    
    }
    
    
    
    
    
    
    


}
