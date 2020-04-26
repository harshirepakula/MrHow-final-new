//
//  TrainerProfileVC.swift
//  MrHow
//
//  Created by volive solutions on 22/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class TrainerProfileVC: UIViewController {

    
    var trainerId = ""
    
    
    @IBOutlet weak var seemoreBtn: UIButton!
    
    @IBOutlet weak var proView: NSLayoutConstraint!
    
    @IBOutlet weak var switchtoStude: UIButton!
    @IBOutlet weak var viewmoreBtn: UIButton!
    @IBOutlet weak var ratingSt: UILabel!
    @IBOutlet weak var courseSt: UILabel!
    @IBOutlet weak var studentsSt: UILabel!
    @IBOutlet weak var seeMoreBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var star1St: UILabel!
    @IBOutlet weak var star2St: UILabel!
    @IBOutlet weak var star3St: UILabel!
    @IBOutlet weak var star4St: UILabel!
    
    @IBOutlet weak var star5st: UILabel!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var coursesLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var studentsCountLbl: UILabel!
    
    @IBOutlet weak var pro1: UIProgressView!
    @IBOutlet weak var pro2: UIProgressView!
    @IBOutlet weak var pro3: UIProgressView!
    @IBOutlet weak var pro4: UIProgressView!
    @IBOutlet weak var pro5: UIProgressView!
    
    // trainer rating stars
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var trainerRatingLbl: UILabel!
    
    // trainer Review
    @IBOutlet weak var trainerReview: UILabel!
    @IBOutlet weak var reviewStar1: UIImageView!
    @IBOutlet weak var reviewStar2: UIImageView!
    @IBOutlet weak var reviewStar3: UIImageView!
    @IBOutlet weak var reviewStar5: UIImageView!
    @IBOutlet weak var reviewStar4: UIImageView!
    
    @IBOutlet weak var reviewerNameDateLbl: UILabel!
    @IBOutlet weak var coursesByTrainer: UILabel!
    
    @IBOutlet weak var reviewSt: UILabel!
    @IBOutlet weak var trainerReviewsLbl: UILabel!
    @IBOutlet weak var trainerImage: UIImageView!
    @IBOutlet weak var trainerDesLbl: UILabel!
    @IBOutlet weak var trainerSkillsLbl: UILabel!
    @IBOutlet weak var trainerNameLbl: UILabel!
    

    // course
    var course_idArray = [String]()
    var category_nameArray = [String]()
    var course_titleArray = [String]()
    var coursePriceArray = [String]()
    var offer_priceArray = [String]()
    var coverArray = [String]()
    var cover_typeArray = [String]()
    var durationArray = [String]()
    var total_ratingsArray = [String]()
    var purchasedArray = [String]()
    var tagsArray = [String]()
    var thumbnailArray = [String]()
    var courseCurrencyType = [String]()

    // reviews
    var review_idArray = [String]()
    var user_idArray = [String]()
    var reviewArray = [String]()
    var reviewRatingArray = [String]()
    var created_onArray = [String]()
    var nameArray = [String]()
    
   
    // ratings
    var ratingDic = [String:String]()
   
   
    // TRAINER
    var trainerName = ""
    var trainerProfile_pic = ""
    var trainerSkills = ""
    var trainerDescrip = ""
    var trainerTotalReviews = ""
    var trainerCourseCount = ""
    var trainerStudentsCount = ""
    var trainerRating = ""
    
    var fontStyle = ""
    var style = ""
    
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating_1")!
    let emptyStarImage: UIImage = UIImage(named: "rating_2")!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
            style = "Poppins-Regular"
        }
        else if language == "ar"
        {
            fontStyle = "29LTBukra-Bold"
            style = "29LTBukra-Regular"
        }
        
        //self.proView.constant = 0
        
        if let aSize = UIFont(name:fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            self.navigationItem.title = languageChangeString(a_str: "Trainer Profile")
            print("font changed")
        }
        
       self.courseSt.text = languageChangeString(a_str: "Courses")
       self.studentsSt.text = languageChangeString(a_str: "Students")
       self.ratingSt.text = languageChangeString(a_str: "Rating")
       self.reviewSt.text = languageChangeString(a_str: "Reviews")
         self.star5st.text = String(format: "%@%@%@" ,"5"," ",languageChangeString(a_str: "Stars") ?? "")
         self.star4St.text = String(format: "%@%@%@" ,"4"," ",languageChangeString(a_str: "Stars") ?? "")
         self.star3St.text = String(format: "%@%@%@" ,"3"," ",languageChangeString(a_str: "Stars") ?? "")
         self.star2St.text = String(format: "%@%@%@" ,"2"," ",languageChangeString(a_str: "Stars") ?? "")
         self.star1St.text = String(format: "%@%@%@" ,"1"," ",languageChangeString(a_str: "Stars") ?? "")
       
        self.switchtoStude.setTitle(languageChangeString(a_str: "See More"), for: UIControl.State.normal)
          self.switchtoStude.setTitle(languageChangeString(a_str: "Switch to Student view"), for: UIControl.State.normal)
          self.viewmoreBtn.setTitle(languageChangeString(a_str: "View More"), for: UIControl.State.normal)
        
        
        if language == "en"
        {
            GeneralFunctions.labelCustom_LTReg(labelName: courseSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: studentsSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: ratingSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: star5st, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: star4St, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: star3St, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: star2St, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: star1St, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: coursesLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: studentsCountLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: ratingCountLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: trainerDesLbl, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: reviewSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: coursesByTrainer, fontSize: 15)
            GeneralFunctions.buttonCustom_LTReg(buttonName: switchtoStude, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: seemoreBtn, fontSize: 16)
        
        }
        else if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: courseSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: studentsSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: ratingSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: star5st, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: star4St, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: star3St, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: star2St, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: star1St, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: trainerDesLbl, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: coursesLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: studentsCountLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: ratingCountLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: reviewSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: coursesByTrainer, fontSize: 15)
            GeneralFunctions.buttonCustom_RTReg(buttonName: switchtoStude, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: seemoreBtn, fontSize: 16)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    // star rating
    func getStarImage(starNumber: Int, forRating rating: Int) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        }  else {
            return emptyStarImage
        }
    }
    
    
    
    
  
    //MARK:- BACK BTN ACTION
    @IBAction func backBtnAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
         trainerProfileData()
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func seeMoreBtnTap(_ sender: Any) {
        
        if review_idArray.count > 1
        {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainerReviewVC") as! TrainerReviewVC
          vc.trainerReviewId = trainerId
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    //MARK:- SHARE BTN ACTION
    @IBAction func shareBtnAction(_ sender: Any) {
        
        let shareVC = UIActivityViewController(activityItems: ["Google.com"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
   
    // Trainer profile Data
    
    func trainerProfileData(){
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let trainerData = "\(base_path)services/trainer_profile?"

           //https://volive.in/mrhow_dev/services/trainer_profile?api_key=1762019&lang=en&user_id=4
               let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
         
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang": language,"user_id":trainerId]
            print(parameters)
            Alamofire.request(trainerData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [String:Any]
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()

                            if let courseDetails = response1["courses"] as? [[String:Any]]
                            {
                                if self.coverArray.count > 0 ||
                                self.durationArray.count > 0 ||
                                self.total_ratingsArray.count > 0 ||
                                self.purchasedArray.count > 0 ||
                                self.thumbnailArray.count > 0 ||
                                self.tagsArray.count > 0 ||
                                self.course_idArray.count > 0 ||
                                self.category_nameArray.count > 0 ||
                                self.course_titleArray.count > 0 ||
                                self.coursePriceArray.count > 0 ||
                                self.offer_priceArray.count > 0 ||
                                self.cover_typeArray.count > 0 ||
                                    self.courseCurrencyType.count > 0
                                {
                                    self.coverArray.removeAll()
                                        self.durationArray.removeAll()
                                        self.total_ratingsArray.removeAll()
                                        self.purchasedArray.removeAll()
                                        self.thumbnailArray.removeAll()
                                        self.tagsArray.removeAll()
                                        self.course_idArray.removeAll()
                                        self.category_nameArray.removeAll()
                                        self.course_titleArray.removeAll()
                                        self.coursePriceArray.removeAll()
                                        self.offer_priceArray.removeAll()
                                        self.cover_typeArray.removeAll()
                                    self.courseCurrencyType.removeAll()
                                }
                            
                                for i in 0..<courseDetails.count
                                {
                                    if let  cover = courseDetails[i]["cover"] as? String
                                    {
                                        self.coverArray.append(base_path+cover)
                                        
                                    }
                                    if let duration = courseDetails[i]["duration"] as? String
                                    {
                                        self.durationArray.append(duration)
                                    }
                                    if let total_ratings = courseDetails[i]["total_ratings"] as? String
                                    {
                                        self.total_ratingsArray.append(total_ratings)
                                        
                                    }
                                    if let purchased = courseDetails[i]["purchased"] as? String
                                    {
                                        self.purchasedArray.append(purchased)
                                    }
                                    if let tags = courseDetails[i]["tags"] as? String
                                    {
                                        self.tagsArray.append(tags)
                                        
                                    }
                                    if let course_id = courseDetails[i]["course_id"] as? String
                                    {
                                        self.course_idArray.append(course_id)
                                    }
                                    
                                    if let category_name = courseDetails[i]["category_name"] as? String
                                    {
                                        self.category_nameArray.append(category_name)
                                        
                                    }
                                    if let course_title = courseDetails[i]["course_title"] as? String
                                    {
                                        self.course_titleArray.append(course_title)
                                    }
                                    if let price = courseDetails[i]["price"] as? String
                                    {
                                        self.coursePriceArray.append(price)
                                        
                                    }
                                    if let offer_price = courseDetails[i]["offer_price"] as? String
                                    {
                                        self.offer_priceArray.append(offer_price)
                                    }
                                    if let cover_type = courseDetails[i]["cover_type"] as? String
                                    {
                                        self.cover_typeArray.append(cover_type)
                                    }
                                   
                                    if let thumbnail = courseDetails[i]["thumbnail"] as? String
                                    {
                                        self.thumbnailArray.append(base_path+thumbnail)
                                    }
                                    if let currency = courseDetails[i]["currency"] as? String
                                    {
                                        self.courseCurrencyType.append(currency)
                                    }
                                    
                                }
                                
                            }
                           
                            DispatchQueue.main.async {
                                
                                self.coursesCollectionView.reloadData()
                            }
                            
                    
                      if let reviewsData = response1["reviews"] as? [[String:Any]]
                      {
                        
                        if self.review_idArray.count > 0 ||
                            self.user_idArray.count > 0 ||
                            self.reviewArray.count > 0 ||
                            self.reviewRatingArray.count > 0 ||
                            self.created_onArray.count > 0 ||
                            self.nameArray.count > 0
                        {
                            self.review_idArray.removeAll()
                            self.user_idArray.removeAll()
                            self.reviewArray.removeAll()
                            self.reviewRatingArray.removeAll()
                            self.created_onArray.removeAll()
                            self.nameArray.removeAll()
                            
                        }
                        
                          if reviewsData.count > 0
                          {
                            if reviewsData.count == 1
                            {
                                self.seeMoreBtnHeight.constant = 0
                                
                            }
                            for i in 0..<reviewsData.count
                            {
                            if let id = reviewsData[i]["review_id"] as? String
                            {
                                self.review_idArray.append(id)
                                
                            }
                            if let user_id = reviewsData[i]["user_id"] as? String
                            {
                                self.user_idArray.append(user_id)
                                
                            }
                            if let review = reviewsData[i]["review"] as? String
                            {
                                self.reviewArray.append(review)
                                
                            }
                            if let rating = reviewsData[i]["rating"] as? String
                            {
                                self.reviewRatingArray.append(rating)
                                
                            }
                            if let created_on = reviewsData[i]["created_on"] as? String
                            {
                                self.created_onArray.append(created_on)
                                
                            }
                            if let name = reviewsData[i]["name"] as? String
                            {
                                self.nameArray.append(name)
                                
                            }
                            
                            }
                            
                            DispatchQueue.main.async {
                                
            
                                self.seeMoreBtnHeight.constant = 0
                                self.ratingViewHeight.constant = 0

                            }
                        }
                          
                        else if reviewsData.count == 0
                          {
                            self.seeMoreBtnHeight.constant = 0
                            self.ratingViewHeight.constant = 0
                            }
                        }
                        if let name = response1["name"] as? String
                        {
                            self.trainerName = name
                            
                        }
                        if let profile_pic = response1["profile_pic"] as? String
                        {
                            self.trainerProfile_pic = base_path+profile_pic
                            
                        }
                        if let skills = response1["skills"] as? String
                        {
                            self.trainerSkills = skills
                            
                        }
                        if let description = response1["description"] as? String
                        {
                            self.trainerDescrip = description
                            
                        }
                        if let total_reviews = response1["total_reviews"] as? String
                        {
                            self.trainerTotalReviews = total_reviews
                            
                        }
                        if let courses_count = response1["courses_count"] as? String
                        {
                            self.trainerCourseCount = courses_count
                                
                        }
                        if let average_rating1 = response1["average_rating"]
                        {
                            //print(average_rating1)
                            
                            let rate = self.stringFromAny(average_rating1)
                            //print(rate)
                            self.trainerRating = rate
                        }
                        if let students_count = response1["students_count"] as? String
                        {
                                self.trainerStudentsCount = students_count
                                
                        }
                            
                        if let ratingsData = response1["ratings"] as? [String:String]
                        {
                            self.ratingDic = ratingsData
                                
                            DispatchQueue.main.async
                            {
                                let rating5 : String  = self.ratingDic["rating5"] ?? ""
                                let rating4 : String  = self.ratingDic["rating4"] ?? ""
                                let rating3 : String = self.ratingDic["rating3"] ?? ""
                                let rating2  = self.ratingDic["rating2"] ?? ""
                                let rating1  = self.ratingDic["rating1"] ?? ""
                                let totalRating = Float(self.trainerTotalReviews)
                            
                                if Int(totalRating ?? 0) > 0
                                {
                                    if let value5 = Float(rating5)
                                    {
                                        self.pro5.progress = value5/100
                                        
                                        print(self.pro5.progress)
                                    }
                                    if let value4 = Float(rating4)
                                    {
                                        self.pro4.progress = value4/100
                                    }
                                    if let value3 = Float(rating3)
                                    {
                                        self.pro3.progress = value3/100
                                    }
                                    if let value2 = Float(rating2)
                                    {
                                        self.pro2.progress = value2/100
                                    }
                                    if let value1 = Float(rating1)
                                    {
                                        self.pro1.progress = value1/100
                                    }
                                }
                                    
                                }
                                
                            }
                            
                            DispatchQueue.main.async {
                            
                            self.trainerDesLbl.text = self.trainerDescrip
                            self.trainerNameLbl.text = self.trainerName
                            self.trainerImage.sd_setImage(with: URL (string:self.trainerProfile_pic))
                            self.trainerSkillsLbl.text = self.trainerSkills
                                self.trainerReviewsLbl.text = String(format: "%@%@%@%@%@" ,"(",(self.trainerTotalReviews),")","" ,languageChangeString(a_str: "Reviews") ?? "")
                                
                                //("(\(self.trainerTotalReviews))Reviews")
                            self.coursesByTrainer.text =  String(format: "%@%@%@" ,languageChangeString(a_str: "Courses by") ?? "",
                                                                 "  ",(self.trainerName))
                               // "Courses by \(self.trainerName)"
                            self.ratingCountLbl.text = self.trainerRating
                            self.coursesLbl.text = self.trainerCourseCount
                            self.studentsCountLbl.text = self.trainerStudentsCount
                                print(self.trainerRating)
                            self.trainerRatingLbl.text = self.trainerRating
                            
                            if let moreRate = Float(self.trainerRating)
                            {
                                let rate = Int(moreRate)
                                print(moreRate)
                                    self.star1.image = self.getStarImage(starNumber: 1, forRating: rate)
                                    self.star2.image = self.getStarImage(starNumber: 2, forRating: rate)
                                    self.star3.image = self.getStarImage(starNumber: 3, forRating: rate)
                                    self.star4.image = self.getStarImage(starNumber: 4, forRating: rate)
                                    self.star5.image = self.getStarImage(starNumber: 5, forRating: rate)
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
    
}


extension TrainerProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coverArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coursesCollectionView.dequeueReusableCell(withReuseIdentifier: "cat3", for: indexPath) as! CustomCollectionViewCell
        
        if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lblName, fontSize: 13)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_price, fontSize: 15)
            //GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_priceDummy, fontSize: 14)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTBold(labelName: cell.imageOfferName, fontSize: 14)
            
        }
        else if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lblName, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_price, fontSize: 15)
            //GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_priceDummy, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTBold(labelName: cell.imageOfferName, fontSize: 14)
            
        }
        
        cell.view_back.layer.cornerRadius = 8
        cell.view_back.layer.masksToBounds = true
        cell.view_back.layer.borderWidth = 0.3
        cell.view_back.layer.borderColor = UIColor.lightGray.cgColor
        //let cost = "\(coursePriceArray[indexPath.row]) SAR"
        //cell.lbl_priceDummy.attributedText = cost.strikeThrough()
        cell.duration.text = durationArray[indexPath.row]
        cell.noOfPurchasesLbl.text = purchasedArray[indexPath.row]
        //cell.lbl_price.text = "SAR\(offer_priceArray[indexPath.row])"
        cell.lbl_price.text = "\(coursePriceArray[indexPath.row]) SAR"
        
        //\(courseCurrencyType[indexPath.row])"
        cell.ratingLbl.text = total_ratingsArray[indexPath.row]
        cell.lblName.text = course_titleArray[indexPath.row]
        
        if cover_typeArray[indexPath.row] == "image"
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.coverArray[indexPath.row]))
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.thumbnailArray[indexPath.row]))
        }
       
            let tag2 = Int(tagsArray[indexPath.row])
        

        
        if tag2 == 1
        {
            if language == "en"
            {
                cell.imageview_offer.image = UIImage.init(named: "hot1")
            }
            else
            {
                cell.imageview_offer.image = UIImage.init(named: "hotar")
            }
            cell.imageOfferName.text = languageChangeString(a_str: "Hot")
        }
        if tag2 == 2
        {
            
            if language == "en"
            {
                cell.imageview_offer.image = UIImage.init(named: "now")
            }
            else
            {
                cell.imageview_offer.image = UIImage.init(named: "nowar")
            }
            
            cell.imageOfferName.text = languageChangeString(a_str: "New")
        }
        if tag2 == 0
        {
            
            cell.imageview_offer.image = UIImage.init(named: "")
            cell.imageOfferName.text = ""
            
        }

   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
            let yourWidth = coursesCollectionView.bounds.width/2
             print(yourWidth)
            //let yourHeight = coursesCollectionView.bounds.height
            
            return CGSize(width: yourWidth, height: 210)
       
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
        vc.videoToPlay = coverArray[indexPath.row]
        vc.catageoryType = cover_typeArray[indexPath.row]
        vc.detailsCourseId = course_idArray[indexPath.row]
        vc.thumbnail = thumbnailArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func stringFromAny(_ value:Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        return ""
    }
    
    
    
}
