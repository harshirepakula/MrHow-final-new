//
//  TrainerReviewVC.swift
//  MrHow
//
//  Created by volivesolution on 04/07/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class TrainerReviewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var courseId = ""
    
    var trainerReviewId = ""
    
    var navigationChecking = ""
    
    //course details comments
    var courseCommentId = [String]()
    var courseComment = [String]()
    var courseComment_rating = [String]()
    var courseCreated_on = [String]()
    var courseCommentUserId = [String]()
    
    var arrSectionData: NSArray = []
    
    var CommentsArray:[moreCommentsData] = []

    //DIFFERENT IMAGES FOR RATING
    let fullStarImage:  UIImage = UIImage(named: "rating_1")!
    let emptyStarImage: UIImage = UIImage(named: "rating_2")!
    
    @IBOutlet weak var trainerReviewTV: UITableView!
    
    var fontStyle = ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trainerReviewTV.sectionHeaderHeight = UITableView.automaticDimension
        self.trainerReviewTV.estimatedSectionHeaderHeight = 60
        
        self.trainerReviewTV.estimatedRowHeight = 30
        self.trainerReviewTV.rowHeight = UITableView.automaticDimension
        
      
        trainerReviewTV.delegate = self
        trainerReviewTV.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          NotificationCenter.default.addObserver(self, selector: #selector(nonExsittingProducts(_:)), name: NSNotification.Name(rawValue: "subcomment"), object: nil)
        
        moreVCData()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            

                navigationItem.title = languageChangeString(a_str:"Course Comments")
                

            
        }
       
    }
    
    
    @objc func nonExsittingProducts(_ notification: Notification)
    {
        
        self.moreVCData()
    }
    
    
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    // star rating
    func getStarImage(starNumber: Int, forRating rating: Int) -> UIImage {
        if rating >= starNumber {
            return fullStarImage
        }  else {
            return emptyStarImage
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
            return arrSectionData.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let tempDic: NSDictionary = arrSectionData.object(at: section) as! NSDictionary
        let TempDataArr: NSArray  = tempDic.object(forKey: "sub_comments") as! NSArray
        print(TempDataArr.count)
        return TempDataArr.count
        

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "replies", for: indexPath) as! NotificationsTableViewCell
        
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

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "reviews") as! NotificationsTableViewCell
        
            

        
                if language == "ar"
                {
                    GeneralFunctions.labelCustom_RTReg(labelName: cell.messageLbl, fontSize: 14)
                    GeneralFunctions.labelCustom_RTReg(labelName: cell.createdOnLbl, fontSize: 14)
                }
        
                else if language == "en"
                {
                    GeneralFunctions.labelCustom_LTReg(labelName: cell.messageLbl, fontSize: 14)
                    GeneralFunctions.labelCustom_LTReg(labelName: cell.createdOnLbl, fontSize: 14)
                }
        
            
           cell.messageLbl.text = CommentsArray[section].comment
           cell.createdOnLbl.text = CommentsArray[section].postTime
        
        let rateValue = CommentsArray[section].comment_rating ?? ""
        let moreRate = Int(rateValue)
                    if let ourRating = moreRate {
                        if ourRating > 0
                        {
                            cell.ratingView.isHidden = false
                        cell.star1.image = getStarImage(starNumber: 1, forRating: ourRating)
                        cell.star2.image = getStarImage(starNumber: 2, forRating: ourRating)
                        cell.star3.image = getStarImage(starNumber: 3, forRating: ourRating)
                        cell.star4.image = getStarImage(starNumber: 4, forRating: ourRating)
                        cell.star5.image = getStarImage(starNumber: 5, forRating: ourRating)
                        }
                        else
                        {
                            cell.ratingViewHt.constant = 0
                            cell.ratingView.isHidden = true
                        }
        }
            cell.replyBtn.addTarget(self, action: #selector(viewReply(sender:)), for: .touchUpInside)
            cell.replyBtn.setTitle(languageChangeString(a_str: "Reply"), for: .normal)
            cell.replyBtn.tag = section
        
        return cell
       
    }
    
    
    @objc func viewReply(sender:UIButton) {
        
        // print("replay btn tapped")
        let sectionId = sender.tag
        print("section tap is :\(sectionId)")
        //user_id,topic_id,comment,lang
        
        let product_ID = CommentsArray[sender.tag].comment_id
       
        
        print(product_ID ?? 0)
        
        let gotoNotification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        gotoNotification.topic_Id = product_ID ?? ""
        gotoNotification.courseID = courseId
        
        gotoNotification.modalPresentationStyle = .overCurrentContext
        
        
        let navi = UINavigationController(rootViewController: gotoNotification)
        navi.navigationBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        navi.modalPresentationStyle = .overCurrentContext
        navi.navigationBar.isTranslucent = false
        self.present(navi, animated: false, completion: nil)
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let line = UILabel()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.lightGray
        let header: UIView = {
            let hd = UIView()
            hd.addSubview(line)
            line.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 0).isActive = true
            line.topAnchor.constraint(equalTo: hd.topAnchor, constant: 8).isActive = true
            line.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: 0).isActive = true
            
            line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            return hd
        }()
        
        return header
        
        
    }
    
    
    
    // moredata service call
    
    func moreVCData()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let aboutData = "\(base_path)services/course_details?"
            
            //https://volive.in/mrhow_dev/services/course_details?api_key=1762019&lang=en&course_id=1&user_id=8
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang": language,"course_id":courseId,"user_id":myuserID]
            
            Alamofire.request(aboutData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response = responseData["data"] as? Dictionary<String, Any>
                        {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            let nonExsittingProductArry = response["comments"] as! [Dictionary<String,Any>]
                            
                            self.arrSectionData = nonExsittingProductArry as NSArray
                            
                            
                            if (nonExsittingProductArry.count)>0{
                                
                                self.CommentsArray.removeAll()
                                
                                
                                for i in nonExsittingProductArry{
                                    let newNonexisttingData = moreCommentsData(comment_id: (i["comment_id"] as! String), comment: (i["comment"] as! String), comment_rating: (i["comment_rating"]as! String), postUserId: (i["user_id"] as! String), postTime: (i["time"] as! String))
                                        
                                        
                                    
                                    self.CommentsArray.append(newNonexisttingData)
                                    
                                }
                                
                            }
                            
                            
                            }
                        
                            DispatchQueue.main.async {
                                self.trainerReviewTV.reloadData()
                               
                                self.view.layoutIfNeeded()
                                
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
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
        }
    }
    

    
}


struct moreCommentsData {
    
    var comment_id:String!
    var comment:String!
    var comment_rating:String!
    var postUserId:String!
    var postTime:String!
  
    init(comment_id:String,comment:String,comment_rating:String,postUserId:String,postTime:String) {
        
        
        self.comment_id = comment_id
        self.comment = comment
        self.comment_rating = comment_rating
        self.postUserId = postUserId
        self.postTime = postTime
    }
    
}
