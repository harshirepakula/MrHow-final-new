//
//  DetailsViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 7/2/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVKit
import AVFoundation

class DetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,NSLayoutManagerDelegate {

    @IBOutlet weak var detailsBackView: UIView!
    @IBOutlet var studioTV: UITableView!
    
    @IBOutlet weak var postCommentSt: UIButton!
    @IBOutlet weak var addCommentsSt: UILabel!
    @IBOutlet weak var studioDetailsTV: UITableView!
    @IBOutlet weak var commentsSt: UILabel!
    
    @IBOutlet weak var redirectBtn: UIButton!
    @IBOutlet var txt_userName: UITextField!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsTVHeight: NSLayoutConstraint!
    
    
    
    var articleId : String = ""
    var comment_ID : String = ""
    var thumbnailImage : String = ""
   
    var arrSectionData: NSArray = []
    
    var nonExisttingProducts:[nonExisttingProductData] = []
    
    var article_idData = ""
    var article_titleData = ""
    var article_descriptionData = ""
    var article_imageData = ""
    var image_typeData = ""
    var writerData = ""
    var created_onData = ""
    var likes_countData = ""
    var comments_countData = ""
    var views_countData = ""
    var articleTimeData = ""
    var redirectLink = ""
    
    var detailsIdArray = [String]()
    var detail_imageArray = [String]()
    var detail_thumbArray = [String]()
    var detail_image_typeArray = [String]()
    var detail_descriptionArray = [String]()
   
    var fontStyle = ""
    var style = ""
    

     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt_userName.setBottomLineBorder()
        
        self.navigationController?.navigationBar.barTintColor = UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        
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
        
        
        
        if let aSize = UIFont(name: fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
             self.navigationItem.title = languageChangeString(a_str: "Details")
            print("font changed")
            
        }
      

       
        self.commentsSt.text = languageChangeString(a_str: "Comments")
        
        self.addCommentsSt.text = languageChangeString(a_str: "Add comments")
       
        self.postCommentSt.setTitle(languageChangeString(a_str: "Post Comment"), for: UIControl.State.normal)
        
        
        if language == "ar"
        {
            self.txt_userName.textAlignment = .right
            self.txt_userName.setPadding(left: -10, right: -10)
           
            GeneralFunctions.labelCustom_RTReg(labelName: commentsSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: addCommentsSt, fontSize: 13)
            GeneralFunctions.buttonCustom_RTReg(buttonName: postCommentSt, fontSize: 16)
            self.txt_userName.font = UIFont(name: "29LTBukra-Regular", size: 12)
            
            
        }
        else if language == "en"{
            self.txt_userName.textAlignment = .left
            self.txt_userName.setPadding(left: 10, right: 10)
            self.txt_userName.font = UIFont(name: "Poppins-Regular", size: 12)
            GeneralFunctions.labelCustom_LTReg(labelName: commentsSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTReg(labelName: addCommentsSt, fontSize: 13)
            GeneralFunctions.buttonCustom_LTBold(buttonName: postCommentSt, fontSize: 16)
           
        }
        

        }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        let bool = Reachability.isConnectedToNetwork()
        
        if (bool == false) {
            
            print("NO InterNet")
            
            DispatchQueue.main.async(execute: {
                
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: self.style)
                
            })
            
        }else{
            // non Exstting Products list service call
            
            NotificationCenter.default.addObserver(self, selector: #selector(nonExsittingProducts(_:)), name: NSNotification.Name(rawValue: "non_exsiting_product"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(likeBtn(_:)), name: NSNotification.Name(rawValue: "like"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(mainComment(_:)), name: NSNotification.Name(rawValue: "comment"), object: nil)
          
            self.studioDetails()
            
            
            self.studioTV.estimatedSectionHeaderHeight = 100
            self.studioTV.sectionHeaderHeight = UITableView.automaticDimension
        

            self.studioTV.estimatedRowHeight = 30
            self.studioTV.rowHeight = UITableView.automaticDimension
            
            self.studioDetailsTV.estimatedRowHeight = 200
            self.studioDetailsTV.rowHeight = UITableView.automaticDimension
            
            
           
            
        }
    }
    
    //MARK:- Notification Center Method
    @objc func nonExsittingProducts(_ notification: Notification)
    {
       
        self.studioDetails()
    }
    
    @objc func likeBtn(_ notification: Notification)
    {
        
        self.studioDetails()
        
    }
    
    @objc func mainComment(_ notification: Notification)
    {
      
        self.studioDetails()
        
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
    
    
    @IBAction func postCommentBtnTap(_ sender: UIButton)
    {
        postMainComment()
        txt_userName.text = ""
        txt_userName.resignFirstResponder()
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
        if image_typeData == "video"
        {
            guard let url = URL(string: article_imageData) else {
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == studioTV
        {
        return arrSectionData.count
        }
        else
        {
            return 1
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == studioTV
        {
        let tempDic: NSDictionary = arrSectionData.object(at: section) as! NSDictionary
        let TempDataArr: NSArray  = tempDic.object(forKey: "sub_comments") as! NSArray
            print(TempDataArr.count)
        return TempDataArr.count
        }
        else{
            print(detailsIdArray.count)
             return detailsIdArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == studioTV
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCommentCell", for: indexPath) as! StudioDetailsTableViewCell
        
//        let tempDic: NSDictionary = arrSectionData.object(at: indexPath.section) as! NSDictionary
//        let TempDataArr: NSArray  = tempDic.object(forKey: "sub_comments") as! NSArray
       
            if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell.subCommentLbl, fontSize: 12)
            }
            else if language == "en"
            {
                GeneralFunctions.labelCustom_LTReg(labelName: cell.subCommentLbl, fontSize: 12)
            }
      
        cell.subCommentLbl.text = (((arrSectionData[indexPath.section] as! NSDictionary)["sub_comments"] as! NSArray)[indexPath.row] as! NSDictionary)["sub_comment"] as? String
          
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudioDetailsTVCell", for: indexPath) as! StudioDetailsTVCell
            
            if detail_image_typeArray[indexPath.row]  == "image"
            {
                cell.detailsBannerImg.sd_setImage(with: URL (string:detail_imageArray[indexPath.row]))
               
                 cell.detailsvideoBtn.image = UIImage(named: "")
                
            }
            else
            {
                cell.detailsBannerImg.sd_setImage(with: URL (string:detail_thumbArray[indexPath.row]))
                 cell.detailsvideoBtn.image = UIImage(named: "newplayicon")
                
                
            }
           
             var fontStyle = ""
            
            if language == "en"
            {
                fontStyle = "Poppins-Regular"
            }else
            {
                fontStyle = "29LTBukra-Regular"
            }
            
            
            cell.detailDescrip.delegate = self
              cell.detailDescrip.layoutManager.delegate = self
           cell.detailDescrip.isUserInteractionEnabled = true
           cell.detailDescrip.isEditable = false
            cell.detailDescrip.isSelectable = true
            cell.detailDescrip.dataDetectorTypes = [.link]
            cell.detailDescrip.isScrollEnabled = false
           cell.detailBackView.dropShadow(color: .lightGray, offSet: CGSize(width: 0, height: 1), radius: 8, scale: true)
            
    
            cell.detailDescrip.attributedText = detail_descriptionArray[indexPath.row].htmlToAttributedString
            cell.detailDescrip.font = UIFont(name: fontStyle, size: 14)
            self.view.layoutIfNeeded()
            
            return cell
        }
    
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 20
    }

    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Link Selected!")
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var cell1 = UITableViewCell()
        if tableView ==  studioTV
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudioDetailsTableViewCell") as! StudioDetailsTableViewCell
            cell1 = cell
       
        if section == 0
        {
            cell.outerLine.isHidden = true
        }
        else
        {
            cell.outerLine.isHidden = false
        }
        
            if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell.userName, fontSize: 16)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.noOfLikes, fontSize: 12)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.messageDes, fontSize: 12)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.timeLbl, fontSize: 13)
                GeneralFunctions.buttonCustom_RTReg(buttonName: cell.replyBtn, fontSize: 15)
                
            }
            else if language == "en"
            {
                GeneralFunctions.labelCustom_LTReg(labelName: cell.userName, fontSize: 16)
                GeneralFunctions.labelCustom_LTReg(labelName: cell.noOfLikes, fontSize: 12)
                GeneralFunctions.labelCustom_LTReg(labelName: cell.messageDes, fontSize: 12)
                GeneralFunctions.labelCustom_LTReg(labelName: cell.timeLbl, fontSize: 13)
                GeneralFunctions.buttonCustom_LTReg(buttonName: cell.replyBtn, fontSize: 15)
            }
            
        let img = base_path+nonExisttingProducts[section].postUserImage
        cell.userImage.sd_setImage(with: URL (string:img))
        cell.userName.text = nonExisttingProducts[section].postUserName
        cell.noOfLikes.text = nonExisttingProducts[section].postLikes
        cell.messageDes.text = nonExisttingProducts[section].postUserDescription
        cell.noOfSubComments.text = nonExisttingProducts[section].postSubCommentsCount
        cell.timeLbl.text = nonExisttingProducts[section].postTime
        cell.replyBtn.addTarget(self, action: #selector(viewReply(sender:)), for: .touchUpInside)
        cell.replyBtn.setTitle(languageChangeString(a_str: "Reply"), for: .normal)
        cell.replyBtn.tag = section
        cell.likesBtn.addTarget(self, action: #selector(likeBtnTap),for: .touchUpInside)
        cell.likesBtn.tag = section
        
        return cell
        }
        return cell1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if tableView == studioDetailsTV
        {
            if detail_image_typeArray[indexPath.row]  == "video"
            {
                guard let url = URL(string: detail_imageArray[indexPath.row]) else {
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return UITableView.automaticDimension
    }

    
    @objc func viewReply(sender:UIButton) {
      
        // print("replay btn tapped")
        let sectionId = sender.tag
        print("section tap is :\(sectionId)")
        //user_id,topic_id,comment,lang
        
        let product_ID = nonExisttingProducts[sender.tag].postUserId
        
        print(product_ID ?? 0)
        
        let gotoNotification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyVC") as! ReplyVC
        gotoNotification.topic_Id = product_ID
        gotoNotification.modalPresentationStyle = .overCurrentContext
        
        
        let navi = UINavigationController(rootViewController: gotoNotification)
        navi.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        navi.modalPresentationStyle = .overCurrentContext
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: false, completion: nil)
        
    }
    
    
    @objc func likeBtnTap(sender:UIButton) {
        
        // print("replay btn tapped")
        let sectionId = sender.tag
        print("section tap is :\(sectionId)")
        //user_id,topic_id,comment,lang
        
        comment_ID = nonExisttingProducts[sender.tag].postUserId
        print(comment_ID)
        self.commentLike(id: comment_ID)
    }
    
    
    
    @IBAction func redirectBtnTap(_ sender: Any) {
        
        let urlToGive = redirectLink
        
        guard let url = URL(string: urlToGive) else { return }
        UIApplication.shared.open(url)
        


        
    }
    
    // studio details data
    
    func studioDetails()
    {
        
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let studioDetails = "\(base_path)services/article_details?"
        
        //https://volive.in/mrhow_dev/services/article_details?api_key=1762019&lang=en&user_id=15&article_id=1
        
        
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        
        let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang": language,"user_id":myuserID,"article_id":articleId]
        
        Alamofire.request(studioDetails, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                
                print(responseData)
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    let response = responseData["data"] as! Dictionary<String,Any>
                    
                    if let article_image = response["article_image"] as? String
                    {
                        self.article_imageData = base_path+article_image
                        
                    }
                    if let date = response["date"] as? String
                    {
                        self.articleTimeData = date
                        
                    }
                    if let likes_count = response["likes_count"] as? String
                    {
                        self.likes_countData = likes_count
                        
                    }
                    if let comments_count = response["comments_count"] as? String
                    {
                        self.comments_countData = comments_count
                        
                    }
                    if let views_count = response["views_count"] as? String
                    {
                        self.views_countData = views_count
                        
                    }
                    
                    if let created_on = response["created_on"] as? String
                    {
                        self.created_onData = created_on
                        
                    }
                    if let writer = response["writer"] as? String
                    {
                        self.writerData = writer
                        
                    }
                    if let image_type = response["image_type"] as? String
                    {
                        self.image_typeData = image_type
                        
                    }
                    
                    if let article_description = response["article_description"] as? String
                    {
                        self.article_descriptionData = article_description
                        
                    }
                    if let article_title = response["article_title"] as? String
                    {
                        self.article_titleData = article_title
                        
                    }
                    if let article_id = response["article_id"] as? String
                    {
                        self.article_idData = article_id
                        
                    }
                    if let redirect_url = response["redirect_url"] as? String
                    {
                        self.redirectLink = redirect_url
                        
                    }
                    
                    
                    if let response1 = response["details"] as? [[String:Any]]
                    {
                        
                        
                        if(self.detailsIdArray.count > 0)||(self.detail_thumbArray.count > 0)||(self.detail_imageArray.count > 0)||(self.detail_image_typeArray.count > 0)||(self.detail_descriptionArray.count > 0)
                        {
                            self.detailsIdArray.removeAll()
                            self.detail_thumbArray.removeAll()
                            self.detail_imageArray.removeAll()
                            self.detail_image_typeArray.removeAll()
                            self.detail_descriptionArray.removeAll()
                           
                            
                        }
                        
                        for i in 0..<response1.count
                        {
                        if let details_id = response1[i]["details_id"] as? String
                        {
                            self.detailsIdArray.append(details_id)
                         }
                            if let detail_thumb = response1[i]["detail_thumb"] as? String
                            {
                                self.detail_thumbArray.append(base_path+detail_thumb)
                            }
                            if let detail_image = response1[i]["detail_image"] as? String
                            {
                                self.detail_imageArray.append(base_path+detail_image)
                            }
                            if let detail_image_type = response1[i]["detail_image_type"] as? String
                            {
                                self.detail_image_typeArray.append(detail_image_type)
                            }
                            if let detail_description = response1[i]["detail_description"] as? String
                            {
                                self.detail_descriptionArray.append(detail_description)
                            }
                            
                        }
                        
                        if response1.count == 0
                        {
                            self.detailsTVHeight.constant = 0

                        }
                        DispatchQueue.main.async {
                            self.studioDetailsTV.reloadData()
                            self.studioDetailsTV.delegate = self
                            self.studioDetailsTV.dataSource = self
                            
                            self.studioDetailsTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                           
                             //self.studioDetailsTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
                             self.view.layoutIfNeeded()
                            
                        }

                   }
                    
                    
                    
                    
                    let nonExsittingProductArry = response["comments"] as! [Dictionary<String,Any>]
                    
                    self.arrSectionData = nonExsittingProductArry as NSArray
                    
                    
                    if (nonExsittingProductArry.count)>0{
                        
                        self.nonExisttingProducts.removeAll()
                        
                        
                        for i in nonExsittingProductArry{
                            let newNonexisttingData = nonExisttingProductData(userName: (i["name"]as! String), date: (i["commented_on"]as! String), description: (i["main_comment"]as! String), userId: (i["article_comment_id"]as! String), likes: (i["article_comment_likes"]as! String), time: (i["time"]as! String), image: (i["profile_pic"]as! String), subCount: (i["article_sub_comment_count"]as! String))
                            
                            
                            self.nonExisttingProducts.append(newNonexisttingData)
                            
                        }
                        
                    }
                       
                    else{
                        DispatchQueue.main.async {
                            self.heightConstraint.constant = 0
                            
                        }
                        
                    }
                     print(self.nonExisttingProducts)
                    DispatchQueue.main.async {
                        self.studioTV.reloadData()
                        self.studioTV.delegate = self
                        self.studioTV.dataSource = self
        
                      
                        self.studioTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
     
                        self.view.layoutIfNeeded()
                        
                        
                        self.redirectBtn.setTitle(self.redirectLink, for: UIControl.State.normal)
                        
                        
                    }
                }
                else{
                    
                    DispatchQueue.main.async {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message:message,style: self.style)
                    }
                }
            }
            
        }
        
    }
    
 
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {


            studioDetailsTV.layer.removeAllAnimations()
            detailsTVHeight.constant = studioDetailsTV.contentSize.height
            studioTV.layer.removeAllAnimations()
            heightConstraint.constant = studioTV.contentSize.height
            UIView.animate(withDuration: 0.5) {
                self.updateViewConstraints()
                self.view.layoutIfNeeded()
            }
        }

    

    
    // service call for comment like
    
    func commentLike(id:String)
    {
        let bool = Reachability.isConnectedToNetwork()
        
        if (bool == false) {
            
            print("NO InterNet")
            
            DispatchQueue.main.async(execute: {
                
               self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: self.style)
                
            })
            
        }else{
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
              let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["api_key":APIKEY ,"lang":language,"user_id":myuserID,"article_comment_id":id]
            
            //    https://volive.in/mrhow_dev/services/article_comment_like
            //    Article Comment like (POST method)
            //
            //    api_key:1762019
            //    lang:en
            //    user_id:
            //    article_comment_id:
            
            
            let url = "\(base_path)services/article_comment_like"
            print(url)
            print(parameters)
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                guard let responseData = response.result.value as? Dictionary<String, Any>else{
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    self.showToastForAlert(message: languageChangeString(a_str:"server is busy,please try again") ?? "",style: self.style)
                    
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name("like"), object: nil)
                    
                    
                    
                }
                    
                else{
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        self.showToastForAlert(message: responseData["message"] as? String ?? "", style: self.style)
                        //self.showAlert(withTitle: "Alert!", withMessage: responseData["message"] as! String)
                    }
                }
            }
        }
        
    }
    
    
    
    // Main comment Post Method
    
    
    func postMainComment()
    {
        
        let bool = Reachability.isConnectedToNetwork()
        
        if (bool == false) {
            
            print("NO InterNet")
            
            DispatchQueue.main.async(execute: {
                
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: self.style)
                // self.showAlert(withTitle: "Alert!".localizedString, withMessage: "Please Check Internet Connection".localizedString)
                
            })
            
        }else{
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
              let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["api_key":APIKEY ,"lang":language,"user_id":myuserID,"article_id":articleId,"main_comment":txt_userName.text ?? ""]
            
            
            
            
            let url = "\(base_path)services/article_comment"
            print(url)
            print(parameters)
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                guard let responseData = response.result.value as? Dictionary<String, Any>else{
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                  
                    self.showToastForAlert(message: languageChangeString(a_str:"server is busy,please try again") ?? "", style: self.style)
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name("comment"), object: nil)
                    
                    
                    
                }
                    
                else{
                    DispatchQueue.main.async {
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        self.showToastForAlert(message: responseData["message"] as? String ?? "", style: self.style)
                        //self.showAlert(withTitle: "Alert!", withMessage: responseData["message"] as! String)
                    }
                }
            }
        }
        
        
        
    }
    
}


struct nonExisttingProductData {
    
    var postUserName:String!
    var postDate:String!
    var postUserDescription:String!
    var postUserId:String!
    var postLikes:String!
    var postTime:String!
    var postUserImage:String!
    var postSubCommentsCount:String!
    init(userName:String,date:String,description:String,userId:String,likes:String,time:String,image:String,subCount:String) {
        
        
        self.postUserName = userName
        self.postDate = date
        self.postUserDescription = description
        self.postUserId = userId
        self.postLikes = likes
        self.postTime = time
        self.postUserImage = image
        self.postSubCommentsCount = subCount
        
        
        
    }
    
}


extension UIView
{
    
    func dropShadow(color: UIColor, opacity: Float = 0.7, offSet: CGSize, radius: CGFloat = 12, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
       
        
    }
}


