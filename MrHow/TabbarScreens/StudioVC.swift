//
//  StudioVC.swift
//  MrHow
//
//  Created by volivesolutions on 21/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class StudioVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
,UICollectionViewDelegateFlowLayout {
    
  @IBOutlet weak var collectionView_cat1: UICollectionView!
  @IBOutlet weak var hashTagCollection: UICollectionView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var bannerImage: UIImageView!
    
    var imageBanner = ""
    var viewBackColor = ""
    var type = ""
    
    var article_idArray = [String]()
    var article_titleArray = [String]()
    var article_descriptionArray = [String]()
    var article_imageArray = [String]()
    var image_typeArray = [String]()
    var writerArray = [String]()
    var created_onArray = [String]()
    var likes_countArray = [String]()
    var comments_countArray = [String]()
    var views_countArray = [String]()
    var thumbnailArray = [String]()
    var studioHashTagArray = [String]()

    var hashTagIdArray = [String]()
    var hashTagNameArray = [String]()
    var selectedHashTagId = ""
    var fontStyle = ""
    var style = ""
  
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"

    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        
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
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
       self.navigationItem.title = languageChangeString(a_str: "Studio")
            print("font changed")
            
        }
        
       tabBarController?.tabBar.items?[0].title = languageChangeString(a_str: "Studio")
        tabBarController?.tabBar.items?[1].title = languageChangeString(a_str: "Discover")
         tabBarController?.tabBar.items?[2].title = languageChangeString(a_str: "My Courses")
         tabBarController?.tabBar.items?[3].title = languageChangeString(a_str: "Profile")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
   NotificationCenter.default.addObserver(self, selector: #selector(likeBtn(_:)), name: NSNotification.Name(rawValue: "articleLike"), object: nil)
        
        selectedHashTagId = ""
        hashTagServiceCall()
        studioData(hashtagId: selectedHashTagId)
       
        if language == "en"
        {
            
            hashTagCollection.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        }
        if language == "ar"
        {
            hashTagCollection.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            hashTagCollection.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        }
        
          //collectionView_cat1.reloadData()
    
         //self.tabBarController?.tabBar.isHidden = false
    }
    
   
    
    @objc func likeBtn(_ notification: Notification)
    {
      
        self.studioData(hashtagId: selectedHashTagId)
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
       // self.tabBarController?.tabBar.isHidden = true
    }
    

    
    
    
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView_cat1
        {
       print(article_titleArray.count)
          return image_typeArray.count
        }else
        {
            return hashTagIdArray.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
       if collectionView == collectionView_cat1
       {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat1", for: indexPath) as! CustomCollectionViewCell
        if image_typeArray[indexPath.row] == "image"
        {
            cell.imageview_banner.sd_setImage(with: URL (string:article_imageArray[indexPath.row]))
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:thumbnailArray[indexPath.row]))
            
         
        }
        
            cell.view_back.layer.cornerRadius = 8
            cell.view_back.layer.masksToBounds = true
            cell.view_back.layer.borderWidth = 0.3
            cell.view_back.layer.borderColor = UIColor.gray.cgColor
            cell.view_back.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            cell.view_back.layer.shadowRadius = 6.0
            cell.view_back.layer.shadowOpacity = 0.7
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: cell.articleComments, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.articleLikes, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.articleViews, fontSize: 10)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.articleWriter, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.articleTitle, fontSize: 13)
            
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.articleComments, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.articleLikes, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.articleViews, fontSize: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.articleWriter, fontSize: 13)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.articleTitle, fontSize: 13)
        }
        
        
        //cell.view_back.dropShadow(color: .lightGray, offSet: CGSize(width: -1, height: 1), radius: 4, scale: true)
        
            cell.articleComments.text  = comments_countArray[indexPath.row]
            cell.articleLikes.text  = likes_countArray[indexPath.row]
            cell.articleViews.text  = views_countArray[indexPath.row]
            cell.articleLike.tag = indexPath.row
            cell.articleLike.addTarget(self, action: #selector(articleLikeBtnTap(sender:)), for: UIControl.Event.touchUpInside)
            cell.articleWriter.text  = writerArray[indexPath.row]
            cell.articleTitle.text  = article_titleArray[indexPath.row]
        return cell
        }
        else
        {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
            if language == "ar"
            {
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.hashTagLbl, fontSize: 15)
            }
            else if language == "en"
            {
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.hashTagLbl, fontSize: 15)
            }
            
            if (indexPath.row == 0){
                hashTagCollection.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
                cell.backView.backgroundColor = ThemeColor
                cell.hashTagLbl.textColor=UIColor.white
            }else{

                cell.backView.backgroundColor = UIColor.white
                 cell.hashTagLbl.textColor = UIColor.black
            }
            
         cell.hashTagLbl.text = hashTagNameArray[indexPath.row]
            return cell
        }
       
        
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Did Selected")
        if collectionView == collectionView_cat1
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            vc.articleId = article_idArray[indexPath.row]
            vc.thumbnailImage = thumbnailArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == hashTagCollection
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell

            cell.isSelected = true

            //let indexpath = collectionView.cellForItem(at: indexPath)
            cell.backView.backgroundColor = ThemeColor
            cell.hashTagLbl.textColor = UIColor.white
            selectedHashTagId = hashTagIdArray[indexPath.row]
            studioData(hashtagId: selectedHashTagId)
        }
        
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if collectionView == hashTagCollection
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
            
            cell.hashTagLbl.textColor = UIColor.black
            cell.backView.backgroundColor = UIColor.white
            
        }
        
        
    }
    
    
    
    
//
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
//    {
//        if collectionView == hashTagCollection
//        {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCollectionViewCell", for: indexPath) as! HashTagCollectionViewCell
//
//
//           cell.hashTagLbl.textColor = UIColor.black
//           cell.backView.backgroundColor = UIColor.white
//
//        }
//
//
//    }
    
   

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        if collectionView == collectionView_cat1
        {

            //let height = view.frame.size.height

            

            let width = collectionView.frame.size.width
              print(width * 0.48)
            // in case you you want the cell to be 40% of your controllers view
            return CGSize(width: width * 0.48, height:200)
            
//        let yourWidth = collectionView_cat1.bounds.width/2
//        return CGSize(width: yourWidth, height: 220)
        }
         else
        {

            let label = UILabel(frame: CGRect.zero)
            label.text = ("  " + hashTagNameArray[indexPath.row] + "  ")
            label.sizeToFit()
           let width = label.frame.width
            if width > 40
            {
                 return CGSize(width: label.frame.width , height: 40)
            }
            else{
                return CGSize(width: 40 , height: 40)
            }
            //return CGSize(width: 80, height: 40)
        }
    }
    
//    func preferredLayoutAttributes(_ layoutAttributes:UICollectionViewLayoutAttributes) ->UICollectionViewLayoutAttributes
//    {
//        let size = contentview.systemLayoutSizeFitting
//       return layoutAttributes
//        
//    }

    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
    }
    
    
    @objc func articleLikeBtnTap(sender:UIButton)
    {
        let id = article_idArray[sender.tag]
        articleLike(articleId:id)
    }
    
    
    
    
    
    //service call for studioDetails
    
    func studioData(hashtagId:String)
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let studioData = "\(base_path)services/articles_list?"
            
          //https://www.volive.in/mrhow_dev/services/articles_list?api_key=1762019&lang=en&user_id=12&hashtag=2
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang": language,"user_id":myuserID,"hashtag":hashtagId]
            print(parameters)
            
            Alamofire.request(studioData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                     MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if let response1 = responseData["articles"] as? [[String:Any]]
                        {
                            
                          if(self.article_idArray.count > 0)||(self.article_idArray.count > 0)||(self.article_descriptionArray.count > 0)||(self.article_imageArray.count > 0)||(self.image_typeArray.count > 0)||(self.writerArray.count > 0)||(self.created_onArray.count > 0)||(self.likes_countArray.count > 0)||(self.comments_countArray.count > 0)||(self.views_countArray.count > 0)||(self.article_titleArray.count > 0)
                            {
                                self.article_idArray.removeAll()
                                self.article_idArray.removeAll()
                                self.article_descriptionArray.removeAll()
                                self.article_imageArray.removeAll()
                                self.image_typeArray.removeAll()
                                self.writerArray.removeAll()
                                self.created_onArray.removeAll()
                                self.likes_countArray.removeAll()
                                self.comments_countArray.removeAll()
                                self.views_countArray.removeAll()
                                self.article_titleArray.removeAll()
                                
                            }
                       
                        for i in 0..<response1.count
                        {
                            if let  article_image = response1[i]["article_image"] as? String
                            {
                                self.article_imageArray.append(base_path+article_image)
                                    
                            }
                            if let article_id = response1[i]["article_id"] as? String
                                {
                                    self.article_idArray.append(article_id)
                                }
                                if let article_title = response1[i]["article_title"] as? String
                                {
                                    self.article_titleArray.append(article_title)
                                    
                                }
                                if let image_type = response1[i]["image_type"] as? String
                                {
                                    self.image_typeArray.append(image_type)
                                }
                                if let comments_count = response1[i]["comments_count"] as? String
                                {
                                    self.comments_countArray.append(comments_count)
                                    
                                }
                                if let views_count = response1[i]["views_count"] as? String
                                {
                                    self.views_countArray.append(views_count)
                                }
                                //
                                if let likes_count = response1[i]["likes_count"] as? String
                                {
                                    self.likes_countArray.append(likes_count)
                                    
                                }
                                if let writer = response1[i]["writer"] as? String
                                {
                                    self.writerArray.append(writer)
                                }
                                if let created_on = response1[i]["created_on"] as? String
                                {
                                    self.created_onArray.append(created_on)
                                    
                                }
                                if let article_description = response1[i]["article_description"] as? String
                                {
                                    self.article_descriptionArray.append(article_description)
                                }
                            
                           if let thumbnail = response1[i]["thumbnail"] as? String
                            {
                                self.thumbnailArray.append(base_path+thumbnail)
                            }
                            if let hashtag = response1[i]["hashtag"] as? String
                            {
                                self.studioHashTagArray.append(hashtag)
                            }
                            
                           
                                
                            }
                            DispatchQueue.main.async {
                            
                                self.collectionView_cat1.reloadData()
                               // print(self.image_typeArray)
                                self.collectionView_cat1.dataSource = self
                                self.collectionView_cat1.delegate = self
                                self.collectionView_cat1.backgroundColor = UIColor(hexString: self.viewBackColor)
                            }
                            
                        }
                        if let bannerData = responseData["banner"] as? [String:Any]
                        {
                            if let image = bannerData["image"] as? String
                            {
                                self.imageBanner = base_path+image
                                
                            }
                            if let type = bannerData["type"] as? String
                            {
                                self.type = type
                                
                            }
                            if let bg_color = bannerData["bg_color"] as? String
                            {
                                self.viewBackColor = bg_color
                                
                            }
                            
                            DispatchQueue.main.async {
                               // print(self.imageBanner)
                        MobileFixServices.sharedInstance.dissMissLoader()
                                if self.type == "image"
                                {
                                    self.bannerImage.sd_setImage(with: URL (string:self.imageBanner))
                                }
                                else
                               {
                                self.bannerImage.image = self.getThumbnailFrom(path: URL(string:(self.imageBanner))!)
                                }
                                
                                self.backView.backgroundColor = UIColor(hexString: self.viewBackColor)
                                
                                
                            }
                            
                            
                        }
                        
                    }
                     else if status == 0
                    {
                         MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message:message, style: self.style)
                        if(self.article_idArray.count > 0)||(self.article_idArray.count > 0)||(self.article_descriptionArray.count > 0)||(self.article_imageArray.count > 0)||(self.image_typeArray.count > 0)||(self.writerArray.count > 0)||(self.created_onArray.count > 0)||(self.likes_countArray.count > 0)||(self.comments_countArray.count > 0)||(self.views_countArray.count > 0)||(self.article_titleArray.count > 0)
                        {
                            self.article_idArray.removeAll()
                            self.article_idArray.removeAll()
                            self.article_descriptionArray.removeAll()
                            self.article_imageArray.removeAll()
                            self.image_typeArray.removeAll()
                            self.writerArray.removeAll()
                            self.created_onArray.removeAll()
                            self.likes_countArray.removeAll()
                            self.comments_countArray.removeAll()
                            self.views_countArray.removeAll()
                            self.article_titleArray.removeAll()
                            
                        }
                        
                        if let bannerData = responseData["banner"] as? [String:Any]
                        {
                            if let image = bannerData["image"] as? String
                            {
                                self.imageBanner = base_path+image
                                
                            }
                            if let type = bannerData["type"] as? String
                            {
                                self.type = type
                                
                            }
                            if let bg_color = bannerData["bg_color"] as? String
                            {
                                self.viewBackColor = bg_color
                                
                            }
                            
                            DispatchQueue.main.async {
                                // print(self.imageBanner)
                                MobileFixServices.sharedInstance.dissMissLoader()
                                if self.type == "image"
                                {
                                    self.bannerImage.sd_setImage(with: URL (string:self.imageBanner))
                                }
                                else
                                {
                                    self.bannerImage.image = self.getThumbnailFrom(path: URL(string:(self.imageBanner))!)
                                }
                                
                                self.backView.backgroundColor = UIColor(hexString: self.viewBackColor)
                                
                                self.collectionView_cat1.reloadData()
                            }
                            
                            
                        }
                        
                        
                    }
                        
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message:message, style: self.style)
                        
                    }
                    
                }
                
            }
            
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            //showToastForAlert(message:"Please ensure you have proper internet connection")
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style)
        }
    }
    
    
    // hashtagService call
    
    func hashTagServiceCall()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let studioData = "\(base_path)services/hashtags?"
            
            
            //https://www.volive.in/mrhow_dev/services/hashtags?api_key=1762019&lang=en
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang":language]
            
            Alamofire.request(studioData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    let status = responseData["status"] as! Int
                     MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [[String:Any]]
                        {

                            if(self.hashTagIdArray.count > 0)||(self.hashTagNameArray.count > 0)
                            {
                                self.hashTagIdArray.removeAll()
                                self.hashTagIdArray.removeAll()


                            }
                            
                            let item = languageChangeString(a_str: "All")
                            
                            self.hashTagNameArray.append(item ?? "")
                            self.hashTagIdArray.append("")
                            for i in 0..<response1.count
                            {
                                
                                if let hashtag_id = response1[i]["hashtag_id"] as? String
                                {
                                    self.hashTagIdArray.append(hashtag_id)
                                }
                                
                                if let name = response1[i]["name"] as? String
                                {
                                    self.hashTagNameArray.append(name)
                                }
                                
                                
                                
                            }
                            DispatchQueue.main.async {
                                 MobileFixServices.sharedInstance.dissMissLoader()
                                self.hashTagCollection.reloadData()
                                
//                                 self.selectedHashTagId = "0"
//
//                                let indexPath:IndexPath = IndexPath(row: 0, section: 0)
//                                self.hashTagCollection?.selectItem(at: indexPath, animated: false, scrollPosition:.left)
//                                self.collectionView_cat1.reloadData()
                               
                                
                                self.hashTagCollection.delegate = self
                                self.hashTagCollection.dataSource = self
                                
                                
                                //self.collectionView_cat1.backgroundColor = UIColor(hexString: self.viewBackColor)
                            }
                            
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                    }
                    
                }
                
            }
            
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style)
        }
    }
    
    
    // article like/ dislike service call
    
    func articleLike(articleId:String)
    {
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            let bool = Reachability.isConnectedToNetwork()
            
            if (bool == false) {
                
                print("NO InterNet")
                
                DispatchQueue.main.async(execute: {
                    
                    self.showToastForAlert(message: languageChangeString(a_str:"Please Check Internet Connection")!, style: self.style)
                    // self.showAlert(withTitle: "Alert!".localizedString, withMessage: "Please Check Internet Connection".localizedString)
                    
                })
                
            }else{
                
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
                
                let parameters: Dictionary<String, Any> = ["api_key":APIKEY ,"lang":language,"user_id":myuserID,"article_id":articleId]
                
                
                //        https://volive.in/mrhow_dev/services/article_like
                //        Like or unlike article (POST method)
                //
                //        Params:
                //        api_key:1762019
                //        lang:en
                //        user_id:
                //        article_id:
                
                let url = "\(base_path)services/article_like"
                print(url)
                print(parameters)
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    
                    guard let responseData = response.result.value as? Dictionary<String, Any>else{
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        self.showToastForAlert(message: languageChangeString(a_str:"server is busy,please try again")!, style: self.style)
                        
                        return
                    }
                    
                    
                    // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    print("Response Data is :\(responseData)")
                    
                    let status = responseData["status"] as? Int?
                    
                    if(status == 1)
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        
                        let strServerMessage =  responseData["message"] as! String
                        
                        self.showToastForAlert(message: strServerMessage, style: self.style)
                        NotificationCenter.default.post(name: NSNotification.Name("articleLike"), object: nil)
                        
                        }
                        
                    else{
                        DispatchQueue.main.async {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            self.showToastForAlert(message: responseData["message"] as? String ?? "", style: self.style)
                           
                        }
                    }
                }
            }
            
            
            
        }
        
        
}

