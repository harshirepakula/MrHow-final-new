//
//  AboutVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class AboutVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
   
    
    var parentNavigationController : UINavigationController?
    
    var courseId  = ""
    @IBOutlet var relatedCollectionView: UICollectionView!
    @IBOutlet weak var overViewLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var requirementsLbl: UILabel!
    
    @IBOutlet weak var requirementStatic: UILabel!
    @IBOutlet weak var desStatic: UILabel!
    @IBOutlet weak var whatUlearnLbl: UILabel!
    @IBOutlet weak var courseOverViewLbl: UILabel!
    
    @IBOutlet weak var relatedStatic: UILabel!
    @IBOutlet weak var seeAllBtn: UIButton!
    // related courses
    
    var courseImagesArray = NSMutableArray()
    var courseTitleArray = NSMutableArray()
    var coursenameArray = NSMutableArray()
    var coursePriceArray = NSMutableArray()
    var courseRatingsArray = NSMutableArray()
    var course_idArray = NSMutableArray()
    var coursePurchaseArray = NSMutableArray()
    var courseOfferPriceArray = NSMutableArray()
    var courseTagsArray = NSMutableArray()
    var courseCoverTypeArray = NSMutableArray()
    var courseDurationArray = NSMutableArray()
    var thumbnailCourseArray = NSMutableArray()
    var courseCurrencyType = [String]()
    
    var courseOverView = ""
    var courseDescription = ""
    var courseReq = ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"

   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        if let aSize = UIFont(name: "Poppins-SemiBold", size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
        }
        
        self.courseOverViewLbl.text = languageChangeString(a_str: "Course overview")
        self.whatUlearnLbl.text = languageChangeString(a_str: "What you'll learn")
        self.desStatic.text = languageChangeString(a_str: "Description")
        self.requirementStatic.text = languageChangeString(a_str: "Requirements")
        self.relatedStatic.text = languageChangeString(a_str: "Related courses")
        self.seeAllBtn.setTitle(languageChangeString(a_str: "See All"), for: UIControl.State.normal)
       
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: courseOverViewLbl, fontSize: 17)
            GeneralFunctions.labelCustom_RTReg(labelName: whatUlearnLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: desStatic, fontSize: 17)
            GeneralFunctions.labelCustom_RTReg(labelName: requirementStatic, fontSize: 17)
            GeneralFunctions.labelCustom_RTReg(labelName: relatedStatic, fontSize: 17)
            GeneralFunctions.buttonCustom_RTReg(buttonName: seeAllBtn, fontSize: 14)
            
        }
        else if language == "en"
        {
            
            
            GeneralFunctions.labelCustom_LTMedium(labelName: courseOverViewLbl, fontSize: 17)
            GeneralFunctions.labelCustom_LTReg(labelName: whatUlearnLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: desStatic, fontSize: 17)
            GeneralFunctions.labelCustom_LTMedium(labelName: requirementStatic, fontSize: 17)
            GeneralFunctions.labelCustom_LTMedium(labelName: relatedStatic, fontSize: 17)
            GeneralFunctions.buttonCustom_LTReg(buttonName: seeAllBtn, fontSize: 14)
            
            
        }
        
        
       // self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        aboutVCData()
        
        relatedCollectionView.delegate = self
        relatedCollectionView.dataSource = self
        
    }
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
       // self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return course_idArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
       
        cell.view_back.layer.cornerRadius = 8
        cell.view_back.layer.masksToBounds = true
        cell.view_back.layer.borderWidth = 0.3
        cell.view_back.layer.borderColor = UIColor.lightGray.cgColor
        
        if courseCoverTypeArray[indexPath.row] as? String == "image"
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.courseImagesArray[indexPath.row] as! String))
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.thumbnailCourseArray[indexPath.row] as! String))
        }
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_mainTitle, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_price, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.ratingLbl, fontSize: 10)
           GeneralFunctions.labelCustom_RTBold(labelName: cell.imageOfferName, fontSize: 14)
            
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_mainTitle, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_price, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.ratingLbl, fontSize: 10)
           GeneralFunctions.labelCustom_LTBold(labelName: cell.imageOfferName, fontSize: 14)
            
            
            
        }
        

        cell.lbl_mainTitle.text = courseTitleArray[indexPath.row] as? String
        cell.duration.text = courseDurationArray[indexPath.row]as? String
        //cell.lbl_price.text = "SAR\(courseOfferPriceArray[indexPath.row] as! String)"
        cell.lbl_price.text = "\(coursePriceArray[indexPath.row] as! String) \(courseCurrencyType[indexPath.row])"
        cell.noOfPurchasesLbl.text = coursePurchaseArray[indexPath.row]as? String
        cell.ratingLbl.text = courseRatingsArray[indexPath.row]as? String
        
        if let tag = courseTagsArray[indexPath.row] as? String
        {
            let tag2 = Int(tag)
            

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

            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = relatedCollectionView.bounds.width/2
        let yourHeight = relatedCollectionView.contentSize.height
        print("width\(yourWidth),height\(yourHeight)")
        
        return CGSize(width: yourWidth, height: yourHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
        
        vc.detailsCourseId = course_idArray[indexPath.row] as? String ?? ""
        vc.videoToPlay = courseImagesArray[indexPath.row] as? String ?? ""
        vc.catageoryType = courseCoverTypeArray[indexPath.row]as? String ?? ""
        vc.thumbnail = thumbnailCourseArray[indexPath.row] as? String ?? ""
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    @IBAction func seeAllBtnTap(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "RelatedCoursesViewController") as! RelatedCoursesViewController
        vc.courseIdSelected = self.courseId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeMoreBtnTap(_ sender: Any) {
    }
    
    
// course details service call
    
func aboutVCData()
{
    if Reachability.isConnectedToNetwork()
    {
      MobileFixServices.sharedInstance.loader(view: self.view)
            
        let aboutData = "\(base_path)services/course_details?"
            
             //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
            
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang":language,"course_id":courseId,"user_id":myuserID]
            
        Alamofire.request(aboutData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
        if let responseData = response.result.value as? Dictionary<String, Any>{
                    
        //print(responseData)
        let status = responseData["status"] as! Int
        let message = responseData["message"] as! String
        if status == 1
        {
            if let response1 = responseData["data"] as? Dictionary<String, Any>
            {
                            
                if let relatedCourses = response1["related"] as? [[String:Any]]
                {
                                
                if(self.course_idArray.count > 0)||(self.coursePurchaseArray.count > 0)||(self.coursenameArray.count > 0)||(self.courseRatingsArray.count > 0)||(self.coursePriceArray.count > 0)||(self.courseTitleArray.count > 0)||(self.courseTagsArray.count > 0)||(self.courseOfferPriceArray.count > 0)||(self.courseDurationArray.count > 0)||(self.courseCoverTypeArray.count > 0)
                    ||
                    (self.thumbnailCourseArray.count > 0)
                    ||
                    (self.courseImagesArray.count > 0)||(self.courseCurrencyType.count > 0)
                    {
                    self.courseCoverTypeArray.removeAllObjects()
                    self.thumbnailCourseArray.removeAllObjects()
                    self.courseDurationArray.removeAllObjects()
                    self.courseOfferPriceArray.removeAllObjects()
                    self.courseTagsArray.removeAllObjects()
                    self.courseTitleArray.removeAllObjects()
                    self.coursePriceArray.removeAllObjects()
                    self.coursenameArray.removeAllObjects()
                    self.coursePurchaseArray.removeAllObjects()
                    self.course_idArray.removeAllObjects()
                    self.courseRatingsArray.removeAllObjects()
                    self.courseImagesArray.removeAllObjects()
                        self.courseCurrencyType.removeAll()
                }
                
            for i in 0..<relatedCourses.count
            {
                if let imgCover = relatedCourses[i]["cover"] as? String
                {
                    self.courseImagesArray.add(base_path+imgCover)
                                        
                }
                if let price = relatedCourses[i]["price"] as? String
                {
                    self.coursePriceArray.add(price)
                }
                if let cat_name = relatedCourses[i]["category_name"] as? String
                {
                    self.coursenameArray.add(cat_name)
                                        
                }
                if let rating = relatedCourses[i]["total_ratings"] as? String
                {
                    self.courseRatingsArray.add(rating)
                }
                if let id = relatedCourses[i]["course_id"] as? String
                {
                    self.course_idArray.add(id)
                                        
                }
               if let title = relatedCourses[i]["course_title"] as? String
                {
                    self.courseTitleArray.add(title)
                }
                                    
                if let type = relatedCourses[i]["cover_type"] as? String
                {
                    self.courseCoverTypeArray.add(type)
                                        
                }
                if let purchase = relatedCourses[i]["purchased"] as? String
                {
                    self.coursePurchaseArray.add(purchase)
                }
                if let tag = relatedCourses[i]["tags"] as? String
                {
                    self.courseTagsArray.add(tag)
                                        
                }
                if let offerPrice = relatedCourses[i]["offer_price"] as? String
                {
                    self.courseOfferPriceArray.add(offerPrice)
                }
                if let duration = relatedCourses[i]["duration"] as? String
                {
                    self.courseDurationArray.add(duration+"m")
                }
                                    
            if let thumbnail = relatedCourses[i]["thumbnail"] as? String
            {
                self.thumbnailCourseArray.add(base_path+thumbnail)
            }
                if let currency = relatedCourses[i]["currency"] as? String
                {
                    self.courseCurrencyType.append(currency)
                }
                
                                    
            }
                DispatchQueue.main.async {
                        self.relatedCollectionView.reloadData()
                    }
            }
            if let aboutDetails = response1["details"] as? [String:Any]
            {
                if let overview = aboutDetails["overview"] as? String
                {
                        self.courseOverView = overview
                                        
                }
                if let description = aboutDetails["description"] as? String
                {
                    self.courseDescription = description
                }
                if let requirements = aboutDetails["requirements"] as? String
                {
                    self.courseReq = requirements
                                        
                }
                DispatchQueue.main.async
                {
                MobileFixServices.sharedInstance.dissMissLoader()

                   
                    
                self.overViewLbl.attributedText = self.courseOverView.htmlToAttributedString
                   var fontStyle = ""
                    
                    if language == "en"
                    {
                        fontStyle = "Poppins-Regular"
                    }else
                    {
                        fontStyle = "29LTBukra-Regular"
                    }
                    
                    
                self.overViewLbl.font = UIFont(name: fontStyle, size: 13)
                self.overViewLbl.textColor = UIColor.lightGray
                self.descriptionLbl.attributedText = self.courseDescription.htmlToAttributedString
                self.descriptionLbl.font = UIFont(name: fontStyle, size: 13)
                self.requirementsLbl.attributedText = self.courseReq.htmlToAttributedString
                self.requirementsLbl.font = UIFont(name:fontStyle, size: 13)
                self.requirementsLbl.textColor = UIColor.lightGray
                self.descriptionLbl.textColor = UIColor.lightGray
                self.overViewLbl.numberOfLines = 0
                self.overViewLbl.setLineSpacing(lineSpacing: 2, lineHeightMultiple: 1.5)
                self.descriptionLbl.setLineSpacing(lineSpacing: 2, lineHeightMultiple: 1.5)
                    self.requirementsLbl.setLineSpacing(lineSpacing: 2, lineHeightMultiple: 1.5)
                    
                     self.overViewLbl.sizeToFit()
                        }
                    }
                }
            }
        else{
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

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
