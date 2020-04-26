//
//  ViewAllCourseList.swift
//  MrHow
//
//  Created by harshitha on 05/09/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class ViewAllCourseList: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionViewlist: UICollectionView!
    
    var arrGetCourseList: NSArray!
    
    var newRecommendedCourseCheckValue: Int!
    
    var getBasePath: String!
    
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        if let aSize = UIFont(name: fontStyle, size: 18) {
  
            
            
            
            if newRecommendedCourseCheckValue == 1{ // new Course
                
                 self.navigationItem.title = languageChangeString(a_str: "New Course")
            }
            else{
                
                self.navigationItem.title = languageChangeString(a_str: "Recommended Courses")
            }
            collectionViewlist.reloadData()
          
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
           
            
        }
        

        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Filter
    
    @IBAction func filterBarBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrGetCourseList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat1", for: indexPath) as! CustomCollectionViewCell
        
        if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lblName, fontSize: 13)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_price, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_priceDummy, fontSize: 14)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_LTBold(labelName: cell.imageOfferName, fontSize: 14)
            
        }
        else if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lblName, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_price, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_priceDummy, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.duration, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfPurchasesLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.ratingLbl, fontSize: 10)
            GeneralFunctions.labelCustom_RTBold(labelName: cell.imageOfferName, fontSize: 14)
        }
        
        
        
        cell.view_back.layer.cornerRadius = 8
        cell.view_back.layer.masksToBounds = true
        cell.view_back.layer.borderWidth = 0.3
        cell.view_back.layer.borderColor = UIColor.lightGray.cgColor
        
        let iteamDic = self.arrGetCourseList.object(at: indexPath.item) as? NSDictionary
        
        let strCourseName: String = iteamDic?.object(forKey: "course_title") as? String ?? ""
        
        
        let strPrice: String = iteamDic?.object(forKey: "price") as? String ?? ""
        let strOfferPrice: String = iteamDic?.object(forKey: "offer_price") as? String ?? ""
        let strCurrency: String = iteamDic?.object(forKey: "currency") as? String ?? ""
        let strRating: String = iteamDic?.object(forKey: "ratings") as? String ?? ""
        let strDuration: String = iteamDic?.object(forKey: "duration") as? String ?? ""
        let strPurchased: String = iteamDic?.object(forKey: "purchased") as? String ?? ""
        let strTag: String = iteamDic?.object(forKey: "tags") as? String ?? ""
        
        let StrThumbnailKey: String = iteamDic?.object(forKey: "thumbnail") as? String ?? ""
        let StrCoverImageKey: String = iteamDic?.object(forKey: "cover") as? String ?? ""
        let StrCoverType: String = iteamDic?.object(forKey: "cover_type") as? String ?? ""
        
        if StrCoverType == "image"{
            
            let strUrl  =  getBasePath + StrCoverImageKey
            cell.imageview_banner.sd_setImage(with: URL(string: strUrl), placeholderImage:nil)
        }
        else
        {
            let strUrl  =  getBasePath + StrThumbnailKey
            cell.imageview_banner.sd_setImage(with: URL(string: strUrl), placeholderImage:nil)
        }
        

        
        cell.duration.text = strDuration
        cell.lblName.text = strCourseName
        cell.ratingLbl.text = strRating
        cell.noOfPurchasesLbl.text = strPurchased
        
        if strOfferPrice != ""
        {
            cell.lbl_price.text = "\(strOfferPrice) \(strCurrency)"
            cell.lbl_priceDummy.attributedText = "\(strPrice) \(strCurrency)".strikeThrough()
        }
        else
        {
            cell.lbl_price.text = "\(strPrice) \(strCurrency)"
            cell.lbl_priceDummy.text = ""
        }


        
        let tag2 = Int(strTag)

        
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
        
        let yourWidth = collectionViewlist.bounds.width/2
        print(yourWidth)
        return CGSize(width: yourWidth, height: 210)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let iteamDic = self.arrGetCourseList.object(at: indexPath.item) as! NSDictionary
        
        let strCourseID: String = iteamDic.object(forKey: "course_id") as! String
        let StrCoverImageKey: String = iteamDic.object(forKey: "cover") as! String
        let strCourseUrl  =  getBasePath + StrCoverImageKey
        
        let StrThumbnailKey: String = iteamDic.object(forKey: "thumbnail") as! String
         let strThumbnailUrl  =  getBasePath + StrThumbnailKey
        
        let StrCoverType: String = iteamDic.object(forKey: "cover_type") as! String
    
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
        
         vc.detailsCourseId = strCourseID
         vc.videoToPlay     = strCourseUrl
         vc.catageoryType   = StrCoverType
        vc.thumbnail        = strThumbnailUrl
  
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
