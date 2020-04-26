//
//  MoreVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class MoreVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var subCommentsHt: NSLayoutConstraint!
    @IBOutlet weak var subCommentTv: UITableView!
    
    
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var studentsStatic: UILabel!
    @IBOutlet weak var feedBacSt: UILabel!
    @IBOutlet weak var moreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var moreCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsStarView: NSLayoutConstraint!
    @IBOutlet weak var seeMoreBtn: UIButton!
    
    @IBOutlet weak var seeAllBtn: UIButton!
    
    var parentNavigationController : UINavigationController?
    
    var courseId = ""
    
    @IBOutlet var moreCollection: UICollectionView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var postCommentBtn: UIButton!
   
    
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating_1")!
    let emptyStarImage: UIImage = UIImage(named: "rating_2")!
    
    
    var projectIdArray = NSMutableArray()
    var projectBannerArray = NSMutableArray()
    var bannerTypeArray = NSMutableArray()
    var project_thumbnailArray = NSMutableArray()
    
    
    var comment_id = [String]()
    var comment = [String]()
    var comment_rating = [String]()
    var created_on = [String]()
    var commentUserId = [String]()
     var subCommentsArray = [String]()
    
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.studentsStatic.text = languageChangeString(a_str: "Traines Projects")
        self.feedBacSt.text = languageChangeString(a_str: "Ratings and Responses")
        self.seeMoreBtn.setTitle(languageChangeString(a_str: "See More"), for: UIControl.State.normal)
         self.seeAllBtn.setTitle(languageChangeString(a_str: "See All"), for: UIControl.State.normal)
         self.postCommentBtn.setTitle(languageChangeString(a_str: "Post Comment"), for: UIControl.State.normal)
         self.replyBtn.setTitle(languageChangeString(a_str: "Reply"), for: UIControl.State.normal)
   
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTBold(labelName: studentsStatic, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: commentLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: dateLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTBold(labelName: feedBacSt, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: seeMoreBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_RTBold(buttonName: postCommentBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: seeAllBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: replyBtn, fontSize: 16)
            
        }
            
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTBold(labelName: studentsStatic, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: commentLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTReg(labelName: dateLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTBold(labelName: feedBacSt, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: seeMoreBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_LTBold(buttonName: postCommentBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: seeAllBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: replyBtn, fontSize: 16)
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.subCommentTv.estimatedRowHeight = 30
        self.subCommentTv.rowHeight = UITableView.automaticDimension
        
              NotificationCenter.default.addObserver(self, selector: #selector(nonExsittingProducts1(_:)), name: NSNotification.Name(rawValue: "subcomment"), object: nil)
        
      NotificationCenter.default.addObserver(self, selector: #selector(nonExsittingProducts(_:)), name: NSNotification.Name(rawValue: "comment"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(messageSentCall), name: NSNotification.Name(rawValue:"messageSent"), object: nil)
        
        moreVCData()
        
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @objc func messageSentCall()
    {
        self.moreVCData()
    }
    
    
    
    @objc func nonExsittingProducts1(_ notification: Notification)
    {
        
        self.moreVCData()
    }
    
    
    
    
    //MARK:- Notification Center Method
    @objc func nonExsittingProducts(_ notification: Notification)
    {
        
        self.moreVCData()
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool)
    {
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // star rating
    func getStarImage(starNumber: Int, forRating rating: Int) -> UIImage {
        
        if rating >= starNumber {
            return fullStarImage
        }  else {
            return emptyStarImage
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = moreCollection.bounds.width/3.2
        print(yourWidth)
        print(moreCollection.bounds.width/3.3)
        
        return CGSize(width: yourWidth, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
      
        return self.projectIdArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCell", for: indexPath) as! BannersCollectionViewCell
        
        if bannerTypeArray[indexPath.row] as? String == "image"
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.projectBannerArray[indexPath.row] as? String ?? ""))
            
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.project_thumbnailArray[indexPath.row] as? String ?? ""))
        }
        
        
         return cell
    }
    
    
    
    @IBAction func seeMoreBtnTap(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrainerReviewVC")as! TrainerReviewVC
        vc.navigationChecking = "moreVC"
        vc.courseId = courseId

        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func seeAllBtnTap(_ sender: Any) {
        
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "CatViewController")as! CatViewController
        vc.moreImageArray = projectBannerArray
        vc.moreCoverTypeArray = bannerTypeArray
        vc.moreThumbnailArray = project_thumbnailArray
       navigationController?.pushViewController(vc, animated: false)
        
    }
    
    
    @IBAction func replyBtnTap(_ sender: Any) {
        
     let product_ID = comment_id[0]
        
        let gotoNotification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        gotoNotification.topic_Id = product_ID
        gotoNotification.courseID = courseId
        
        gotoNotification.modalPresentationStyle = .overCurrentContext
        
        
        let navi = UINavigationController(rootViewController: gotoNotification)
        navi.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        navi.modalPresentationStyle = .overCurrentContext
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: false, completion: nil)
        
    }
    
    
    
    
    @IBAction func postCommentBtnTap(_ sender: Any)
    {
        
        let gotoNotification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        gotoNotification.topic_Id = courseId
        gotoNotification.modalPresentationStyle = .overCurrentContext
        
        let navi = UINavigationController(rootViewController: gotoNotification)
        navi.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        navi.modalPresentationStyle = .overCurrentContext
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if subCommentsArray.count > 0
       {
         return 1

        }
       else
       {
       return  0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subComment1", for: indexPath) as! NotificationsTableViewCell
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.subCommentLbl, fontSize: 12)
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTReg(labelName: cell.subCommentLbl, fontSize: 12)
        }
        
        cell.subCommentLbl.text = subCommentsArray[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    // moredata service call
    
    func moreVCData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let aboutData = "\(base_path)services/course_details?"
            
            //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang": language,"course_id":courseId,"user_id":myuserID]
            
            Alamofire.request(aboutData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? Dictionary<String, Any>
                        {
                            
                            if let moreData = response1["projects"] as? [[String:Any]]
                            {
                                if(self.projectBannerArray.count > 0)||(self.projectIdArray.count > 0)||(self.bannerTypeArray.count > 0) ||
                                    (self.project_thumbnailArray.count > 0)
                                {
                                    self.projectBannerArray.removeAllObjects()
                                    self.projectIdArray.removeAllObjects()
                                    self.bannerTypeArray.removeAllObjects()
                                    self.project_thumbnailArray.removeAllObjects()
                                    
                                }
                                
                                
                                if moreData.count > 0
                                {
                                    
                                    
                                    for i in 0..<moreData.count
                                    {
                                        if let imgCover = moreData[i]["project_banner"] as? String
                                        {
                                            self.projectBannerArray.add(base_path+imgCover)
                                        }
                                        
                                        if let project_thumbnail = moreData[i]["project_thumbnail"] as? String
                                        {
                                            self.project_thumbnailArray.add(base_path+project_thumbnail)
                                        }
                                        
                                        if let id = moreData[i]["project_id"] as? String
                                        {
                                            self.projectIdArray.add(id)
                                            
                                        }
                                        if let type = moreData[i]["banner_type"] as? String
                                        {
                                            self.bannerTypeArray.add(type)
                                            
                                        }
                                        
                                    }
                                    DispatchQueue.main.async {
                                        
                                        self.moreCollection.reloadData()
                                        let height = self.moreCollection.collectionViewLayout.collectionViewContentSize.height
                                        self.moreCollectionHeight.constant = height
                                        
                                        self.view.layoutIfNeeded()
                                        
                                    }
                                    
                                }
                                else{
                                    
                                    self.moreViewHeight.constant = self.moreViewHeight.constant - self.moreCollectionHeight.constant
                                    self.moreCollectionHeight.constant = 0
                                }
                                
                            }
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            if let commentsData = response1["comments"] as? [[String:Any]]
                            {
                                if(self.comment_id.count > 0)||(self.comment.count > 0)||(self.comment_rating.count > 0) ||
                                    (self.created_on.count > 0) || (self.commentUserId.count > 0)
                                    || (self.subCommentsArray.count>0)
                                {
                                    self.comment_id.removeAll()
                                    self.comment.removeAll()
                                    self.comment_rating.removeAll()
                                    self.created_on.removeAll()
                                    self.commentUserId.removeAll()
                                    self.subCommentsArray.removeAll()
                                    
                                }
                                
                                if commentsData.count > 0
                                {
                                    for i in 0..<commentsData.count
                                    {
                                        if let comment = commentsData[i]["comment"] as? String
                                        {
                                            self.comment.append(comment)
                                        }
                                        if let user_id = commentsData[i]["user_id"] as? String
                                        {
                                            self.commentUserId.append(user_id)
                                        }
                                        if let comment_id = commentsData[i]["comment_id"] as? String
                                        {
                                            self.comment_id.append(comment_id)
                                        }
                                        if let comment_rating = commentsData[i]["comment_rating"] as? String
                                        {
                                            self.comment_rating.append(comment_rating)
                                        }
                                        if let time = commentsData[i]["time"] as? String
                                        {
                                            self.created_on.append(time)
                                        }
                                       
                                    }
                                    
                                    if let subComments = commentsData[0]["sub_comments"] as? [[String:Any]]
                                    {
                                        for i in 0..<subComments.count
                                        {
                                            if let sub_comment = subComments[i]["sub_comment"] as? String
                                            {
                                                self.subCommentsArray.append(sub_comment)
                                            }
                                        }
                                        if subComments.count == 0
                                        {
                                            self.subCommentsHt.constant = 0
                                            self.view.layoutIfNeeded()
                                        }
                                    }
                                    
                                    
                                    print("jhfdsjhhjgdf",self.subCommentsArray)
                                    
                                    DispatchQueue.main.async
                                        {
                                            self.replyBtn.isHidden = false
                                            self.commentLbl.text = self.comment[0]
                                            self.dateLbl.text = self.created_on[0]
                                            print("mycommentfdfgdf",self.comment)
                                           
                                            let moreRate = Int(self.comment_rating[0])
                                            if let ourRating = moreRate {
                                                if ourRating > 0
                                                {
                                                self.star1.image = self.getStarImage(starNumber: 1, forRating: ourRating)
                                                self.star2.image = self.getStarImage(starNumber: 2, forRating: ourRating)
                                                self.star3.image = self.getStarImage(starNumber: 3, forRating: ourRating)
                                                self.star4.image = self.getStarImage(starNumber: 4, forRating: ourRating)
                                                self.star5.image = self.getStarImage(starNumber: 5, forRating: ourRating)
                                                }
                                                else
                                                {
                                                     self.commentsStarView.constant = 0
                                                }
                                            }
                                            
                                            self.subCommentTv.reloadData()
                                             self.subCommentTv.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                             self.view.layoutIfNeeded()
                                            
                                    }
                                    
                                }else{
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    self.seeMoreBtn.isHidden = true
                                    self.commentsStarView.constant = 0
                                    self.replyBtn.isHidden = true
                                    self.subCommentsHt.constant = 0
                                    
                                }
                                
                            }
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message:message,style: style1)
                    }
                    
                }
                
            }
            
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
           showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        subCommentTv.layer.removeAllAnimations()
        subCommentsHt.constant = subCommentTv.contentSize.height
        moreCollection.layer.removeAllAnimations()
        moreCollectionHeight.constant = moreCollection.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
}

