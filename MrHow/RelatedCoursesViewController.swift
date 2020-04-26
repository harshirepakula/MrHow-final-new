//
//  RelatedCoursesViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 8/6/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class RelatedCoursesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    @IBOutlet weak var relatedCollection: UICollectionView!
    
    
    // related courses
    
    var courseImagesArray = NSMutableArray()
    var courseTitleArray = NSMutableArray()
    var coursenameArray = NSMutableArray()
    var coursePriceArray = [String]()
    var courseRatingsArray = NSMutableArray()
    var course_idArray = NSMutableArray()
    var coursePurchaseArray = NSMutableArray()
    var courseOfferPriceArray = [String]()
    var courseTagsArray = NSMutableArray()
    var courseCoverTypeArray = NSMutableArray()
    var courseDurationArray = NSMutableArray()
    var thumbnailCourseArray = NSMutableArray()
    var courseCurrencyType = [String]()
    var courseIdSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
       
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
            
            if let aSize = UIFont(name: fontStyle, size: 18) {
                self.navigationItem.title = languageChangeString(a_str: "Related Courses")
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
                
                //print("font changed")
            }
        
            relatedCoursesData()
        
    }
    
    
    @IBAction func backButtonTap(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func filterBtnTap(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // course details service call
    
    func relatedCoursesData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let aboutData = "\(base_path)services/course_details?"
            
            //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang": language,"course_id":courseIdSelected,"user_id":myuserID]
            
            Alamofire.request(aboutData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? Dictionary<String, Any>
                        {
                             MobileFixServices.sharedInstance.dissMissLoader()
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
                                    self.courseOfferPriceArray.removeAll()
                                    self.courseTagsArray.removeAllObjects()
                                    self.courseTitleArray.removeAllObjects()
                                    self.coursePriceArray.removeAll()
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
                                        self.coursePriceArray.append(price)
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
                                        self.courseOfferPriceArray.append(offerPrice)
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
                                    self.relatedCollection.reloadData()
                                    self.relatedCollection.delegate = self
                                    self.relatedCollection.dataSource = self
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
    
    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print(course_idArray.count)
        return course_idArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relatedCourses", for: indexPath) as! CustomCollectionViewCell
        
        
        
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.duration, fontSize: 8)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.ratingLbl, fontSize: 8)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfPurchasesLbl, fontSize: 8)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lblName, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_price, fontSize: 14)
             GeneralFunctions.labelCustom_RTBold(labelName: cell.imageOfferName, fontSize: 14)
           
            
        }
        else if language == "en"
        {
            
            GeneralFunctions.labelCustom_LTReg(labelName: cell.duration, fontSize: 8)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.ratingLbl, fontSize: 8)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.noOfPurchasesLbl, fontSize: 8)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.lblName, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.lbl_price, fontSize: 14)
             GeneralFunctions.labelCustom_LTBold(labelName: cell.imageOfferName, fontSize: 14)
           
            
        }
        
        
        
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
        
        
        //let cost = "\(coursePriceArray[indexPath.row] as! String) SAR"
        //cell.lbl_priceDummy.attributedText = cost.strikeThrough()
        cell.lblName.text = courseTitleArray[indexPath.row] as? String
        cell.duration.text = courseDurationArray[indexPath.row]as? String
        //cell.lbl_price.text = "SAR\(courseOfferPriceArray[indexPath.row] as! String)"
        cell.lbl_price.text = "\(coursePriceArray[indexPath.row] ) SAR"
        cell.noOfPurchasesLbl.text = coursePurchaseArray[indexPath.row]as? String
        cell.ratingLbl.text = courseRatingsArray[indexPath.row]as? String
       
        if let tag = courseTagsArray[indexPath.row] as? String
        {
            let tag2 = Int(tag)
            
            
            if tag2 == 1
            {
                cell.imageview_offer.image = UIImage.init(named: "hot1")
                cell.imageOfferName.text = languageChangeString(a_str: "Hot")
            }
            if tag2 == 2
            {
                cell.imageview_offer.image = UIImage.init(named: "now")
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
        
        let yourWidth = relatedCollection.bounds.width/2
        
        //let yourHeight = relatedCollection.contentSize.height
        
        return CGSize(width: yourWidth, height: 210)
        
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
    
    

}
