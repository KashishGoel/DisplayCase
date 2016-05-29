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
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cameraButton:UIImageView!
    @IBOutlet var postDescription:UITextField!
    let ref:FIRDatabaseReference = FIRDatabase.database().reference()
    var refHandle:FIRDatabaseHandle!
    var postRef:FIRDatabaseReference!
    var posts:[Post] = []
    var tapGesture = UITapGestureRecognizer()
    
    var imagePicker = UIImagePickerController()

    static var imageCache = NSCache()
    //    let post:Post = Post()
    // let post:PostData = PostData()
    
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        postRef = ref.child("posts")
        tableView.estimatedRowHeight = 364
        imagePicker.delegate = self
        tapGesture.numberOfTapsRequired = 1
    
        tapGesture.addTarget(self, action: #selector(FeedVC.showImagePicker))
        cameraButton.addGestureRecognizer(tapGesture)
        
        
        
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
                //                let count = snapshots.count
                for snap in snapshots {
                    print("snap: \(snap)")
                    
                    if let postDictionary = snap.value as? Dictionary <String,AnyObject> {
                        //print("here")
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
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("postCell") as? PostCell{
           cell.request?.cancel()
//
            var img:UIImage?
            
//            
            if post.url.isEmpty == false{
                
                let url = post.url
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            
            }
            
            cell.configureCell(post, img: img)
            return cell
        }
            
        else {
            return tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
        }
        
        //return tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if post.url.isEmpty {
        return 200
        }
        else {
        return tableView.estimatedRowHeight
        }
        
    }
    
    
    //image picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        cameraButton.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func showImagePicker(){
      //print("here")
    self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonPressed(sender: AnyObject) {
        print("pressed")
        print(postDescription.text)
        if let text = postDescription.text where postDescription.text != "" {
            if let img = cameraButton.image {
            let postUrl = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: postUrl)
                let imgData = UIImageJPEGRepresentation(img, 0.1)
                let apiKey = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)
                
                let json = "json".dataUsingEncoding(NSUTF8StringEncoding)
                
                Alamofire.upload(.POST, url!, multipartFormData: { (MultiPartFormData) in
                    MultiPartFormData.appendBodyPart(data: imgData!, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                    MultiPartFormData.appendBodyPart(data: apiKey!, name: "key")
                    MultiPartFormData.appendBodyPart(data: json!, name: "format")
                }) {encodingResult in
                    
                    switch(encodingResult){
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                                
                                
                                
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    
                                    if let imgLink = links["image_link"] as? String {
                                        
                                        print("LINK: \(imgLink)")
                                        //self.ref.child("users").child(user!.uid).setValue(["username": username])
                                                                                            //let key = self.ref.child("posts").childByAutoId().key
                                                                                           // self.ref.child("posts").child(key).setValue("This is it")
                                        self.addPostToFirebase(imgLink, description: self.postDescription.text!)
                                        self.postDescription.text = ""
                                    }
                                    else {
                                    self.addPostToFirebase(nil, description: self.postDescription.text!)
                                         self.postDescription.text = ""
                                    }
                                    
                                }
                                
                            }
                            
                        } case .Failure(let error):
                            
                            print(error)
                    
                    }
                    
                }
            }
        
        
            cameraButton.image = UIImage(named: "camera")
        }
    }
    
    func addPostToFirebase(imgUrl: String?, description:String) {
        let key = self.ref.child("posts").childByAutoId().key
        guard let authorName = FIRAuth.auth()?.currentUser?.displayName where FIRAuth.auth()?.currentUser?.displayName != nil else {
        return }
        
        if imgUrl != nil {
        
        
        if let postBody = self.postDescription.text where self.postDescription.text != nil {
            
        let post:[String:AnyObject] = ["author": authorName,
                    "body": postBody,
                     "likes": 0,
                    "url": imgUrl!]
        let childUpdates = ["/posts/\(key)": post]
        self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("posts").setValue([key:"true"])
        self.ref.updateChildValues(childUpdates)
            print("uploaded to firebase")
            
            }
        else {
            print("post desc is empty")
            }
            
        }
        
    
    }
    
}

