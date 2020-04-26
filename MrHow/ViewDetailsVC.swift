//
//  ViewDetailsVC.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 7/6/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

var navigation1 = ""

class ViewDetailsVC: UIViewController,CAPSPageMenuDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate {
   
    var appDelegate = AppDelegate()
    
    @IBOutlet var detailsImg: UIImageView!
    @IBOutlet weak var videoBtnToPlay: UIButton!
    @IBOutlet weak var coursePriceLbl: UILabel!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var addToWishListBtn: UIButton!
    @IBOutlet weak var buyNowHeight: NSLayoutConstraint!
    @IBOutlet weak var offerPriceLbl: UILabel!
    @IBOutlet weak var backView: UIView!
  
    @IBOutlet weak var wishListHt: NSLayoutConstraint!
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    var coursePurchaseStatus = ""
    var coursePrice = ""
    var wishlistStatus = ""
    var courseOfferPrice = ""
    var courseTitle = ""
    var videoToPlay = ""
    var catageoryType = ""
    var detailsCourseId = ""
    var thumbnail = ""
    var currencyType = ""
    var style = ""
    
    var priceUsd = ""
    
    var window: UIWindow?
    
    //instance for singleton
    
    let singleTonClass  = Singleton.shared
    
    var pageMenu : CAPSPageMenu?
          var fontStyle = ""
        override func viewDidLoad() {
        super.viewDidLoad()

       appDelegate = UIApplication.shared.delegate as! AppDelegate
      
       self.navigationController?.navigationBar.barTintColor = ThemeColor


        // Do any additional setup after loading the view.
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                try audioSession.setCategory(.playback, mode: .moviePlayback)
            } else {
                // Fallback on earlier versions
            }
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
    
    
    @IBAction func playVideo(_ sender: UIButton)
    {
        if catageoryType == "video"
        {
            guard let url = URL(string: videoToPlay) else {
                return
            }
            
            player = AVPlayer(url: url)
            
            
            playerViewcontroller.player = player
            playerViewcontroller.showsPlaybackControls = true
            
            
            present(playerViewcontroller, animated: true) {
                player.play()
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.pageMenu?.delegate = self
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
      
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "View Details")
            
        }
        
        addToWishListBtn.layer.cornerRadius = 4
        addToWishListBtn.layer.masksToBounds = true
        addToWishListBtn.layer.borderWidth = 1.0
        addToWishListBtn.layer.borderColor = UIColor.black.cgColor
        
        self.buyNowBtn.setTitle(languageChangeString(a_str: "BUY NOW"), for: UIControl.State.normal)
        
        self.navigationItem.title = languageChangeString(a_str: "View Details")
        
        if language == "ar"
        {
            GeneralFunctions.buttonCustom_RTBold(buttonName: buyNowBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: addToWishListBtn, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: offerPriceLbl, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: coursePriceLbl, fontSize: 16)
            style = "29LTBukra-Bold"
            
        }
        else if language == "en"
        {
            GeneralFunctions.buttonCustom_LTBold(buttonName: buyNowBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_LTBold(buttonName: addToWishListBtn, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: offerPriceLbl, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: coursePriceLbl, fontSize: 16)
            style = "Poppins-SemiBold"
        }
        
        
       
        self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(addorRemove(_:)), name: NSNotification.Name(rawValue: "AddOrRemoveWishList"), object: nil)
        
        print(thumbnail)
        print(videoToPlay)
   
        
        courseDetails()
        
         NotificationCenter.default.addObserver(self, selector: #selector(buyNow1(_:)), name: NSNotification.Name(rawValue: "currency"), object: nil)
        
    }
    
  
    
    //MARK:- Notification Center Method
    @objc func buyNow1(_ notification: Notification)
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseDetailsVC") as! PurchaseDetailsVC
        vc.courseIdToBuy = self.detailsCourseId
      
        // 1 for sar
        //2 for usd
        
        if selectedCurrency == "1"
        {
            if self.courseOfferPrice != ""
            {
                vc.priceofTheCourse = self.courseOfferPrice
                
            }
            else
            {
                vc.priceofTheCourse = self.coursePrice
                
            }
            
            vc.currency = "SAR"
        }
        else
        {
            vc.priceofTheCourse = self.priceUsd
            vc.currency = "USD"
            
        }
       
        selectedCurrency = ""
        
                vc.courseToBuy = self.courseTitle
                //print(self.courseTitle)
                self.navigationController?.pushViewController(vc, animated: true)
        
        NotificationCenter.default.removeObserver(self)
       
    }
    
    
    //MARK:- Notification Center Method
    @objc func addorRemove(_ notification: Notification)
    {
       
        
        self.courseDetails()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
         NotificationCenter.default.removeObserver(self)
        
    }
    
    
    func setupPages()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var controllerArray: [UIViewController] = []
        
        let firstVC = storyboard.instantiateViewController(withIdentifier: "LessonsVC") as! LessonsVC
        firstVC.title = languageChangeString(a_str: "Lessons")
        //firstVC.title = "Lessons"
        firstVC.courseId = detailsCourseId
        firstVC.parentNavigationController = self.navigationController
        let secondVC = storyboard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        secondVC.title = languageChangeString(a_str: "About")
        secondVC.courseId = detailsCourseId
        secondVC.parentNavigationController = self.navigationController
        
        let thirdVC = storyboard.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        thirdVC.title = languageChangeString(a_str: "More")
        thirdVC.courseId = detailsCourseId
        thirdVC.parentNavigationController = self.navigationController
        
        
        
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 13/255.0, green: 205/255.0, blue: 120/255.0, alpha: 1.0)),
            .bottomMenuHairlineColor(UIColor.lightGray),
            .menuHeight(50.0),
            .menuItemWidth(self.view.frame.width/3.5),
            .enableHorizontalBounce(true),
            .centerMenuItems(true),
            .unselectedMenuItemLabelColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor(red: 13/255.0, green: 205/255.0, blue: 120/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: style, size: 16)!)
        ]
 
         
         
        if language == "ar"{
            
            controllerArray.append(thirdVC)
            controllerArray.append(secondVC)
            controllerArray.append(firstVC)
            
            
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0, y: self.detailsImg.frame.maxY, width: self.view.frame.width, height:self.view.frame.height-(self.detailsImg.frame.maxY+self.backView.frame.height)), pageMenuOptions: parameters)
           
            pageMenu?.language = "ar"
          self.pageMenu?.moveToPage(2)
          self.pageMenu?.moveSelectionIndicator(2)
            
         }
        else{
            controllerArray.append(firstVC)
            controllerArray.append(secondVC)
            controllerArray.append(thirdVC)
           
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0, y: self.detailsImg.frame.maxY, width: self.view.frame.width, height:self.view.frame.height-(self.detailsImg.frame.maxY+self.backView.frame.height)), pageMenuOptions: parameters)
       
        }
        
        
        self.addChild(pageMenu!)
        self.view.addSubview(pageMenu!.view)
      
        
    }
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
       
        
        if navigation1 == "filter"
        {
            navigation1 = ""
            let vc = storyboard?.instantiateViewController(withIdentifier:"CategoriesListVC") as! CategoriesListVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if navigation1 == "search"
        {
            navigation1 = ""
            let vc = storyboard?.instantiateViewController(withIdentifier:"SearchViewController") as! SearchViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if navigation1 == "discover"
        {
            navigation1 = ""
            let vc = storyboard?.instantiateViewController(withIdentifier:"DiscoverVC") as! DiscoverVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
        else if navigation1 == "catageory"
        {
            navigation1 = ""
            let vc = storyboard?.instantiateViewController(withIdentifier:"CategoriesListVC") as! CategoriesListVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if navigation1 == "mycourses"
        {
            navigation1 = ""
            let vc = storyboard?.instantiateViewController(withIdentifier:"MyCoursesVC") as! MyCoursesVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else if navigation1 == "home"
        {
            self.navigationItem.hidesBackButton = true
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = stb.instantiateViewController(withIdentifier: "tabbar") as! TabBarControllerVC
            let nav = tabBar.viewControllers?[1] as! UINavigationController
            let studioVC = stb.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
            
            tabBar.selectedIndex = 1
            self.present(tabBar, animated: true) {
                nav.pushViewController(studioVC, animated: false)
            }
            
        }
            
        else {
        
           self.navigationController?.popViewController(animated: false)
        }
        
        
    }
    
    
    @IBAction func shareBarBtnTap(_ sender: Any)
    {
        let shareVC = UIActivityViewController(activityItems: ["Google.com"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    
    @IBAction func buyNowBtnTap(_ sender: Any) {
        
        
        let gotoNotification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrencySwitchVC") as! CurrencySwitchVC
      
        gotoNotification.modalPresentationStyle = .overCurrentContext
        
        
        let navi = UINavigationController(rootViewController: gotoNotification)
        navi.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        navi.modalPresentationStyle = .overCurrentContext
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: false, completion: nil)
   
   
    
    }
    
    @IBAction func addToWishListBtn(_ sender: Any)
    {
        wishList()
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
            
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["lang" :language,
                                                       "api_key":APIKEY,"user_id":myuserID,"course_id":detailsCourseId]
            
            print(parameters)
            
            Alamofire.request(wishListService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        
                        self.showToastForAlert(message: message,style: style1)
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
    
    

func courseDetails()
{
    if Reachability.isConnectedToNetwork()
    {
      MobileFixServices.sharedInstance.loader(view: self.view)
    
      let lessonData = "\(base_path)services/course_details?"
    
      //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
      let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
    
      let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang": language,"course_id":detailsCourseId,"user_id":myuserID]
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
                  if let detailsData = response1["details"] as? [String:Any]
                  {
    
                 
                  if let price = detailsData["price"] as? String
                   {
                        self.coursePrice = price
                    }
                  if let offer_price = detailsData["offer_price"] as? String
                  {
                   self.courseOfferPrice = offer_price
                 }
                 if let purchase_status = detailsData["purchase_status"] as? String
                 {
                       self.coursePurchaseStatus = purchase_status
                 }
                if let wishlist = detailsData["wishlist"] as? String
                {
                      self.wishlistStatus = wishlist
                 }
                    if let course_title = detailsData["course_title"] as? String
                    {
                        self.courseTitle = course_title
                    }
                    if let currency = detailsData["currency"] as? String
                    {
                        self.currencyType = currency
                    }
                    
                    if let type = detailsData["cover_type"] as? String
                    {
                        self.catageoryType = type
                        
                    }
                    if let imgCover = detailsData["cover"] as? String
                    {
                        self.videoToPlay = base_path+imgCover
                        
                    }
                    if let thumbnail = detailsData["thumbnail"] as? String
                    {
                        self.thumbnail = base_path+thumbnail
                    }
                    if let priceUsd = detailsData["price_usd"] as? String
                    {
                        self.priceUsd = priceUsd
                    }
                    
                    
//                    vc.videoToPlay = recCourseImagesArray[indexPath.row] as? String ?? ""
//                    vc.catageoryType = recCourseCoverTypeArray[indexPath.row] as? String ?? ""
//                    vc.detailsCourseId = recCourse_idArray[indexPath.row] as? String ?? ""
//                    vc.thumbnail = thumbnailRecCourse[indexPath.row] as? String ?? ""
                    
                    
            DispatchQueue.main.async {
    
            MobileFixServices.sharedInstance.dissMissLoader()
                
                if self.catageoryType == "image"
                {
                    self.detailsImg.sd_setImage(with: URL (string:self.videoToPlay))
                    
                }
                else
                {
                    self.detailsImg.sd_setImage(with: URL (string:self.thumbnail))
                    
                    self.videoBtnToPlay.setImage(UIImage(named: "newplayicon"), for: UIControl.State.normal)
                }
       
        
        
        if self.courseOfferPrice != ""
        {
            self.coursePriceLbl.text = "\(self.courseOfferPrice) \(self.currencyType)"
            let cost = "\(self.coursePrice) \(self.currencyType)"
            self.offerPriceLbl.attributedText = cost.strikeThrough()
        }
        else
        {
            self.coursePriceLbl.text = "\(self.coursePrice) \(self.currencyType)"
        }
        
        
          if self.coursePurchaseStatus == "1"
          {
                self.buyNowBtn.isHidden = true
                self.buyNowHeight.constant = 0
                self.addToWishListBtn.isHidden = true
                 self.wishListHt.constant = 0
            
                self.view.layoutIfNeeded()
                 //self.setupPages()
            
            
          }
           else if self.coursePurchaseStatus == "0"
          {
            self.buyNowBtn.isHidden = false
            self.addToWishListBtn.isHidden = false
          }
         if self.wishlistStatus == "1"
         {
            //self.addToWishListBtn.setTitle("REMOVE FROM WISHLIST", for: UIControl.State.normal)
            self.addToWishListBtn.setTitle(languageChangeString(a_str: "Remove WishList"), for: UIControl.State.normal)
         }
         else if self.wishlistStatus == "0"
         {
            //self.addToWishListBtn.setTitle("ADD TO WISHLIST", for: UIControl.State.normal)
            self.addToWishListBtn.setTitle(languageChangeString(a_str: "Add To WishList"), for: UIControl.State.normal)
          }

               
                
          self.setupPages()
        
         self.view.layoutIfNeeded()
        
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
       showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
      }
    }
    
    
    
}
