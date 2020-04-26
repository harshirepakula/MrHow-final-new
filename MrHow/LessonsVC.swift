//
//  LessonsVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AVKit


var player = AVPlayer()
var playerViewcontroller = AVPlayerViewController()

class LessonsVC: UIViewController,AVPlayerViewControllerDelegate {
    
    var parentNavigationController : UINavigationController?
    
    @IBOutlet weak var introductionSt: UILabel!
    @IBOutlet weak var lessonTvHeight: NSLayoutConstraint!
    
    @IBOutlet var lessonsTV: UITableView!
    @IBOutlet var trainerView: UIView!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var authorFollowersLbl: UILabel!
    @IBOutlet weak var trainerFollow: UIButton!
   
    @IBOutlet weak var introductionDuration: UILabel!
    @IBOutlet weak var introductionImg: UIImageView!
   
    @IBOutlet weak var downloadableOrNot: UIButton!
    @IBOutlet weak var courseNameLbl: UILabel!
    
    @IBOutlet weak var authorImg: UIImageView!
    @IBOutlet weak var purchaseLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var downLoadSt: UILabel!
    
    var preferredPeakBitRate = Double()
    
    var courseDuration = ""
    var courseName = ""
    var courseTitle = ""
    var courseRating = ""
    var coursePurchased = ""
    var coursePrice = ""
    var courseOfferPrice = ""
    var introductionVideo = ""
    var introductionThumbnail = ""
    var authorId = ""
    var authorname = ""
    var authorProfilePic = ""
    var coursePurchaseStatus = ""
    var courseCompletionStatus =  ""
    var wishlistStatus = ""
    var authorfollowers = ""
    var followedStatus = ""
    var downloadableStatus = ""
    var courseId = ""
    
    // lessons
    var lessonId = [String]()
    var lessonName = [String]()
    var lessonVideo = [String]()
    var lessonThumbnail = [String]()
    var lessonTypeArray = [String]()
    
    // material
    var materialName = [String]()
    var materiaImg = [String]()
    var materialTypeArray = [String]()
    var materialThumbArray = [String]()
    
    
    var expanded1:Bool = true
    var expanded2:Bool = false
    var selectedSection = Int()

    
    let sectionTitlesArr = [languageChangeString(a_str: "Welcome to the course!"),languageChangeString(a_str: "Material of the Course")] as? [String] ?? [""]
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
     
        
        let nib = UINib(nibName: "HeaderCell", bundle: nil)
        self.lessonsTV.register(nib, forCellReuseIdentifier: "HeaderCell")
        
        let tapRatings = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        trainerView.isUserInteractionEnabled = true
        trainerView.addGestureRecognizer(tapRatings)
        self.introductionSt.text = languageChangeString(a_str: "Introduction Video")
        self.downLoadSt.text = languageChangeString(a_str: "Download classes")
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: introductionSt, fontSize: 17)
            GeneralFunctions.labelCustom_RTReg(labelName: authorNameLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: authorFollowersLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTBold(labelName: courseNameLbl, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: durationLbl, fontSize: 11)
            GeneralFunctions.labelCustom_RTReg(labelName: ratingLbl, fontSize: 11)
            GeneralFunctions.labelCustom_RTReg(labelName: purchaseLbl, fontSize: 11)
            GeneralFunctions.buttonCustom_RTReg(buttonName: trainerFollow, fontSize: 16)
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: introductionSt, fontSize: 17)
            GeneralFunctions.labelCustom_LTMedium(labelName: authorNameLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: authorFollowersLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTBold(labelName: courseNameLbl, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: durationLbl, fontSize: 11)
            GeneralFunctions.labelCustom_LTMedium(labelName: ratingLbl, fontSize: 11)
            GeneralFunctions.labelCustom_LTMedium(labelName: purchaseLbl, fontSize: 11)
            GeneralFunctions.buttonCustom_LTReg(buttonName: trainerFollow, fontSize: 16)
        }
        
        
    
        //lessonData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(addorRemove(_:)), name: NSNotification.Name(rawValue: "AddOrRemoveWishList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(trainerUpdateStatus(_:)), name: NSNotification.Name(rawValue: "trainerStatus"), object: nil)
        
        lessonData()
        
    }

    
    //MARK:- Notification Center Method
    @objc func addorRemove(_ notification: Notification)
    {
       
        
        self.lessonData()
    }
    
    //MARK:- Notification Center Method
    @objc func trainerUpdateStatus(_ notification: Notification)
    {
        
        self.lessonData()
    }
    
    
    
    
    // MARK: - viewWillDisappear
    
  
    

    
    @IBAction func playVideo(_ sender: UIButton)
    {
         // videoToPlay(videoLink: self.introductionVideo)
        
        guard let url = URL(string: introductionVideo) else {
            return
        }
        
        player = AVPlayer(url: url)
        
        
        playerViewcontroller.player = player
        playerViewcontroller.showsPlaybackControls = true
        
        
        present(playerViewcontroller, animated: true) {
            player.play()
        }
        
        
    }
    
    
    
    func videoToPlay(videoLink:String)
    {
        if coursePurchaseStatus == "1"
        {
           
            guard let url = URL(string: videoLink) else {
                return
            }
            
            player = AVPlayer(url: url)
            
            
            playerViewcontroller.player = player
            playerViewcontroller.showsPlaybackControls = true
            
            
            present(playerViewcontroller, animated: true) {
                player.play()
            }
           
            
        }
          else
          {
            self.showToastForAlert(message: languageChangeString(a_str:"Please Purchase Your Course") ?? "",style: style1)
          }

    }


 
    
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainerProfileVC") as! TrainerProfileVC
         vc.trainerId = self.authorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func buyNowBtnTap(_ sender: Any) {
       
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseDetailsVC") as! PurchaseDetailsVC
        vc.courseIdToBuy = self.courseId
        vc.priceofTheCourse = self.coursePrice
        vc.courseToBuy = self.courseTitle
       //print(self.courseTitle)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    @IBAction func addToWishListBtn(_ sender: Any)
    {
        wishList()
    }
    
    
    
    @IBAction func followTrainerBtnTap(_ sender: Any)
    {
        trainerStatus()
    }
    

    // add / remove from wish list post service call
    
    func wishList()
    {
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
                
            let wishListService = "\(base_path)services/add_to_wishlist"
                
                //" https://volive.in/mrhow_dev/services/add_to_wishlist
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
             let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
                let parameters: Dictionary<String, Any> = ["lang" :language,
                                "api_key":APIKEY,"user_id":myuserID,"course_id":courseId]
                
                print(parameters)
                
                Alamofire.request(wishListService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>{
                       
                        print(responseData)
                        
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if status == 1
                        {
                           
                            self.showToastForAlert(message: message, style: style1)
                          NotificationCenter.default.post(name: NSNotification.Name("AddOrRemoveWishList"), object: nil)
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message, style: style1)
                        }
                    }
                }
            }
                
            else
            {
                MobileFixServices.sharedInstance.dissMissLoader()
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
                
            }
            
        }
    
    
    
    // follow / unfollow  trainer post service call

    
    func trainerStatus()
    {
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let trainerService = "\(base_path)services/follow_trainer"
            
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang" :language,
                                                       "api_key":APIKEY,"user_id":myuserID,"author_id":authorId]
            
            print(parameters)
            
            Alamofire.request(trainerService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        
                        self.showToastForAlert(message: message, style: style1)
                        NotificationCenter.default.post(name: NSNotification.Name("trainerStatus"), object: nil)
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    
    

    // lesson data service call
    
    func lessonData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
                
            let lessonData = "\(base_path)services/course_details?"
                
            //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang":language,"course_id":courseId,"user_id":myuserID]
            
            print(parameters)
            Alamofire.request(lessonData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
            if let responseData = response.result.value as? Dictionary<String, Any>
            {
                        
                 let status = responseData["status"] as! Int
                  let message = responseData["message"] as! String
                  if status == 1
                  {
                     if let response1 = responseData["data"] as? Dictionary<String, Any>
                     {
                       
                                
                        if let lessonDetails = response1["lessons"] as? [[String:Any]]
                        {
                            if lessonDetails.count > 0
                            {
                               self.lessonVideo.removeAll()
                                self.lessonThumbnail.removeAll()
                                self.lessonId.removeAll()
                                self.lessonName.removeAll()
                                self.lessonTypeArray.removeAll()
                            }
                            
                            for i in 0..<lessonDetails.count
                            {
                                if let lesson_id = lessonDetails[i]["lesson_id"] as? String
                                {
                                    self.lessonId.append(lesson_id)
                                }
                                if let lesson_thumbnail = lessonDetails[i]["lesson_thumbnail"] as? String
                                {
                                    self.lessonThumbnail.append(base_path+lesson_thumbnail)
                                }
                                if let lesson_name = lessonDetails[i]["lesson_name"] as? String
                                {
                                    self.lessonName.append(lesson_name)
                                }
                                if let video = lessonDetails[i]["video"] as? String
                                {
                                    self.lessonVideo.append(base_path+video)
                                }
                                if let lesson_type = lessonDetails[i]["lesson_type"] as? String
                                {
                                    self.lessonTypeArray.append(lesson_type)
                                }
                                
                                
                                
                                }
                              
                            
                               DispatchQueue.main.async {
//                                 MobileFixServices.sharedInstance.dissMissLoader()
                                        self.lessonsTV.reloadData()
                                self.lessonsTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                self.view.layoutIfNeeded()
                                
                                   }
                            }
                        
                        if let materialOfTheCourse = response1["materials"] as? [[String:Any]]
                        {
                            if materialOfTheCourse.count > 0
                            {
                                self.materialName.removeAll()
                                self.materiaImg.removeAll()
                                self.materialTypeArray.removeAll()
                                self.materialThumbArray.removeAll()

                            }

                            for i in 0..<materialOfTheCourse.count
                            {
                                if let material_name = materialOfTheCourse[i]["material_name"] as? String
                                {
                                    self.materialName.append(material_name)
                                }
                                if let material_file = materialOfTheCourse[i]["material_file"] as? String
                                {
                                    self.materiaImg.append(base_path+material_file)
                                }
                                if let material_type = materialOfTheCourse[i]["material_type"] as? String
                                {
                                    self.materialTypeArray.append(material_type)
                                }
                                if let material_thumb = materialOfTheCourse[i]["material_thumb"] as? String
                                {
                                    self.materialThumbArray.append(base_path+material_thumb)
                                }
                                
                                
                               
                            }
                            
                            //print(self.materialName)
                            DispatchQueue.main.async {
                                
                                MobileFixServices.sharedInstance.dissMissLoader()
                                
                                self.lessonsTV.reloadData()
                                self.lessonsTV.delegate = self
                                self.lessonsTV.dataSource = self
                                
                                self.lessonsTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                                self.view.layoutIfNeeded()
                            }
                            
                           
                        }
                        
                      
                                
                            if let detailsData = response1["details"] as?
                                [String:Any]
                             {
                                
                                if let duration = detailsData["duration"] as? String
                                {
                                    self.courseDuration = duration
                                }
                                if let rating = detailsData["total_ratings"] as? String
                                {
                                    self.courseRating = rating
                                }
                                if let purchased = detailsData["purchased"] as? String
                                {
                                    self.coursePurchased = purchased
                                }
                                if let price = detailsData["price"] as? String
                                {
                                    self.coursePrice = price
                                }
                                if let offer_price = detailsData["offer_price"] as? String
                                {
                                    self.courseOfferPrice = offer_price
                                }
                                if let introduction_thumbnail = detailsData["introduction_thumbnail"] as? String
                                {
                                    self.introductionThumbnail = base_path+introduction_thumbnail
                                }
                                if let introduction_video = detailsData["introduction_video"] as? String
                                {
                                    self.introductionVideo = base_path+introduction_video
                                }
                                if let author_id = detailsData["author_id"] as? String
                                {
                                    self.authorId = author_id
                                }
                                if let name = detailsData["name"] as? String
                                {
                                    self.authorname = name
                                }
                                if let profile_pic = detailsData["profile_pic"] as? String
                                {
                                    self.authorProfilePic = base_path+profile_pic
                                }
                                if let purchase_status = detailsData["purchase_status"] as? String
                                {
                                    self.coursePurchaseStatus = purchase_status
                                }
                                if let wishlist = detailsData["wishlist"] as? String
                                {
                                    self.wishlistStatus = wishlist
                                }
                                if let followers = detailsData["followers"] as? String
                                {
                                    self.authorfollowers = followers
                                }
                                if let followed = detailsData["followed"] as? String
                                {
                                    self.followedStatus = followed
                                }
                                if let course_title = detailsData["course_title"] as? String
                                {
                                    self.courseTitle = course_title
                                }
                                if let category_name = detailsData["category_name"] as? String
                                {
                                    self.courseName = category_name
                                }
                                if let downloadable = detailsData["downloadable"] as? String
                                {
                                    self.downloadableStatus = downloadable
                                }
                                
                                
                                DispatchQueue.main.async {
                                    
                                    self.courseNameLbl.text = self.courseTitle
                                    self.authorNameLbl.text = self.authorname
                                    self.durationLbl.text = self.courseDuration+" m"
                                    self.ratingLbl.text = self.courseRating
                                    self.purchaseLbl.text = self.coursePurchased
                                    self.authorFollowersLbl.text = String(format: "%@%@%@", (self.authorfollowers)," ",languageChangeString(a_str: "Followers") ?? "")
                                    
                                    self.introductionImg.sd_setImage(with: URL (string:self.introductionThumbnail))
                                    
                                    self.authorImg.sd_setImage(with: URL (string:self.authorProfilePic), placeholderImage:
                                        UIImage(named:"Profile"))
      
                                    if self.downloadableStatus == "1"
                                    {
                                        self.downloadableOrNot.setImage(UIImage(named: "on"), for: UIControl.State.normal)
                                        
                                    }
                                    else if self.downloadableStatus == "0"
                                    {
                                        self.downloadableOrNot.setImage(UIImage(named: "off"), for: UIControl.State.normal)
                                    }
                                    if self.followedStatus == "1"
                                    {
                                         self.trainerFollow.setTitle(languageChangeString(a_str: " Un Follow"), for: UIControl.State.normal)
                                        
                                    }
                                    else if self.followedStatus == "0"
                                    {
                                        self.trainerFollow.setTitle(languageChangeString(a_str: " Follow"), for: UIControl.State.normal)
                                    }
                                }
                    
                              }
                            }
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message:message, style: style1)
                        }
                        
                    }
                    
                }
                
            }
            else{
                MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            }
        }
    
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        lessonsTV.layer.removeAllAnimations()
        lessonTvHeight.constant = lessonsTV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func lessonToView(lessonId:String)
    {
        if coursePurchaseStatus == "1"
        {
        
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let lessonToViewService = "\(base_path)services/view_lesson_video?"
            
            
           
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["lang" :language,
                    "api_key":APIKEY,"user_id":myuserID,"lesson_id":lessonId,"course_id":self.courseId]
            
            print(parameters)
            
            Alamofire.request(lessonToViewService, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        //self.showToastForAlert(message: message)
                        
                      }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
        }
        
     }
    }

    
}

extension LessonsVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
      return 70
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitlesArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       //print(lessonId.count)
    
        if section == 0{
            if expanded1
            {
              return lessonId.count
                
            }else{

                return 0
            }
        }
        else if  section == 1{
           
            if expanded2{

                return self.materialName.count
                
            }else{

                
                return 0
            }
        }
        
            
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var  cell =  UITableViewCell()
      
        if indexPath.section == 0
        {
             let cell1 = tableView.dequeueReusableCell(withIdentifier: "LessonsTableViewCell", for: indexPath) as! LessonsTableViewCell
              cell = cell1
            
            if language == "en"
            {
                GeneralFunctions.labelCustom_LTReg(labelName: cell1.lessonIntro, fontSize: 15)
            }
            else if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell1.lessonIntro, fontSize: 15)
            }
        
          if lessonTypeArray[indexPath.row] == "xlsx"
          {
            cell1.lessonImg.image = UIImage(named: "xl")
           }
            else if lessonTypeArray[indexPath.row] == "ppt"
            {
                cell1.lessonImg.image = UIImage(named: "ppt")
            }
          else if lessonTypeArray[indexPath.row] == "doc" || lessonTypeArray[indexPath.row] == "docx"
          {
            cell1.lessonImg.image = UIImage(named: "doc")
            }
          else if lessonTypeArray[indexPath.row] == "pdf"
          {
            cell1.lessonImg.image = UIImage(named: "pdf")
            }
          else if lessonTypeArray[indexPath.row] == "pdf"
          {
            cell1.lessonImg.image = UIImage(named: "pdf")
          }
          else if lessonTypeArray[indexPath.row] == "image" || lessonTypeArray[indexPath.row] == "video"
          {
             cell1.lessonImg.sd_setImage(with: URL (string:self.lessonThumbnail[indexPath.row]))
           
          }
          else if lessonTypeArray[indexPath.row] == "video"
          {
            cell1.lessonImg.sd_setImage(with: URL (string:self.lessonThumbnail[indexPath.row]))
            cell1.lessonImg.player?.allowsExternalPlayback = true
            }
       
        cell1.noOfLessons.text = "\(indexPath.row+1)"
        cell1.lessonIntro.text = lessonName[indexPath.row]
            
           
         if coursePurchaseStatus == "0"
         {
          cell1.showBtn.setImage(UIImage(named: "Path 10921"), for: UIControl.State.normal)
           
         }
         
            cell1.showBtn.tag = indexPath.row
            cell1.showBtn.addTarget(self, action: #selector(lessonBtnTap(sender:)), for: UIControl.Event.touchUpInside)
            
            
        //celllessonDuration.text = "1:30 min"
       
        }
        if indexPath.section == 1
        {
             let cell2 = tableView.dequeueReusableCell(withIdentifier: "material", for: indexPath) as! LessonsTableViewCell
            cell = cell2
           
            if language == "en"
            {
                GeneralFunctions.labelCustom_LTReg(labelName: cell2.materialName, fontSize: 15)
            }
            else if language == "ar"
            {
                 GeneralFunctions.labelCustom_RTReg(labelName: cell2.materialName, fontSize: 15)
            }
            
            cell2.materialName.text = materialName[indexPath.row]
            if coursePurchaseStatus == "0"
            {
                cell2.showBtn.setImage(UIImage(named: "Path 10921"), for: UIControl.State.normal)
            }
            cell2.showBtn.tag = indexPath.row
            cell2.showBtn.addTarget(self, action: #selector(materialBtnTap(sender:)), for: UIControl.Event.touchUpInside)
            
            if materialTypeArray[indexPath.row] == "xlsx"
            {
                cell2.materialImg.image = UIImage(named: "xl")
            }
            else if materialTypeArray[indexPath.row] == "ppt" || materialTypeArray[indexPath.row] == "pptx"
            {
                cell2.materialImg.image = UIImage(named: "ppt")
            }
            else if materialTypeArray[indexPath.row] == "doc" || materialTypeArray[indexPath.row] == "docx"
            {
                cell2.materialImg.image = UIImage(named: "doc")
            }
            else if materialTypeArray[indexPath.row] == "pdf"
            {
                cell2.materialImg.image = UIImage(named: "pdf")
            }
            else if materialTypeArray[indexPath.row] == "pdf"
            {
                cell2.materialImg.image = UIImage(named: "pdf")
            }
            else if materialTypeArray[indexPath.row] == "image"
            {
               cell2.materialImg.sd_setImage(with: URL (string:self.materiaImg[indexPath.row]))
            }
            else if materialTypeArray[indexPath.row] == "video"
            {
                cell2.materialImg.sd_setImage(with: URL (string:self.materialThumbArray[indexPath.row]))
            }
            
            
            
         }
        
           return cell
        }
    
    @objc func lessonBtnTap(sender:UIButton)
    {
        if lessonTypeArray[sender.tag] == "video"
        {
            videoToPlay(videoLink: lessonVideo[sender.tag])
            lessonToView(lessonId: lessonId[sender.tag])
        }
        else
        {
            if coursePurchaseStatus == "1"
            {
                lessonToView(lessonId: lessonId[sender.tag])
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                
                vc.navigationChecking = self.lessonVideo[sender.tag]
                vc.title1 = "Lessons"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                showToastForAlert(message: languageChangeString(a_str:"Please Purchase Your Course") ?? "", style: style1)
            }
            
        }
    }
    
    
    @objc func materialBtnTap(sender:UIButton)
    {
        if coursePurchaseStatus == "1"
        {
            if materialTypeArray[sender.tag] == "video"
            {
                videoToPlay(videoLink: materiaImg[sender.tag])
            }
            else{
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                vc.navigationChecking = self.materiaImg[sender.tag]
                vc.title1 = "Material"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            self.showToastForAlert(message: languageChangeString(a_str:"Please Purchase Your Course") ?? "", style: style1)
            
        }
    }
    
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
         lessonToView(lessonId: lessonId[indexPath.row])
          
            if lessonTypeArray[indexPath.row] == "video"
            {
                videoToPlay(videoLink: lessonVideo[indexPath.row])
            }
            else
            {
                if coursePurchaseStatus == "1"
                {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                
                vc.navigationChecking = self.lessonVideo[indexPath.row]
                vc.title1 = "Lessons"
                self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    self.showToastForAlert(message: languageChangeString(a_str:"Please Purchase Your Course") ?? "", style: style1)
                }
                
            }
            
        }
        if indexPath.section == 1
        {
            if coursePurchaseStatus == "1"
            {
                if materialTypeArray[indexPath.row] == "video"
                {
                    videoToPlay(videoLink: materiaImg[indexPath.row])
                }
                else{
                    
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.navigationChecking = self.materiaImg[indexPath.row]
            vc.title1 = "Material"
            self.navigationController?.pushViewController(vc, animated: true)
                }
          }
            else{
                self.showToastForAlert(message: languageChangeString(a_str:"Please Purchase Your Course") ?? "", style: style1)
            
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        
        if section == 0{
            
            headerCell.sectionTitleLbl.text = sectionTitlesArr[section]
            
            if expanded1{
                headerCell.sectionViewAllBtn.setImage(#imageLiteral(resourceName: "Faq_1"), for: .normal)
                //headerCell.sectionViewAllBtn.setImage(UIImage(named: "T##String"), for: UIControl.State.normal)
            }
            else{
                 headerCell.sectionViewAllBtn.setImage(UIImage(named: "Faq_1-1"), for: .normal)
            }
        }
        if section == 1{
            headerCell.sectionTitleLbl.text = sectionTitlesArr[section]
            if expanded2{
                headerCell.sectionViewAllBtn.setImage(#imageLiteral(resourceName: "Faq_1"), for: .normal)
            }else{
                 headerCell.sectionViewAllBtn.setImage(UIImage(named: "Faq_1-1"), for: .normal)
            }
        }
        
        headerCell.sectionViewAllBtn.addTarget(self, action: #selector(viewAllBtnTapped), for: .touchUpInside)
        headerCell.sectionViewAllBtn.tag = section
        
        return headerCell
    }
    
    @objc func viewAllBtnTapped(sender: UIButton)
    {
        
        selectedSection = sender.tag
        
        if selectedSection == 0{
            if expanded1{
                expanded1 = false
                expanded2 = true
            }else{
                expanded1 = true
                expanded2 = false
                
            }
        }
        else if selectedSection == 1
        {
            if expanded2{
                expanded2 = false
                expanded1 = true
            }
            else{
                expanded2 = true
                expanded1 = false
            }
        }
        lessonsTV.reloadData()
    }
    
    
}










