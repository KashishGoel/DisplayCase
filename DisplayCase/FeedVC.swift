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
    @IBOutlet var webView:UIWebView!
    
    var imagePicker = UIImagePickerController()

    static var imageCache = NSCache<AnyObject, AnyObject>()
    
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
        refHandle = postRef.observe(FIRDataEventType.value, with: { (snapshot) in
            print(snapshot)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[(indexPath as NSIndexPath).row]
        print(post.body)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell{
           cell.request?.cancel()
//
            var img:UIImage?
            
//            
            if post.url.isEmpty == false{
                
                let url = post.url
                img = FeedVC.imageCache.object(forKey: url as AnyObject) as? UIImage
            
            }
            
            cell.configureCell(post, img: img)
            return cell
        }
            
        else {
            return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostCell
        }
        
        //return tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[(indexPath as NSIndexPath).row]
        
        if post.url.isEmpty {
        return 200
        }
        else {
        return tableView.estimatedRowHeight
        }
        
    }
    
    
    //image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        cameraButton.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func showImagePicker(){
      //print("here")
    self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postButtonPressed(_ sender: AnyObject) {
        print("pressed")
        print(postDescription.text)
        if let text = postDescription.text , postDescription.text != "" {
            print(text)
            if let img = cameraButton.image {
            let postUrl = "https://post.imageshack.us/upload_api.php/post"
                let url = URL(string: postUrl)
                let imgData = UIImageJPEGRepresentation(img, 0.1)
                let apiKey = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".data(using: String.Encoding.utf8)
                
                let json = "json".data(using: String.Encoding.utf8)
                

                
                
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        //multipartFormData.append(uploadData, withName: "upload_data")
                        multipartFormData.append(imgData!, withName: "fileupload", fileName: "image", mimeType: "image/jpg")
                        multipartFormData.append(apiKey!, withName: "key")
                        multipartFormData.append(json!, withName: "format")
                        
                        //formData = multipartFormData
                    },
                    to: url!,
                    encodingCompletion: { result in
                        switch result {
                        case .success(let upload, _, _):
                            upload.responseJSON(completionHandler: { response in
                            
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
                                
                                
                            })
                            
                            
                        case .failure(let err):
                            print("errors:\n")
                            print(err)
                            //expectation.fulfill()
                        }
                    }
                )
                
                
//                Alamofire.upload(.POST, url!, multipartFormData: { (MultiPartFormData) in
//                    MultiPartFormData.appendBodyPart(data: imgData!, name: "fileupload", fileName: "image", mimeType: "image/jpg")
//                    MultiPartFormData.appendBodyPart(data: apiKey!, name: "key")
//                    MultiPartFormData.appendBodyPart(data: json!, name: "format")
//                }) {encodingResult in
//                    
//                    switch(encodingResult){
//                    case .Success(let upload, _, _):
//                        upload.responseJSON { response in
//                            
//                            if let info = response.result.value as? Dictionary<String, AnyObject> {
//                                
//                                
//                                
//                                if let links = info["links"] as? Dictionary<String, AnyObject> {
//                                    
//                                    if let imgLink = links["image_link"] as? String {
//                                        
//                                        print("LINK: \(imgLink)")
//                                        //self.ref.child("users").child(user!.uid).setValue(["username": username])
//                                                                                            //let key = self.ref.child("posts").childByAutoId().key
//                                                                                           // self.ref.child("posts").child(key).setValue("This is it")
//                                        self.addPostToFirebase(imgLink, description: self.postDescription.text!)
//                                        self.postDescription.text = ""
//                                    }
//                                    else {
//                                    self.addPostToFirebase(nil, description: self.postDescription.text!)
//                                         self.postDescription.text = ""
//                                    }
//                                    
//                                }
//                                
//                            }
//                            
//                        } case .Failure(let error):
//                            
//                            print(error)
//                    
//                    }
//                    
//                }
            }
        
        
            cameraButton.image = UIImage(named: "camera")
        }
    }
    
    func addPostToFirebase(_ imgUrl: String?, description:String) {
        let key = self.ref.child("posts").childByAutoId().key
        guard let authorName = FIRAuth.auth()?.currentUser?.displayName , FIRAuth.auth()?.currentUser?.displayName != nil else {
        return }
        
        if imgUrl != nil {
        
        
        if let postBody = self.postDescription.text , self.postDescription.text != nil {
            
        let post:[String:AnyObject] = ["author": authorName as AnyObject,
                    "body": postBody as AnyObject,
                     "likes": 0 as AnyObject,
                    "url": imgUrl! as AnyObject]
        let childUpdates = ["/posts/\(key)": post]
        self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("posts").setValue([key:"true"])
        self.ref.updateChildValues(childUpdates)
            tableView.reloadData()
            print("uploaded to firebase")
            
            }
        else {
            print("post desc is empty")
            }
            
        }
        
    
    }
    
}

