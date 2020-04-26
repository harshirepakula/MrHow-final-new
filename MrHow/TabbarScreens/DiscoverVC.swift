//
//  DiscoverVC.swift
//  MrHow
//
//  Created by volivesolutions on 21/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MOLH


var style1 = ""

class DiscoverVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    //instance for singleton
    let singleTonClass  = Singleton.shared
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    @IBOutlet weak var recommendedSt: UILabel!
    @IBOutlet weak var newCourseSt: UILabel!
    @IBOutlet weak var catageoriesSt: UILabel!
    @IBOutlet weak var backViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchBagView: UIView!
    
    
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var newViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var recView: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var backView: UIView!
   
    
    @IBOutlet weak var catView: UIView!
    @IBOutlet weak var collectionView_banner: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
     @IBOutlet weak var collectionView_cat: UICollectionView!
     @IBOutlet weak var collectionView_newCourse: UICollectionView!
     @IBOutlet weak var collectionView_recCourse: UICollectionView!
    
    @IBOutlet weak var catViewAllBtn: UIButton!
    @IBOutlet weak var btn_viewAllNewCourse: UIButton!
     @IBOutlet weak var btn_viewAllRecommended: UIButton!
    
    
    var bannerColor : String! = ""
    var coursesColor: String! = ""
    
  
    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating_1")!
    let emptyStarImage: UIImage = UIImage(named: "rate")!
    
   
    var timer:Timer!
    var bannerCourseTitleArray = NSMutableArray()
    var bannerCat_nameArray = NSMutableArray()
    var bannerLinkArray = [String]()
    var bannerRatingsArray = NSMutableArray()
    var bannercourse_idArray = NSMutableArray()
    var imagesBannerArray = NSMutableArray()
    var bannerCoverTypeArray = NSMutableArray()
    var thumbnailBanner = NSMutableArray()
    var currencyType = [String]()
    
    
    var catImagesArray = NSMutableArray()
    var catNamesArray = NSMutableArray()
    var catIdArray = NSMutableArray()
   
    var newCourseImagesArray = NSMutableArray()
    var newCourseTitleArray = NSMutableArray()
    var newCoursenameArray = NSMutableArray()
    var newCoursePriceArray = [String]()
    var newCourseRatingsArray = NSMutableArray()
    var newCourse_idArray = NSMutableArray()
    var newCoursePurchaseArray = NSMutableArray()
    var newCourseOfferPriceArray = [String]()
    var newCourseTagsArray = NSMutableArray()
    var newCourseCoverTypeArray = NSMutableArray()
    var newCourseDurationArray = NSMutableArray()
    var newCourseCurrencyArray = [String]()
    var thumbnailNewCourse = NSMutableArray()
    
    
    var recCourseImagesArray = NSMutableArray()
    var recCourseTitleArray = NSMutableArray()
    var recCoursenameArray = NSMutableArray()
    var recCoursePriceArray = [String]()
    var recCourseRatingsArray = NSMutableArray()
    var recCourse_idArray = NSMutableArray()
    var recCourseViewsArray = NSMutableArray()
    var recCourseOfferPriceArray = [String]()
    var recCourseCoverTypeArray = NSMutableArray()
    var recCourseDurationArray = NSMutableArray()
    var thumbnailRecCourse = NSMutableArray()
    var recCourseTag = NSMutableArray()
    var recCourseCurrencyArray = [String]()
    
    
    
    // Shiva Changed
    var dicServiceResponse: NSDictionary!
    var strImageBasePath: String!
    var catServiceResponse: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
       
       
       
        createUI()
        
        
        
    }
    
    
    func createUI()
    {
        self.navigationItem.titleView = UIImageView.init(image: UIImage.init(named: "HomeLogo"))
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(DiscoverVC.autoScrollImageSlider), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
       
       
        tabBarController?.tabBar.items?[0].title = languageChangeString(a_str: "Studio")
        tabBarController?.tabBar.items?[1].title = languageChangeString(a_str: "Discover")
        tabBarController?.tabBar.items?[2].title = languageChangeString(a_str: "My Courses")
        tabBarController?.tabBar.items?[3].title = languageChangeString(a_str: "Profile")
        
        
        
        
        // searchTF.placeholder = languageChangeString(a_str: "Search For Coursename")
        self.newCourseSt.text = languageChangeString(a_str: "New Course")
        self.catageoriesSt.text = languageChangeString(a_str: "Categories")
        self.recommendedSt.text = languageChangeString(a_str: "Recommended Courses")
        
        btn_viewAllNewCourse.setTitle(languageChangeString(a_str: "View All"), for: .normal)
        btn_viewAllRecommended.setTitle(languageChangeString(a_str: "View All"), for: .normal)
        
        catViewAllBtn.setTitle(languageChangeString(a_str: "View All"), for: .normal)
        
        
        if language == "ar"
        {
           self.searchTF.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.searchTF.textAlignment = .right
            self.searchTF.setPadding(left: -10, right: -10)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            GeneralFunctions.labelCustom_RTBold(labelName:newCourseSt, fontSize: 15)
            GeneralFunctions.labelCustom_RTBold(labelName:catageoriesSt, fontSize: 15)
            GeneralFunctions.labelCustom_RTBold(labelName:recommendedSt, fontSize: 15)
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_viewAllNewCourse, fontSize: 14)
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_viewAllRecommended, fontSize: 14)
            GeneralFunctions.buttonCustom_RTReg(buttonName: catViewAllBtn, fontSize: 14)
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: searchTF, strPlaceHolderName: languageChangeString(a_str: "Search For Coursename") ?? "")
            style1 = "29LTBukra-Regular"
            
        }
        else if language == "en"{
            self.searchTF.font = UIFont(name: "Poppins-Regular", size: 12)
            self.searchTF.textAlignment = .left
            self.searchTF.setPadding(left: 10, right: 10)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            GeneralFunctions.labelCustom_LTMedium(labelName:newCourseSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTMedium(labelName:catageoriesSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTMedium(labelName:recommendedSt, fontSize: 18)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_viewAllNewCourse, fontSize: 14)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_viewAllRecommended, fontSize: 14)
            GeneralFunctions.buttonCustom_LTReg(buttonName: catViewAllBtn, fontSize: 14)
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: searchTF, strPlaceHolderName: languageChangeString(a_str: "Search For Coursename") ?? "")
            style1 = "Poppins-Regular"
        }
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

          createUI()

        singleTonClass.isFilterApplied = false
        singleTonClass.isSearchApplied = false

        DispatchQueue.main.async {
            
            if Reachability.isConnectedToNetwork()
            {
        
         if let image = UserDefaults.standard.object(forKey:"userImage") as? String
        {
            let image1 = UIImage(data: try! Data(contentsOf: URL(string:image)!))!
            
            let thumb1 = image1.resized(withPercentage: 0.1)
            let thumb2 = image1.resized(toWidth: 35.0)
            
            
            //let thumb3 = image1.resize(targetSize: CGSize(width: 35, height: 35))
            self.tabBarController!.tabBar.items?[3].selectedImage =
                thumb2?.roundedImage.withRenderingMode(.alwaysOriginal)
            self.tabBarController!.tabBar.items?[3].image =
                thumb2?.roundedImage.withRenderingMode(.alwaysOriginal)
            
              }
                
            }
            else
            {
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            }
        
        }
        
        
        discoverData()
        newRecomendedCourses()
        
       
        navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    //MARK:- VIew all NewCourse Button
    @IBAction func viewAllNewCourseBtnTap(_sender: UIButton){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllCourseList") as! ViewAllCourseList
        
        let arrNewCourseList : NSArray = self.dicServiceResponse.object(forKey: "new_courses") as! NSArray
        vc.arrGetCourseList = arrNewCourseList
        vc.newRecommendedCourseCheckValue = 1
        vc.getBasePath = strImageBasePath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- VIew all NewCourse Button
    
    @IBAction func viewallRecommendedBtnTap(_sender: UIButton){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllCourseList") as! ViewAllCourseList
        
        let arrRecommendedList : NSArray = self.dicServiceResponse.object(forKey: "recommended") as! NSArray
        vc.arrGetCourseList = arrRecommendedList
        vc.newRecommendedCourseCheckValue = 2
        vc.getBasePath = strImageBasePath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func catViewAllBtnTap(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
        navigationCheck = "All Courses"
        catId = ""
        
       self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    //MARK:- AUTO SCROLLING ADV
    @objc func autoScrollImageSlider() {
        
        DispatchQueue.main.async {
            
            let visibleItems = self.collectionView_banner.indexPathsForVisibleItems
            
            if visibleItems.count > 0 {
                
                var currentItemIndex: IndexPath? = visibleItems[0]
                
                if currentItemIndex?.item == self.thumbnailBanner.count - 1 {
                    let nexItem = IndexPath(item: 0, section: 0)
                    
                    self.collectionView_banner.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                    
                } else {
                    
                    let nexItem = IndexPath(item: (currentItemIndex?.item ?? 0) + 1, section: 0)
                    
                    self.collectionView_banner.scrollToItem(at: nexItem, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    
    
   
    
    
    // star rating
    func getStarImage(starNumber: Int, forRating rating: Int) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        }  else {
            return emptyStarImage
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionView_banner
        {
          return thumbnailBanner.count
            
        }
        else if collectionView == collectionView_cat
        {
            return catImagesArray.count
        }
        else if collectionView == collectionView_newCourse
        {
            
                return newCourseImagesArray.count
            
        }
        else
        {
            return recCourseImagesArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == collectionView_banner
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannersCollectionViewCell", for: indexPath) as! BannersCollectionViewCell

            cell.imageview_banner.sd_setImage(with: URL (string:thumbnailBanner[indexPath.row] as? String ?? ""))
            

        
            return cell
        }
        else if collectionView == collectionView_cat
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath) as! CustomCollectionViewCell
            
            cell.imageview_banner.sd_setImage(with: URL (string:catImagesArray[indexPath.row] as! String))
            
            if language == "en"
            {
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_mainTitle, fontSize: 10)
               
                
            }
            else if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_mainTitle, fontSize: 10)
               
            }
            
           cell.lbl_mainTitle.text = catNamesArray[indexPath.row] as? String
            
          return cell
        }
        else if collectionView == collectionView_newCourse
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new", for: indexPath) as! CustomCollectionViewCell
            cell.view_back.layer.cornerRadius = 8
            cell.view_back.layer.masksToBounds = true
            cell.view_back.layer.borderWidth = 0.3
            cell.view_back.layer.borderColor = UIColor.lightGray.cgColor
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
            
            
            if newCourseCoverTypeArray[indexPath.row] as? String == "image"
            {
                cell.imageview_banner.sd_setImage(with: URL (string:self.newCourseImagesArray[indexPath.row] as! String))
                    
            }
            else
            {
                cell.imageview_banner.sd_setImage(with: URL (string:self.thumbnailNewCourse[indexPath.row] as! String))
               
            }

         
            cell.lblName.text = newCourseTitleArray[indexPath.row] as? String
            cell.duration.text = newCourseDurationArray[indexPath.row]as? String
            
            cell.noOfPurchasesLbl.text = newCoursePurchaseArray[indexPath.row]as? String
            cell.ratingLbl.text = newCourseRatingsArray[indexPath.row]as? String
            
            if newCourseOfferPriceArray[indexPath.row] != ""
            {
                cell.lbl_price.text = "\(newCourseOfferPriceArray[indexPath.row]) \(newCourseCurrencyArray[indexPath.row])"
                let cost = "\(newCoursePriceArray[indexPath.row]) \(newCourseCurrencyArray[indexPath.row])"
                cell.lbl_priceDummy.attributedText = cost.strikeThrough()
                
            }
            else
            {
                cell.lbl_price.text = "\(newCoursePriceArray[indexPath.row]) \(newCourseCurrencyArray[indexPath.row])"
                cell.lbl_priceDummy.text = ""
            }
            
            if let tag = newCourseTagsArray[indexPath.row] as? String
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
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rec", for: indexPath) as! CustomCollectionViewCell
            
            if recCourseCoverTypeArray[indexPath.row] as? String == "image"
            {
                cell.imageview_banner.sd_setImage(with: URL (string:recCourseImagesArray[indexPath.row] as! String))
            }
            else
            {
                cell.imageview_banner.sd_setImage(with: URL (string:thumbnailRecCourse[indexPath.row] as! String))
            }
            
            cell.duration.text = recCourseDurationArray[indexPath.row]as? String
            
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
           
            cell.lblName.text = recCourseTitleArray[indexPath.row] as? String
            
            if recCourseOfferPriceArray[indexPath.row] != ""
            {
            cell.lbl_price.text = "\(recCourseOfferPriceArray[indexPath.row]) \(recCourseCurrencyArray[indexPath.row])"
            let cost = "\(recCoursePriceArray[indexPath.row]) \(recCourseCurrencyArray[indexPath.row])"
            cell.lbl_priceDummy.attributedText = cost.strikeThrough()
                
              
            }
            else
            {
                cell.lbl_price.text = "\(recCoursePriceArray[indexPath.row]) \(recCourseCurrencyArray[indexPath.row])"
                cell.lbl_priceDummy.text = ""
                
               
            }
            cell.noOfPurchasesLbl.text = recCourseViewsArray[indexPath.row]as? String
            cell.ratingLbl.text = recCourseRatingsArray[indexPath.row]as? String
          
            // self.collectionView_recCourse.backgroundColor = UIColor(hexString: self.bannerColor)
            
           if let tag = recCourseTag[indexPath.row] as? String
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
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Did Selected")
        
        if collectionView == collectionView_cat
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
            catageoryName =  catNamesArray[indexPath.row] as? String ?? ""
            catId = catIdArray[indexPath.row] as? String ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if collectionView == collectionView_banner
        {
            let urlToGive = bannerLinkArray[indexPath.row]
            
            guard let url = URL(string: urlToGive) else { return }
            UIApplication.shared.open(url)
        }
        else if collectionView == collectionView_newCourse
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
            
            vc.detailsCourseId = newCourse_idArray[indexPath.row] as? String ?? ""
            vc.videoToPlay = newCourseImagesArray[indexPath.row] as? String ?? ""
            vc.catageoryType = newCourseCoverTypeArray[indexPath.row] as? String ?? ""
            vc.thumbnail = thumbnailNewCourse[indexPath.row] as? String ?? ""
            
            navigation1 = "discover"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView == collectionView_recCourse
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
            
            vc.detailsCourseId = recCourse_idArray[indexPath.row] as? String ?? ""
//            vc.videoToPlay = recCourseImagesArray[indexPath.row] as? String ?? ""
//            vc.catageoryType = recCourseCoverTypeArray[indexPath.row] as? String ?? ""
//
//            vc.thumbnail = thumbnailRecCourse[indexPath.row] as? String ?? ""
            navigation1 = "discover"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == collectionView_banner
        {
            let yourWidth = collectionView_banner.bounds.width
               print(yourWidth)
              return CGSize(width: yourWidth, height: 170)
        }
        else if collectionView == collectionView_cat
        {
            //let yourWidth = collectionView_banner.bounds.width
             let yourHeight = collectionView_cat.bounds.height
            
            return CGSize(width: 80, height: yourHeight)
        }
        else if collectionView == collectionView_newCourse
        {
              let yourWidth = collectionView_newCourse.bounds.width/2
              print(yourWidth)

            return CGSize(width: yourWidth, height: 190)
        }
        else
        {
            //var yourHeight : CGFloat = 0
           
               // yourHeight = collectionView_recCourse.contentSize.height
           
            let yourWidth = collectionView_recCourse.bounds.width/2
            
            
            
            return CGSize(width: yourWidth, height: 190)
        }
        
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView_banner {
            
            self.pageControl.currentPage = indexPath.row
        }
    }

    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
         // self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Back Button
    
    @IBAction func filterBarBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    //service call for banner and catageories
    
    func discoverData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let banner_catData = "\(base_path)services/discover?"
    
            //https://volive.in/mrhow_dev/services/discover?api_key=1762019&lang=en
          
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY , "lang":language]
            
            Alamofire.request(banner_catData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                         MobileFixServices.sharedInstance.dissMissLoader()
                        
                        self.catServiceResponse = responseData["data"] as? NSDictionary
                        
                       if let response1 = responseData["data"] as? Dictionary<String, Any>
                       {
                        
                        if let color = response1["bg_color"] as? String
                        {
                            self.bannerColor = color
                        }
                        
                        
                        if let bannersArray = response1["banner"] as? [[String:Any]]{
                            print(bannersArray)

                            if(self.bannerLinkArray.count > 0) ||
                                (self.thumbnailBanner.count > 0)
                              {
                               
                                self.bannerLinkArray.removeAll()
                                self.thumbnailBanner.removeAllObjects()
                                
                            }

                           
                            for i in 0..<bannersArray.count
                            {
                            
                                if let link1 = bannersArray[i]["link"] as? String
                                {
                                    self.bannerLinkArray.append(link1)
                                }

                                if let thumbnail = bannersArray[i]["banner"] as? String
                                {
                                    self.thumbnailBanner.add(base_path+thumbnail)
                                }
                                
                            }
                          
                            print(self.thumbnailBanner)
                            self.pageControl.numberOfPages = self.thumbnailBanner.count
                            DispatchQueue.main.async {
                               
                                self.collectionView_banner.reloadData()
                                self.backView.backgroundColor = UIColor(hexString: self.bannerColor)
                                self.searchBagView.backgroundColor = UIColor(hexString: self.bannerColor)
                                self.collectionView_newCourse.backgroundColor = self.hexStringToUIColor(hex: self.bannerColor)
                                self.collectionView_recCourse.backgroundColor =
                                 self.hexStringToUIColor(hex: self.bannerColor)
                                }
                           }
                    
                      if let catArray = response1["categories"] as? [[String:Any]]  {
                            // print(bannersArray)
                        if(self.catImagesArray.count > 0)||(self.catNamesArray.count > 0)||(self.catIdArray.count > 0)
                        {
                            self.catImagesArray.removeAllObjects()
                            self.catNamesArray.removeAllObjects()
                            self.catIdArray.removeAllObjects()
                           
                        }
                        
                           for i in 0..<catArray.count
                            {
                                if let imgCover = catArray[i]["icon"] as? String
                                {
                                    self.catImagesArray.add(base_path+imgCover)
                                    
                                }
                                if let cat_name = catArray[i]["category_name"] as? String
                                {
                                    self.catNamesArray.add(cat_name)
                                }
                                if let cat_id = catArray[i]["category_id"] as? String
                                {
                                    self.catIdArray.add(cat_id)
                                    
                                }
                                
                            }
                        
                        
                        if catArray.count>0
                        {
                            self.catViewAllBtn.isHidden = false
                        }
                        else
                        {
                            self.catViewAllBtn.isHidden = true
                        }
                            DispatchQueue.main.async {
                               
                                self.collectionView_cat.reloadData()
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
    
    
    
    //service call for newCourses and recommemdedcorses
    
    func newRecomendedCourses()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let newcourse = "\(base_path)services/discover_courses?"
            
            //https://volive.in/mrhow_dev/services/discover_courses?api_key=1762019&lang=en
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language]
            
            Alamofire.request(newcourse, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    self.strImageBasePath = responseData["base_url"] as? String
                    if status == 1
                    {
                        
                        self.dicServiceResponse = responseData["data"] as? NSDictionary
                        
                        print("@@@@@@@@@")
                        print(self.dicServiceResponse.count)
                        
                        
                        if let response1 = responseData["data"] as? Dictionary<String, Any>
                        {
                            if let color = response1["bg_color"] as? String
                            {
                                self.coursesColor = color
                            }
                            
                            
                            if let newCourses = response1["new_courses"] as? [[String:Any]]{
                                // print(bannersArray)
                                if(self.newCourseImagesArray.count > 0)||(self.newCoursePriceArray.count > 0)||(self.newCoursenameArray.count > 0)||(self.newCourseRatingsArray.count > 0)||(self.newCourse_idArray.count > 0)||(self.newCourseTitleArray.count > 0)||(self.newCourseCoverTypeArray.count > 0)||(self.newCoursePurchaseArray.count > 0)||(self.newCourseTagsArray.count > 0)||(self.newCourseOfferPriceArray.count > 0)
                                    ||
                                    (self.newCourseDurationArray.count > 0)||(self.newCourseCurrencyArray.count > 0)
                                {
                                    self.newCourseImagesArray.removeAllObjects()
                                    self.newCoursePriceArray.removeAll()
                                    self.newCoursenameArray.removeAllObjects()
                                    self.newCourseRatingsArray.removeAllObjects()
                                    self.newCourse_idArray.removeAllObjects()
                                    self.newCourseTitleArray.removeAllObjects()
                                    self.newCourseCoverTypeArray.removeAllObjects()
                                    self.newCourseTagsArray.removeAllObjects()
                                    self.newCoursePurchaseArray.removeAllObjects()
                                    self.newCourseOfferPriceArray.removeAll()
                                    self.newCourseDurationArray.removeAllObjects()
                                    self.newCourseCurrencyArray.removeAll()
                                }
                                 print(newCourses.count)
                               
                               if newCourses.count > 0
                               {
                                for i in 0..<newCourses.count
                                {
                                    if let imgCover = newCourses[i]["cover"] as? String
                                    {
                                        self.newCourseImagesArray.add(base_path+imgCover)
                                        
                                    }
                                    if let price = newCourses[i]["price"] as? String
                                    {
                                        self.newCoursePriceArray.append(price)
                                    }
                                    if let cat_name = newCourses[i]["category_name"] as? String
                                    {
                                        self.newCoursenameArray.add(cat_name)
                                        
                                    }
                                    if let rating = newCourses[i]["total_ratings"] as? String
                                    {
                                        self.newCourseRatingsArray.add(rating)
                                    }
                                    if let id = newCourses[i]["course_id"] as? String
                                    {
                                        self.newCourse_idArray.add(id)
                                        
                                    }
                                    if let title = newCourses[i]["course_title"] as? String
                                    {
                                        self.newCourseTitleArray.add(title)
                                    }
                                    
                                    if let type = newCourses[i]["cover_type"] as? String
                                    {
                                        self.newCourseCoverTypeArray.add(type)
                                        
                                    }
                                    if let purchase = newCourses[i]["purchased"] as? String
                                    {
                                        self.newCoursePurchaseArray.add(purchase)
                                    }
                                    if let tag = newCourses[i]["tags"] as? String
                                    {
                                        self.newCourseTagsArray.add(tag)
                                        
                                    }
                                    if let offerPrice = newCourses[i]["offer_price"] as? String
                                    {
                                        self.newCourseOfferPriceArray.append(offerPrice)
                                    }
                                    if let duration = newCourses[i]["duration"] as? String
                                    {
                                        self.newCourseDurationArray.add(duration+"m")
                                    }
                                  
                                    if let thumbnail = newCourses[i]["thumbnail"] as? String
                                    {
                                        self.thumbnailNewCourse.add(base_path+thumbnail)
                                    }
                                    if let currency = newCourses[i]["currency"] as? String
                                    {
                                        self.newCourseCurrencyArray.append(currency)
                                    }
                                    
                                 }
                                
                                DispatchQueue.main.async {
                                    self.btn_viewAllNewCourse.isHidden = false
                                    self.collectionView_newCourse.reloadData()
                                    
                                    
                                }
                                
                                }
                               else{
                           
                              self.collectionView_newCourse.isHidden = true
                            self.btn_viewAllNewCourse.isHidden = true
                                self.backViewHeight.constant = self.backViewHeight.constant - self.newViewHeight.constant+20
                               self.newViewHeight.constant = 0
                               self.view.layoutIfNeeded()
                                }
                            }
                            
                        MobileFixServices.sharedInstance.dissMissLoader()
                            
                    if let recCourses = response1["recommended"] as? [[String:Any]]
                    {
                     
                        if(self.recCourseImagesArray.count > 0)||(self.recCoursePriceArray.count > 0)||(self.recCoursenameArray.count > 0)||(self.recCourseRatingsArray.count > 0)||(self.recCourse_idArray.count > 0)||(self.recCourseTitleArray.count > 0)||(self.recCourseCoverTypeArray.count > 0)||(self.recCourseViewsArray.count > 0)||(self.recCourseOfferPriceArray.count > 0)
                            ||
                            (self.recCourseDurationArray.count > 0)||(self.recCourseCurrencyArray.count > 0)
                        {
                            self.recCourseImagesArray.removeAllObjects()
                            self.recCoursePriceArray.removeAll()
                            self.recCoursenameArray.removeAllObjects()
                            self.recCourseRatingsArray.removeAllObjects()
                            self.recCourse_idArray.removeAllObjects()
                            self.recCourseTitleArray.removeAllObjects()
                            self.recCourseCoverTypeArray.removeAllObjects()
                            self.recCourseViewsArray.removeAllObjects()
                            self.recCourseTag.removeAllObjects()
                            self.recCourseOfferPriceArray.removeAll()
                            self.recCourseDurationArray.removeAllObjects()
                            self.recCourseCurrencyArray.removeAll()
                            }
                       
                        for i in 0..<recCourses.count
                        {
                            if let imgCover = recCourses[i]["cover"] as? String
                            {
                                self.recCourseImagesArray.add(base_path+imgCover)
                                        
                            }
                            if let price = recCourses[i]["price"] as? String
                            {
                                self.recCoursePriceArray.append(price)
                            }
                            if let cat_name = recCourses[i]["category_name"] as? String
                            {
                                self.recCoursenameArray.add(cat_name)
                                        
                            }
                            if let rating = recCourses[i]["total_ratings"] as? String
                            {
                                 self.recCourseRatingsArray.add(rating)
                            }
                                    if let id = recCourses[i]["course_id"] as? String
                                    {
                                        self.recCourse_idArray.add(id)
                                        
                                    }
                                    if let title = recCourses[i]["course_title"] as? String
                                    {
                                        self.recCourseTitleArray.add(title)
                                    }
                            
                                    if let type = recCourses[i]["cover_type"] as? String
                                    {
                                        self.recCourseCoverTypeArray.add(type)
                                        
                                    }
                                    if let purchase = recCourses[i]["purchased"] as? String
                                    {
                                        self.recCourseViewsArray.add(purchase)
                                    }
                                    if let tag = recCourses[i]["tags"] as? String
                                    {
                                        self.recCourseTag.add(tag)

                                    }
                                    if let offerPrice = recCourses[i]["offer_price"] as? String
                                    {
                                        self.recCourseOfferPriceArray.append(offerPrice)
                                    }
                                   if let duration = recCourses[i]["duration"] as? String
                                  {
                                     self.recCourseDurationArray.add(duration+"m")
                                    }
                          
                            if let currency = recCourses[i]["currency"] as? String
                            {
                                self.recCourseCurrencyArray.append(currency)
                            }
                            
                            if let thumbnail = recCourses[i]["thumbnail"] as? String
                            {
                                self.thumbnailRecCourse.add(base_path+thumbnail)
                            }
                            
                            
                                }
                        
                        if recCourses.count>0
                        {
                            self.btn_viewAllRecommended.isHidden = false
                        }
                        else
                        {
                            self.btn_viewAllRecommended.isHidden = true
                        }
                        
                                 DispatchQueue.main.async {
                                   
                                   print(self.recCourseOfferPriceArray)
                                    print(self.recCoursePriceArray)
                                    self.collectionView_recCourse.reloadData()
                                    
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
    
    
    @IBAction func searchBtnTap(_ sender: Any)
    {
        if searchTF.text == "" || searchTF.text == nil
        {
            showToastForAlert (message: languageChangeString(a_str: "Please enter search Data")!, style: style1)
            //showToastForAlert(message: "Please enter search Data")
        }
    
            //internet connection
            
            if Reachability.isConnectedToNetwork()
            {
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let searchData = "\(base_path)services/search"
                
               //        https://volive.in/mrhow_dev/services/search
                
                // let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
             
                let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
                let parameters: Dictionary<String, Any> =
                    ["lang" :language,
                     "api_key":APIKEY, "search":searchTF.text ?? ""]
                                                           
                print(parameters)
                
                Alamofire.request(searchData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>
                    {
                       
                        
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if status == 1
                        {
                            self.singleTonClass.isSearchApplied = true
                            
                            if let searchResults = responseData["data"] as? [[String:Any]]
                            {
                                print(searchResults)
                                self.singleTonClass.searchData = searchResults
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
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



        
        
    
    
    
    
    
    
    
    
    
   


