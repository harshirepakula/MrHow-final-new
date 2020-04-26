//
//  SearchViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 7/18/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
    var currencyType = [String]()
    
    @IBOutlet weak var searchCollection: UICollectionView!
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
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
        
        if let aSize = UIFont(name:fontStyle, size: 18) {
             self.navigationItem.title = languageChangeString(a_str: "Search Results")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            //print("font changed")
            
        }

        // Do any additional setup after loading the view.
    }
    
    
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
        self.currencyType.removeAll()
        
        if(singleTonClass.isSearchApplied == true)
        {
            
            
            for i in 0..<self.singleTonClass.searchData.count
            {
                if let imgCover = self.singleTonClass.searchData[i]["cover"] as? String
                {
                    self.courseImagesArray.add(base_path+imgCover)
                    
                }
                if let cat_name = self.singleTonClass.searchData[i]["category_name"] as? String
                {
                    self.courseNameArray.add(cat_name)
                    
                }
                if let course_title = self.singleTonClass.searchData[i]["course_title"] as? String
                {
                    self.courseTitleArray.add(course_title)
                    
                }
                if let price = self.singleTonClass.searchData[i]["price"] as? String
                {
                    self.coursePriceArray.append(price)
                    
                }
                if let duration = self.singleTonClass.searchData[i]["duration"] as? String
                {
                    self.courseDurationArray.add(duration)
                    
                }
                if let cover_type = self.singleTonClass.searchData[i]["cover_type"] as? String
                {
                    self.courseCoverTypeArray.add(cover_type)
                    
                }
                if let purchased = self.singleTonClass.searchData[i]["purchased"] as? String
                {
                    self.coursePurchasedArray.add(purchased)
                    
                }
                if let tags = self.singleTonClass.searchData[i]["tags"] as? String
                {
                    self.courseTagsArray.add(tags)
                    
                }
                if let total_ratings = self.singleTonClass.searchData[i]["total_ratings"] as? String
                {
                    self.courseRatingsArray.add(total_ratings)
                    
                }
                if let offer_price = self.singleTonClass.searchData[i]["offer_price"] as? String
                {
                    self.courseOfferPriceArray.append(offer_price)
                    
                }
                if let course_id = self.singleTonClass.searchData[i]["course_id"] as? String
                {
                    self.courseIdArray.add(course_id)
                    
                }
                if let currency = self.singleTonClass.searchData[i]["currency"] as? String
                {
                    self.currencyType.append(currency)
                    
                }
                
                if let thumbnail = self.singleTonClass.searchData[i]["thumbnail"] as? String
                {
                    self.courseThumbnails.add(base_path+thumbnail)
                    
                }
                
            }
            
        }
            
    }
    
    
    
    @IBAction func backButtonTap(_ sender: Any)
    {
        self.singleTonClass.isSearchApplied = false
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

    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return courseImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "search", for: indexPath) as! CustomCollectionViewCell
        
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
            cell.lbl_price.text = "\(courseOfferPriceArray[indexPath.row]) \(currencyType[indexPath.row])"
            let cost = "\(coursePriceArray[indexPath.row]) \(currencyType[indexPath.row])"
            cell.lbl_priceDummy.attributedText = cost.strikeThrough()
        }
        else
        {
            cell.lbl_price.text = "\(coursePriceArray[indexPath.row]) \(currencyType[indexPath.row])"
            cell.lbl_priceDummy.text = ""
        }
        
        
        if let tag = courseTagsArray[indexPath.row] as? String
        {
            print(tag)
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
        
        let yourWidth = searchCollection.bounds.width/2
        return CGSize(width: yourWidth, height: 210)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
        if singleTonClass.isFilterApplied == true
        {
           navigation1 = "search"
        }
        
        vc.detailsCourseId = courseIdArray[indexPath.row] as? String ?? ""
        vc.videoToPlay = courseImagesArray[indexPath.row] as? String ?? ""
        vc.catageoryType = courseCoverTypeArray[indexPath.row]as? String ?? ""
        vc.thumbnail = courseThumbnails[indexPath.row] as? String ?? ""
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
