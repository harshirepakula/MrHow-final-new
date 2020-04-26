//
//  CategoriesListVC.swift
//  MrHow
//
//  Created by volivesolutions on 21/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

var catId : String = ""
var catageoryName = ""
var navigationCheck = ""

class CategoriesListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
     @IBOutlet weak var collectionViewlist: UICollectionView!
    
    
    
    //instance for singleton
    let singleTonClass  = Singleton.shared
    
    var courseImagesArray = NSMutableArray()
    var courseTitleArray = NSMutableArray()
    var courseNameArray = NSMutableArray()
    var courseIdArray = NSMutableArray()
    var coursePriceArray = [String]()
    var courseDurationArray = NSMutableArray()
    var courseCoverTypeArray = NSMutableArray()
    var courseOfferPriceArray = [String]()
    var courseRatingsArray = NSMutableArray()
    var coursePurchasedArray = NSMutableArray()
    var courseTagsArray = NSMutableArray()
    var courseThumbnails = NSMutableArray()
    var courseCurrencyType = [String]()
    var chekStr = ""
    
   var fontStyle = ""
   
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name: fontStyle, size: 18) {
            
           
            
            if(singleTonClass.isFilterApplied == true)
            {
                //navigationItem.title = "Filter Results"
                 self.navigationItem.title = languageChangeString(a_str: "Filter Results")
                
            }
                else if navigationCheck == "All Courses"
            {
                  self.navigationItem.title = languageChangeString(a_str: "All Courses")
            }
            else{
                 navigationItem.title = catageoryName
            }
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            //print("font changed")
            
        }
        
       
    }
    
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true

        self.courseImagesArray.removeAllObjects()
        self.courseTitleArray.removeAllObjects()
        self.courseCoverTypeArray.removeAllObjects()
        self.courseNameArray.removeAllObjects()
        self.courseRatingsArray.removeAllObjects()
        self.courseTagsArray.removeAllObjects()
        self.coursePurchasedArray.removeAllObjects()
        self.courseIdArray.removeAllObjects()
        self.coursePriceArray.removeAll()
        self.courseOfferPriceArray.removeAll()
        self.courseDurationArray.removeAllObjects()
        self.courseThumbnails.removeAllObjects()
        self.courseCurrencyType.removeAll()
       
        if(singleTonClass.isFilterApplied == true)
        {

        
          for i in 0..<self.singleTonClass.myfilterData.count
          {
                if let imgCover = self.singleTonClass.myfilterData[i]["cover"] as? String
                {
                        self.courseImagesArray.add(base_path+imgCover)
        
                }
                if let cat_name = self.singleTonClass.myfilterData[i]["category_name"] as? String
                {
                            self.courseNameArray.add(cat_name)
        
                }
                if let course_title = self.singleTonClass.myfilterData[i]["course_title"] as? String
                {
                            self.courseTitleArray.add(course_title)
        
                }
                        if let price = self.singleTonClass.myfilterData[i]["price"] as? String
                        {
                            self.coursePriceArray.append(price)
        
                        }
                        if let duration = self.singleTonClass.myfilterData[i]["duration"] as? String
                        {
                            self.courseDurationArray.add(duration)
        
                        }
                        if let cover_type = self.singleTonClass.myfilterData[i]["cover_type"] as? String
                        {
                            self.courseCoverTypeArray.add(cover_type)
        
                        }
                        if let purchased = self.singleTonClass.myfilterData[i]["purchased"] as? String
                        {
                            self.coursePurchasedArray.add(purchased)
                            
                        }
                        if let tags = self.singleTonClass.myfilterData[i]["tags"] as? String
                        {
                            self.courseTagsArray.add(tags)
                            
                        }
                        if let total_ratings = self.singleTonClass.myfilterData[i]["total_ratings"] as? String
                        {
                            self.courseRatingsArray.add(total_ratings)
                            
                        }
                        if let offer_price = self.singleTonClass.myfilterData[i]["offer_price"] as? String
                        {
                            self.courseOfferPriceArray.append(offer_price)
                            
                        }
                      if let course_id = self.singleTonClass.myfilterData[i]["course_id"] as? String
                        {
                            self.courseIdArray.add(course_id)
                            
                        }
            if let thumbnail = self.singleTonClass.myfilterData[i]["thumbnail"] as? String
            {
                self.courseThumbnails.add(base_path+thumbnail)
                
            }
            if let currency = self.singleTonClass.myfilterData[i]["currency"] as? String
            {
                self.courseCurrencyType.append(currency)
                
            }
            
            }
            
           }
        
        else{
            
                categoryListPostMethod()
          }
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        if singleTonClass.isFilterApplied == true
        {
            let vc = storyboard?.instantiateViewController(withIdentifier:"FilterVC") as! FilterVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
         else if chekStr == "catageories"
        {
            self.navigationController?.popViewController(animated: true)
        }
            
        else{
            
            let vc = storyboard?.instantiateViewController(withIdentifier:"DiscoverVC") as! DiscoverVC
            self.navigationController?.pushViewController(vc, animated: false)
            navigationCheck = ""
        }
        

    }
    
    
    // MARK: - filter
    
    @IBAction func filterBarBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       if(singleTonClass.isFilterApplied == true){

             return courseImagesArray.count
        }else{
        
               return courseImagesArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath) as! CustomCollectionViewCell
            
       if courseCoverTypeArray[indexPath.row] as? String == "image"
        {
            DispatchQueue.global().async {
                
                cell.imageview_banner.sd_setImage(with: URL (string:self.courseImagesArray[indexPath.row] as! String))
            }
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.courseThumbnails[indexPath.row] as! String))
            
            
        }
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lblName, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_price, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_priceDummy, fontSize: 14)
             GeneralFunctions.labelCustom_RTBold(labelName: cell.imageOfferName, fontSize: 14)
            
        }
        else if language == "en"
        {
            
            GeneralFunctions.labelCustom_LTReg(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.lblName, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.lbl_price, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: cell.lbl_priceDummy, fontSize: 14)
             GeneralFunctions.labelCustom_LTBold(labelName: cell.imageOfferName, fontSize: 14)
            
        }
        
      
        cell.duration.text = courseDurationArray[indexPath.row] as? String
        cell.lblName.text = courseTitleArray[indexPath.row] as? String
        cell.ratingLbl.text = courseRatingsArray[indexPath.row] as? String
        //let cost = "SAR\(coursePriceArray[indexPath.row] as! String)"
        //cell.lbl_priceDummy.attributedText = cost.strikeThrough()
        cell.noOfPurchasesLbl.text = coursePurchasedArray[indexPath.row]as? String
        
        if courseOfferPriceArray[indexPath.row] != ""
        {
            cell.lbl_price.text = "\(courseOfferPriceArray[indexPath.row]) \(courseCurrencyType[indexPath.row])"
            let cost = "\(coursePriceArray[indexPath.row]) \(courseCurrencyType[indexPath.row])"
            cell.lbl_priceDummy.attributedText = cost.strikeThrough()
        }
        else
        {
            cell.lbl_price.text = "\(coursePriceArray[indexPath.row]) \(courseCurrencyType[indexPath.row])"
            cell.lbl_priceDummy.text = ""
        }


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
        
            cell.view_back.layer.cornerRadius = 8
            cell.view_back.layer.masksToBounds = true
            cell.view_back.layer.borderWidth = 0.3
            cell.view_back.layer.borderColor = UIColor.lightGray.cgColor


            return cell
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
          let yourWidth = collectionViewlist.bounds.width/2
          print(yourWidth)
            return CGSize(width: yourWidth, height: 210)
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
        
        if singleTonClass.isFilterApplied == true
        {
            navigation1 = "filter"
        }
        else
        {
            navigation1 = "catageory"
            
        }
        vc.detailsCourseId = courseIdArray[indexPath.row] as? String ?? ""
        vc.videoToPlay = courseImagesArray[indexPath.row] as? String ?? ""
        vc.catageoryType = courseCoverTypeArray[indexPath.row]as? String ?? ""
        vc.thumbnail = courseThumbnails[indexPath.row] as? String ?? ""
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // CATEGORYlIST POST SEVICE CALL
    
    func categoryListPostMethod()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let category = "\(base_path)services/courses_list"
           
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
          
            let parameters: Dictionary<String, Any> = ["category_id" : catId,
                                                       "sub_category_id" : "",
                                                       "lang" :language,
                                                       "api_key":APIKEY,
                                                       "price_from":"",
                                                       "price_to":"",
                                                       "ratings":"",
                                                       "sort_by":""
            ]
            
          print(parameters)
            
            Alamofire.request(category, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                   // print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                   
                    if status == 1
                    {
                        
                         if let categoryList = responseData["data"] as? [[String:Any]]
                         {
                            
                            if self.courseThumbnails.count > 0 ||
                            self.courseIdArray.count > 0 ||
                            self.courseNameArray.count > 0 ||
                            self.courseTagsArray.count > 0 ||
                            self.coursePriceArray.count > 0 ||
                            self.courseTitleArray.count > 0 ||
                            self.courseImagesArray.count > 0 ||
                            self.courseRatingsArray.count > 0 ||
                            self.courseDurationArray.count > 0 ||
                            self.courseCoverTypeArray.count > 0 ||
                            self.coursePurchasedArray.count > 0 ||
                            self.courseOfferPriceArray.count > 0 ||
                                self.courseCurrencyType.count > 0
                            {
                                self.courseThumbnails.removeAllObjects()
                                    self.courseIdArray.removeAllObjects()
                                    self.courseNameArray.removeAllObjects()
                                    self.courseTagsArray.removeAllObjects()
                                    self.coursePriceArray.removeAll()
                                    self.courseTitleArray.removeAllObjects()
                                    self.courseImagesArray.removeAllObjects()
                                    self.courseRatingsArray.removeAllObjects()
                                    self.courseDurationArray.removeAllObjects()
                                    self.courseCoverTypeArray.removeAllObjects()
                                    self.coursePurchasedArray.removeAllObjects()
                                    self.courseOfferPriceArray.removeAll()
                                   self.courseCurrencyType.removeAll()
                            }
                            
                        
                            for i in 0..<categoryList.count
                            {
                                if let imgCover = categoryList[i]["cover"] as? String
                                {
                                    self.courseImagesArray.add(base_path+imgCover)
                                    
                                }
                                if let cat_name = categoryList[i]["category_name"] as? String
                                {
                                    self.courseNameArray.add(cat_name)
                                    
                                }
                                if let course_title = categoryList[i]["course_title"] as? String
                                {
                                    self.courseTitleArray.add(course_title)
                                    
                                }
                                if let price = categoryList[i]["price"] as? String
                                {
                                    self.coursePriceArray.append(price)
                                    
                                }
                                if let duration = categoryList[i]["duration"] as? String
                                {
                                    self.courseDurationArray.add(duration)
                                    
                                }
                                if let cover_type = categoryList[i]["cover_type"] as? String
                                {
                                    self.courseCoverTypeArray.add(cover_type)
                                    
                                }
                                if let purchased = categoryList[i]["purchased"] as? String
                                {
                                    self.coursePurchasedArray.add(purchased)
                                    
                                }
                                if let tags = categoryList[i]["tags"] as? String
                                {
                                    self.courseTagsArray.add(tags)
                                    
                                }
                                if let total_ratings = categoryList[i]["total_ratings"] as? String
                                {
                                    self.courseRatingsArray.add(total_ratings)
                                    
                                }
                                if let offer_price = categoryList[i]["offer_price"] as? String
                                {
                                    self.courseOfferPriceArray.append(offer_price)
                                    
                                }
                                if let course_id = categoryList[i]["course_id"] as? String
                                {
                                    self.courseIdArray.add(course_id)
                                    
                                }
                                if let thumbnail = categoryList[i]["thumbnail"] as? String
                                {
                                    self.courseThumbnails.add(base_path+thumbnail)
                                    
                                }
                                if let currency = categoryList[i]["currency"] as? String
                                {
                                    self.courseCurrencyType.append(currency)
                                    
                                }
                                
                                
                            }
                            
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        DispatchQueue.main.async {
                           
                            self.collectionViewlist.reloadData()
                           
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
        else
        {
           showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            
        }
        
    }
    
    
}
