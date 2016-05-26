//
//  FeedVC.swift
//  DisplayCase
//
//  Created by Kashish Goel on 2016-05-23.
//  Copyright © 2016 Kashish Goel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    let ref:FIRDatabaseReference = FIRDatabase.database().reference()
    var refHandle:FIRDatabaseHandle!
    var postRef:FIRDatabaseReference!
    var posts:[Post] = []
//    let post:Post = Post()
   // let post:PostData = PostData()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        postRef = ref.child("posts")
        
       
        self.posts = []
         refHandle = postRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            let postDict = snapshot.value as! [String : AnyObject]
//           // print(postDict)
//            let key = snapshot.key
//            let post = Post(postKey: key, dictionary: postDict)
//            self.posts.append(post)
           // print("posts: \(self.posts)")
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//            print(snapshots)
                let count = snapshots.count
                for snap in snapshots {
                print("snap: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary <String,AnyObject> {
                        print("here")
                    let key = snap.key
                        let post = Post(postKey: key, dictionary: postDictionary)
                        self.posts.append(post)
                        print(self.posts)
                    }
                    
                    
                }
//                for snap in 0..<count {
//                
////                print("snap: \(snapshots[snap])")
////                    if let snapDictionary = snapshots[snap] as? Dictionary<String,AnyObject> {
////                    print("snapDict: \(snapDictionary)")
////                    }
//                   
//                }
//                for snap in snapshots {
//                
//                }
            }
            
            
self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print(post.body)
        return tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
    }
    
   
   

}

//class PostData:NSObject{
//    var author: String
//    var body: String
//    var uid: String
//    var url: String
//    
//    init(author: String, body: String, uid: String, url: String) {
//        self.uid = uid
//        self.author = author
//        self.url = url
//        self.body = body
//     
//    }
//    
//     convenience override init() {
//        self.init(author: "", body: "", uid: "", url:  "")
//    }
//
//
//}