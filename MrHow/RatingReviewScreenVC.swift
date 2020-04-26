//
//  RatingReviewScreenVC.swift
//  MrHow
//
//  Created by volivesolutions on 17/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class RatingReviewScreenVC: UIViewController {
    
    var fontStyle = ""
    
    @IBOutlet weak var writeUrReviewSt: UILabel!
    @IBOutlet weak var giveUrRatingSt: UILabel!
    @IBOutlet weak var txt_review : UITextField!
    @IBOutlet weak var lbl_priceDummy  : UILabel!
    
    @IBOutlet weak var imageOfferName: UILabel!
    @IBOutlet weak var imageOffer: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var banner_Image: UIImageView!
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var purchasedLbl: UILabel!
    @IBOutlet weak var realPriceLbl: UILabel!
    
    
    @IBOutlet weak var starBtn1: UIButton!
    @IBOutlet weak var starBtn2: UIButton!
    @IBOutlet weak var starBtn3: UIButton!
    @IBOutlet weak var starBtn4: UIButton!
    @IBOutlet weak var starBtn5: UIButton!
    
    var Givenrating = ""
    
    var courseId = ""
    var courseTitle = ""
    var bannerImage = ""
    var courseTag = ""
    var coursePrice = ""
    var courseDummyPrice = ""
    var duration = ""
    var courseRating = ""
    var coursePurchased = ""
   let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // txt_review.setBottomLineBorder()
        
       //lbl_priceDummy.attributedText = "SAR \(courseDummyPrice)".strikeThrough()
        //"SAR 460.66".strikeThrough()
        
        realPriceLbl.text = coursePrice
        courseNameLbl.text = courseTitle
        ratingLbl.text = courseRating
        purchasedLbl.text = coursePurchased
        durationLbl.text = duration
        
      self.banner_Image.sd_setImage(with: URL (string:bannerImage))
        
        let tag2 = Int(courseTag)
 
        
        
        if tag2 == 1
        {
            if language == "en"
            {
                imageOffer.image = UIImage.init(named: "hot1")
            }
            else
            {
                imageOffer.image = UIImage.init(named: "hotar")
            }
            imageOfferName.text = languageChangeString(a_str: "Hot")
        }
        if tag2 == 2
        {
            
            if language == "en"
            {
               imageOffer.image = UIImage.init(named: "now")
            }
            else
            {
               imageOffer.image = UIImage.init(named: "nowar")
            }
            
            
            imageOfferName.text = languageChangeString(a_str: "New")
        }
        if tag2 == 0
        {
            
            imageOffer.image = UIImage.init(named: "")
            imageOfferName.text = ""
            
        }

        
        
        
        if language == "ar"
        {
            self.txt_review.textAlignment = .right
            self.txt_review.setPadding(left: -10, right: -10)
            GeneralFunctions.labelCustom_RTReg(labelName: giveUrRatingSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: writeUrReviewSt, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: courseNameLbl, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: realPriceLbl, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: durationLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: purchasedLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTBold(labelName: imageOfferName, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: ratingLbl, fontSize: 10)
            GeneralFunctions.buttonCustom_RTBold(buttonName: submitBtn, fontSize: 16)
            
        }
        else if language == "en"{
            self.txt_review.textAlignment = .left
            self.txt_review.setPadding(left: 10, right: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: giveUrRatingSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: writeUrReviewSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: courseNameLbl, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: realPriceLbl, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: durationLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: purchasedLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: ratingLbl, fontSize: 10)
            GeneralFunctions.buttonCustom_LTBold(buttonName: submitBtn, fontSize: 16)
            GeneralFunctions.labelCustom_LTBold(labelName: imageOfferName, fontSize: 14)
            
        }
        
        
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        
        self.tabBarController?.tabBar.isHidden = true
        if let aSize = UIFont(name:fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            self.navigationItem.title = languageChangeString(a_str: "Rating and Review")
            print("font changed")
            
        }
        self.giveUrRatingSt.text = languageChangeString(a_str: "Give your rating")
        self.writeUrReviewSt.text = languageChangeString(a_str: "Write a Review")
         self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
        
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func star1(_ sender: Any) {
        
        starBtn1.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn2.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn3.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn4.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn5.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        self.Givenrating = "1"
        
    }
    
    
    @IBAction func star2(_ sender: Any) {
        
        starBtn1.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn2.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn3.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn4.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn5.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        self.Givenrating = "2"
    }
    
    @IBAction func star3(_ sender: Any) {
        
        starBtn1.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn3.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn2.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn4.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        starBtn5.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        
        self.Givenrating = "3"
      }
    
    
    @IBAction func star4(_ sender: Any) {
        starBtn1.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn4.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn2.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn3.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn5.setImage(UIImage(named: "rating_2"), for: UIControl.State.normal)
        self.Givenrating = "4"
    }
    
    
    @IBAction func star5(_ sender: Any) {
        
        starBtn1.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn5.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn2.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn3.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        starBtn4.setImage(UIImage(named: "rating_1"), for: UIControl.State.normal)
        self.Givenrating = "5"
    }
    
    
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Back Button
    
    @IBAction func submitBtnTap(_ sender: Any)
    {
        if txt_review.text != nil && txt_review.text != ""
        {
            if Givenrating != ""
            {
                ratingForCourse()
            }
            else
            {
                self.showToastForAlert(message: languageChangeString(a_str:"Please Enter Comment and Rating") ?? "",style: style1)
            }
            
        }
        else
        {
            self.showToastForAlert(message: languageChangeString(a_str:"Please Enter Comment and Rating") ?? "", style: style1)
            
        }
        
       
    }
    
    
   
    
    // rating post service call
    
    func ratingForCourse()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let rating = "\(base_path)services/submit_course_review"
            
          
           
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
          
           
            
            let parameters: Dictionary<String, Any> = [
                                                       "lang" : language,
                                                       "api_key":APIKEY,
                                                       "user_id":myuserID,
                                                       "course_id":courseId,
                                                       "comment":txt_review.text ?? "",
                                                       "comment_rating":Givenrating
            ]
            
            print(parameters)
            
            Alamofire.request(rating, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                   
                    if status == 1
                    {
                      MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                        self.navigationController?.popViewController(animated: true)
                        
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
            self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    

}
