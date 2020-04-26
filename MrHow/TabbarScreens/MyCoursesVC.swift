//
//  MyCoursesVC.swift
//  MrHow
//
//  Created by volivesolutions on 17/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import BSImagePicker
import YPImagePicker
import MobileCoreServices
import AVFoundation
import AVKit


class MyCoursesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
     @IBOutlet var tableViewList: UITableView!
     @IBOutlet weak var btn_wishlistCourese    : UIButton!
     @IBOutlet weak var btn_myEnrolledCourses  : UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage  = UIImage()
    var pickerImage  = UIImage()
    var upload : Bool!
    var mediaTypeString : String! = ""
    var multiImagesArr  = [UIImage]()
    var myArray: [Any] = []
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
   
    //WISHlIST
    var course_idArray = [String]()
    var category_nameArray = [String]()
    var course_titleArray = [String]()
    var priceArray = [String]()
    var offer_priceArray = [String]()
    var coverArray = [String]()
    var cover_typeArray = [String]()
    var thumbnailArray = [String]()
    var total_ratingsArray = [String]()
    var purchasedArray = [String]()
    var tagsArray = [String]()
    var durationArray = [String]()
    var wishListCurrencyType = [String]()
    
    // ENROLLED
    var enrolledCourseidArray = [String]()
    var enrolledNameArray = [String]()
    var enrolledTitleArray = [String]()
    var enrolledPriceArray = [String]()
    var enrolledOffer_priceArray = [String]()
    var enrolledCoverArray = [String]()
    var enrolledCover_typeArray = [String]()
    var enrolledThumbnailArray = [String]()
    var enrolledTotal_ratingsArray = [String]()
    var enrolledPurchasedArray = [String]()
    var enrolledTagsArray = [String]()
    var enrolledDurationArray = [String]()
    var enrolledCompletionArray = [String]()
    var downloadableOrNot = [String]()
    var downloadedStatus = [String]()
    var enrolledCurrencyType = [String]()
    var enrolledAuthorName = [String]()
    var selectedIndexPath = IndexPath()
    
    var showData = "btn_wishlistCourese"
   
    var studentCourseId = ""
    var fontStyle = ""
     var myCourseImagesArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }
        else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "MyCourse")
            print("font changed")
            
        }
        
        
   
        tabBarController?.tabBar.items?[0].title = languageChangeString(a_str: "Studio")
        tabBarController?.tabBar.items?[1].title = languageChangeString(a_str: "Discover")
        tabBarController?.tabBar.items?[2].title = languageChangeString(a_str: "My Courses")
        tabBarController?.tabBar.items?[3].title = languageChangeString(a_str: "Profile")
        
        
        
        if language == "en"
        {
            GeneralFunctions.buttonCustom_LTMedium(buttonName: btn_wishlistCourese, fontSize: 14)
            GeneralFunctions.buttonCustom_LTMedium(buttonName: btn_myEnrolledCourses, fontSize: 14)
            
        }
        else if language == "ar"
        {
            GeneralFunctions.buttonCustom_RTBold(buttonName: btn_wishlistCourese, fontSize: 14)
            GeneralFunctions.buttonCustom_RTBold(buttonName: btn_myEnrolledCourses, fontSize: 14)
            
        }
        
        
        
        btn_wishlistCourese.setTitle(languageChangeString(a_str: "Wishlist courses"), for: UIControl.State.normal)
        btn_myEnrolledCourses.setTitle(languageChangeString(a_str: "My Enrolled Courses"), for: UIControl.State.normal)
        btn_wishlistCourese.setTitleColor(UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0), for: .normal)
        btn_myEnrolledCourses.setTitleColor(UIColor.white, for: .normal)
        
        tableViewList.separatorColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
      // self.tabBarController?.tabBar.isHidden = false
        
        if showData == "btn_wishlistCourese"
        {
           wishListCourses()
        }
        else if showData == "btn_myEnrolledCourses"
        {
            
            enrolledCourses()
        }
        

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // self.tabBarController?.tabBar.isHidden = true
    }
  
    
    @IBAction func courseBtnTap(_ sender: UIButton)
    {
       
        
        if sender ==  btn_wishlistCourese
        {
            showData = "btn_wishlistCourese"
            btn_wishlistCourese.setTitleColor(UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0), for: .normal)
            btn_myEnrolledCourses.setTitleColor(UIColor.white, for: .normal)
        
           wishListCourses()
           // tableViewList.reloadData()
            
      
        }
        else if sender == btn_myEnrolledCourses
        {
            showData = "btn_myEnrolledCourses"
            btn_myEnrolledCourses.setTitleColor(UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0), for: .normal)
            btn_wishlistCourese.setTitleColor(UIColor.white, for: .normal)
            
            enrolledCourses()

    
        }
    }
    
    //MARK:- Tableview Delegate
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0
        {
            return course_idArray.count
        }
        else
        {
            print(enrolledCourseidArray)
            return enrolledCourseidArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesList1", for: indexPath) as! CustomTableViewCell
            
            if cover_typeArray[indexPath.row]  == "image"
            {
                cell.imageview_banner.sd_setImage(with: URL (string:coverArray[indexPath.row]))
            }
            else
            {
                cell.imageview_banner.sd_setImage(with: URL (string:thumbnailArray[indexPath.row]))
            }
            
      
            if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell.durationLbl, fontSize: 8)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.likesLbl, fontSize: 8)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.purchaseLbl, fontSize: 8)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.courseNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.offerPriceLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTBold(labelName: cell.imageofferName, fontSize: 14)
               
                
            }
            else if language == "en"
            {
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.durationLbl, fontSize: 8)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.likesLbl, fontSize: 8)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.purchaseLbl, fontSize: 8)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.courseNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.offerPriceLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTBold(labelName: cell.imageofferName, fontSize: 14)
            }
            
            cell.durationLbl.text = durationArray[indexPath.row]
            cell.courseNameLbl.text = course_titleArray[indexPath.row]
            cell.offerPriceLbl.text = "\(priceArray[indexPath.row]) \(self.wishListCurrencyType[indexPath.row])"
            cell.purchaseLbl.text = purchasedArray[indexPath.row]
            cell.likesLbl.text = total_ratingsArray[indexPath.row]
            
            
            let tag = tagsArray[indexPath.row]
            let tag2 = Int(tag)
                

            
           
            if tag2 == 1
            {
                if language == "en"
                {
                    cell.tagLbl.image = UIImage.init(named: "hot1")
                }
                else
                {
                    cell.tagLbl.image = UIImage.init(named: "hotar")
                }
                cell.imageofferName.text = languageChangeString(a_str: "Hot")
            }
            if tag2 == 2
            {
                
                if language == "en"
                {
                    cell.tagLbl.image = UIImage.init(named: "now")
                }
                else
                {
                     cell.tagLbl.image = UIImage.init(named: "nowar")
                }
                
                cell.imageofferName.text = languageChangeString(a_str: "New")
            }
            if tag2 == 0
            {
                
                cell.tagLbl.image = UIImage.init(named: "")
                cell.imageofferName.text = ""
            }
            
            
            
            return cell
        }
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "coursesList2", for: indexPath) as! CustomTableViewCell
         
            if enrolledCover_typeArray[indexPath.row]  == "image"
            {
                cell.imageview_banner.sd_setImage(with: URL (string:enrolledCoverArray[indexPath.row]))
            }
            else
            {
                cell.imageview_banner.sd_setImage(with: URL (string:enrolledThumbnailArray[indexPath.row]))
            }
            
            if language == "ar"
            {
                GeneralFunctions.labelCustom_RTReg(labelName: cell.durationLbl, fontSize: 10)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.likesLbl, fontSize: 10)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.purchaseLbl, fontSize: 10)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.courseNameLbl, fontSize: 14)
               
                GeneralFunctions.labelCustom_RTReg(labelName: cell.authorNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: cell.lbl_downloadPercentage, fontSize: 11)
                GeneralFunctions.labelCustom_RTBold(labelName: cell.imageofferName, fontSize: 14)
                
            }
            else if language == "en"
            {
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.durationLbl, fontSize: 10)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.likesLbl, fontSize: 10)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.purchaseLbl, fontSize: 10)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.courseNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.authorNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTMedium(labelName: cell.lbl_downloadPercentage, fontSize: 12)
                GeneralFunctions.labelCustom_LTBold(labelName: cell.imageofferName, fontSize: 14)
            }
            
            
            cell.durationLbl.text = enrolledDurationArray[indexPath.row]
           
            
            cell.courseNameLbl.text = enrolledTitleArray[indexPath.row]
            cell.purchaseLbl.text = enrolledPurchasedArray[indexPath.row]
            cell.likesLbl.text = enrolledTotal_ratingsArray[indexPath.row]
            cell.authorNameLbl.text = enrolledAuthorName[indexPath.row]
            
            let tag = enrolledTagsArray[indexPath.row]
            let tag2 = Int(tag)
            

            
            
            if tag2 == 1
            {
                if language == "en"
                {
                    cell.tagLbl.image = UIImage.init(named: "hot1")
                }
                else
                {
                    cell.tagLbl.image = UIImage.init(named: "hotar")
                }
                cell.imageofferName.text = languageChangeString(a_str: "Hot")
            }
            if tag2 == 2
            {
                
                if language == "en"
                {
                    cell.tagLbl.image = UIImage.init(named: "now")
                }
                else
                {
                    cell.tagLbl.image = UIImage.init(named: "nowar")
                }
                
                cell.imageofferName.text = languageChangeString(a_str: "New")
            }
            if tag2 == 0
            {
                
                cell.tagLbl.image = UIImage.init(named: "")
                cell.imageofferName.text = ""
            }
            
            
            
            
            
            if enrolledCompletionArray[indexPath.row] == "100"
            {
                cell.btn_certificate.isHidden = false
               
                cell.btn_certificate.tag = indexPath.row
                cell.btn_certificate.addTarget(self, action: #selector(certificateDownload(sender:)),for: .touchUpInside)
               
                cell.progressview_download.progress = 1.0
                cell.lbl_downloadPercentage.text = languageChangeString(a_str:"Course Completed")
                

            }
            else
            {
                if downloadableOrNot[indexPath.row] == "0"
                {
                    cell.btn_download.isHidden =  true
                }

                cell.btn_download.tag = indexPath.row
                cell.btn_download.addTarget(self, action: #selector(courseDownload(sender:)),for: .touchUpInside)
                cell.btn_certificate.isHidden = true
               
                print(Float(Int(self.enrolledCompletionArray[indexPath.row]) ?? 0/100))
                cell.progressview_download.progress = Float(Int(self.enrolledCompletionArray[indexPath.row]) ?? 0)/100
                
                
                cell.lbl_downloadPercentage.text = String(format: "%@%@", (self.enrolledCompletionArray[indexPath.row]) ,languageChangeString(a_str: "% Course Completed") ?? "")
                
            }
    
            return cell
        }
        
        

       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
            vc.videoToPlay = coverArray[indexPath.row]
            navigation1 = "mycourses"
            vc.catageoryType = cover_typeArray[indexPath.row]
            vc.detailsCourseId = course_idArray[indexPath.row]
            vc.thumbnail = thumbnailArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 1
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsVC
            vc.videoToPlay = enrolledCoverArray[indexPath.row]
            navigation1 = "mycourses"
            vc.catageoryType = enrolledCover_typeArray[indexPath.row]
            vc.detailsCourseId = enrolledCourseidArray[indexPath.row]
            vc.thumbnail = enrolledThumbnailArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func courseDownload(sender:UIButton)
    {
       
        let courseId = enrolledCourseidArray[sender.tag]
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let myDownloadCourses = "\(base_path)services/add_to_downloads"
    
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let parameters: Dictionary<String, Any> = [
                                                       "lang" : "en",
                                                       "api_key":APIKEY,"user_id":myuserID,"course_id":courseId
                                                      ]
            
            print(parameters)
            
            Alamofire.request(myDownloadCourses, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                       
                       
                        DispatchQueue.main.async {
                             //self.showToastForAlert(message: message)
                            if  let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadsViewController")as? DownloadsViewController{
                                print("mr how")
                                self.navigationController?.pushViewController(vc, animated: true)
                        
                            }
                        
                        
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
    

    
   
    
    
    @objc func certificateDownload(sender:UIButton)
    {
        print(sender.tag)
        studentCourseId = enrolledCourseidArray[sender.tag]
        
        print("section tap is :\(studentCourseId)")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CertificateCourseVC") as! CertificateCourseVC
        vc.courseId = studentCourseId
        print(studentCourseId)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return 145
        }
        else
        {
             return 155
        }
       
    }
    
    
    // MARK: - UITapGestureRecognizer
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CertificateCourseVC") as! CertificateCourseVC
        vc.courseId = studentCourseId
        print(studentCourseId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        if language == "en"
        {
            if indexPath.section == 0 {
                
                return UISwipeActionsConfiguration(actions: [])
            }
                
            else
            {
                if enrolledCompletionArray[indexPath.row] == "100"
                {
                    let Title = languageChangeString(a_str: "Upload Projects")
                    
                    let upload = UIContextualAction(style: .normal, title:Title) { action, view, complete in
                        self.selectedIndexPath = indexPath
                        self.checkPhotoLibraryPermission()
                        //complete(true)
                    }
                    upload.backgroundColor = UIColor(red: 13/255, green: 205/255, blue: 120/255, alpha: 1.0)
                    
                    let askAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
                        print("Block")
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingReviewScreenVC") as! RatingReviewScreenVC
                        vc.courseId = self.enrolledCourseidArray[indexPath.row]
                        vc.courseTitle = self.enrolledTitleArray[indexPath.row]
                        if self.enrolledCover_typeArray[indexPath.row] == "image"
                        {
                            vc.bannerImage = self.enrolledCoverArray[indexPath.row]
                        }
                        else
                        {
                            vc.bannerImage = self.enrolledThumbnailArray[indexPath.row]
                        }
                        vc.courseTag = self.enrolledTagsArray[indexPath.row]
                        vc.coursePrice = self.enrolledOffer_priceArray[indexPath.row] + " " +
                        "SAR"
                        //self.enrolledCurrencyType[indexPath.row]
                        vc.courseDummyPrice = self.enrolledPriceArray[indexPath.row]
                        vc.duration = self.enrolledDurationArray[indexPath.row]
                        vc.courseRating = self.enrolledTotal_ratingsArray[indexPath.row]
                        vc.coursePurchased = self.enrolledPurchasedArray[indexPath.row]
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        // complete(true)
                        
                    }
                    
                    
                    askAction.image = UIImage(named: "star_gray")
                    askAction.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
                    return UISwipeActionsConfiguration(actions: [upload, askAction])
                    
                }
            }
            return UISwipeActionsConfiguration(actions: [])
        }
        else {
            
        }
        
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        
        if language == "ar"
        {
            if indexPath.section == 0 {
                
                return UISwipeActionsConfiguration(actions: [])
            }
                
            else
            {
                if enrolledCompletionArray[indexPath.row] == "100"
                {
                    let Title = languageChangeString(a_str: "Upload Projects")
                    
                    let upload = UIContextualAction(style: .normal, title:Title) { action, view, complete in
                        self.selectedIndexPath = indexPath
                        self.checkPhotoLibraryPermission()
                        //complete(true)
                    }
                    upload.backgroundColor = UIColor(red: 13/255, green: 205/255, blue: 120/255, alpha: 1.0)
                    
                    let askAction = UIContextualAction(style: .destructive, title: nil) { action, view, complete in
                        print("Block")
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingReviewScreenVC") as! RatingReviewScreenVC
                        vc.courseId = self.enrolledCourseidArray[indexPath.row]
                        vc.courseTitle = self.enrolledTitleArray[indexPath.row]
                        if self.enrolledCover_typeArray[indexPath.row] == "image"
                        {
                            vc.bannerImage = self.enrolledCoverArray[indexPath.row]
                        }
                        else
                        {
                            vc.bannerImage = self.enrolledThumbnailArray[indexPath.row]
                        }
                        vc.courseTag = self.enrolledTagsArray[indexPath.row]
                        vc.coursePrice = self.enrolledOffer_priceArray[indexPath.row] + " " +
                        "SAR"
                        //self.enrolledCurrencyType[indexPath.row]
                        vc.courseDummyPrice = self.enrolledPriceArray[indexPath.row]
                        vc.duration = self.enrolledDurationArray[indexPath.row]
                        vc.courseRating = self.enrolledTotal_ratingsArray[indexPath.row]
                        vc.coursePurchased = self.enrolledPurchasedArray[indexPath.row]
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        // complete(true)
                        
                    }
                    
                    
                    askAction.image = UIImage(named: "star_gray")
                    askAction.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
                    return UISwipeActionsConfiguration(actions: [upload, askAction])
                    
                }
            }
            return UISwipeActionsConfiguration(actions: [])
        }
        else {
            
        }
        
       
    return UISwipeActionsConfiguration(actions: [])
    }
    
    
    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
               
                self.UploadFun(indexPath: self.selectedIndexPath)
                
            }
            break
        //handle authorized status
        case .denied, .restricted :
            self.checkAuthorisation()
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    
                    print("permission  granted")
                    DispatchQueue.main.async {
                        print("permission already accepted")
                        
                        self.UploadFun(indexPath: self.selectedIndexPath)
                        
                        
                        
                    }
                    break
                // as above
                case .denied, .restricted:
                    // as above
                    self.checkAuthorisation()
                    break
                case .notDetermined:
                    self.checkAuthorisation()
                    break
                    // won't happen but still
                }
            }
        }
    }
    
    
    
    func checkAuthorisation(){
        
        DispatchQueue.main.async {
            MobileFixServices.sharedInstance.dissMissLoader()
            let alertController = UIAlertController(title: languageChangeString(a_str: "Error"), message: languageChangeString(a_str:"Enable photo permissions in settings"), preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: languageChangeString(a_str:"Settings"), style: .default) { (alertAction) in
                if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                    
                    //UIApplication.shared.openURL(appSettings as URL)
                    
                    UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                    
                }
            }
            alertController.addAction(settingsAction)
            // If user cancels, do nothing, next time Pick Video is called, they will be asked again to give permission
            let cancelAction = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            // Run GUI stuff on main thread
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func UploadFun(indexPath: IndexPath) {
        print("upload")
        print(indexPath)
        let enrolledId = enrolledCourseidArray[indexPath.row]
        
     
                    let view = UIAlertController(title:languageChangeString(a_str:"Upload Images") , message: "", preferredStyle: .actionSheet)
                    
                    
                    let PhotoLibrary = UIAlertAction(title:languageChangeString(a_str:"Upload photos from your library") , style: .default, handler: { action in
                        self.mediaTypeString = "photos"
                        self.multipleImagePicking(id: enrolledId)
                        
                        view.dismiss(animated: true)
                    })
                    let videoLibrary = UIAlertAction(title:languageChangeString(a_str:"Upload videos from your library"), style: .default, handler: { action in
                        self.mediaTypeString = "videos"
                        self.multipleImagePicking(id: enrolledId)
                        //view.dismiss(animated: true)
                    })
                    
                    let cancel = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel, handler: { action in
                    })
                    
                    
                    view.addAction(PhotoLibrary)
                  //  view.addAction(videoLibrary)
                    view.addAction(cancel)
                    self.present(view, animated: true)
        
        
    }
    
    
    
    func rateFunc(indexPath: IndexPath) {
        print("rate")
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingReviewScreenVC") as! RatingReviewScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func giveRatetBtnTap(_ sender: UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingReviewScreenVC") as! RatingReviewScreenVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    
    
    // wishList list service call
    
    func wishListCourses()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let coursesData = "\(base_path)services/my_courses?"
            
            //https://volive.in/mrhow_dev/services/my_courses?api_key=1762019&lang=en&user_id=8
            
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang": language,"user_id":myuserID]
            
            Alamofire.request(coursesData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [String:Any]
                        {
                            
                            if(self.enrolledCourseidArray.count > 0)||(self.enrolledTitleArray.count > 0)||(self.enrolledCover_typeArray.count > 0)||(self.enrolledCoverArray.count > 0)||(self.enrolledThumbnailArray.count > 0)||(self.enrolledPriceArray.count > 0)||(self.enrolledOffer_priceArray.count > 0)||(self.enrolledDurationArray.count > 0)||(self.enrolledTotal_ratingsArray.count > 0)||(self.enrolledTagsArray.count > 0)||(self.enrolledNameArray.count>0)||(self.enrolledPurchasedArray.count>0)||(self.enrolledCompletionArray.count>0)||(self.downloadedStatus.count>0)||(self.downloadableOrNot.count>0)||(self.enrolledCurrencyType.count>0) || self.enrolledAuthorName.count>0
                            {
                                self.enrolledCourseidArray.removeAll()
                                self.enrolledTitleArray.removeAll()
                                self.enrolledCover_typeArray.removeAll()
                                self.enrolledCoverArray.removeAll()
                                self.enrolledThumbnailArray.removeAll()
                                self.enrolledPriceArray.removeAll()
                                self.enrolledOffer_priceArray.removeAll()
                                self.enrolledDurationArray.removeAll()
                                self.enrolledTotal_ratingsArray.removeAll()
                                self.enrolledTagsArray.removeAll()
                                self.enrolledNameArray.removeAll()
                                self.enrolledPurchasedArray.removeAll()
                                self.enrolledCompletionArray.removeAll()
                                self.downloadedStatus.removeAll()
                                self.downloadableOrNot.removeAll()
                                self.enrolledCurrencyType.removeAll()
                                self.enrolledAuthorName.removeAll()
                                
                            }
                            
                            if let wishListData = response1["wishlist"] as? [[String:Any]]
                            {
                                
                                if(self.course_idArray.count > 0)||(self.course_titleArray.count > 0)||(self.cover_typeArray.count > 0)||(self.coverArray.count > 0)||(self.thumbnailArray.count > 0)||(self.priceArray.count > 0)||(self.offer_priceArray.count > 0)||(self.durationArray.count > 0)||(self.total_ratingsArray.count > 0)||(self.tagsArray.count > 0)||(self.category_nameArray.count>0)||(self.purchasedArray.count>0)||(self.wishListCurrencyType.count>0)
                                {
                                    self.course_idArray.removeAll()
                                    self.category_nameArray.removeAll()
                                    self.course_titleArray.removeAll()
                                    self.priceArray.removeAll()
                                    self.offer_priceArray.removeAll()
                                    self.cover_typeArray.removeAll()
                                    self.coverArray.removeAll()
                                    self.thumbnailArray.removeAll()
                                    self.total_ratingsArray.removeAll()
                                    self.purchasedArray.removeAll()
                                    self.tagsArray.removeAll()
                                    self.durationArray.removeAll()
                                    self.wishListCurrencyType.removeAll()
                                    
                                }
                                
                                for i in 0..<wishListData.count
                                {
                                    if let cover = wishListData[i]["cover"] as? String
                                    {
                                        self.coverArray.append(base_path+cover)
                                        
                                    }
                                    if let course_id = wishListData[i]["course_id"] as? String
                                    {
                                        self.course_idArray.append(course_id)
                                    }
                                    if let course_title = wishListData[i]["course_title"] as? String
                                    {
                                        self.course_titleArray.append(course_title)
                                        
                                    }
                                    if let cover_type = wishListData[i]["cover_type"] as? String
                                    {
                                        self.cover_typeArray.append(cover_type)
                                    }
                                    if let category_name = wishListData[i]["category_name"] as? String
                                    {
                                        self.category_nameArray.append(category_name)
                                    }
                                    
                                    if let total_ratings = wishListData[i]["total_ratings"] as? String
                                    {
                                        self.total_ratingsArray.append(total_ratings)
                                        
                                    }
                                    if let purchased = wishListData[i]["purchased"] as? String
                                    {
                                        self.purchasedArray.append(purchased)
                                    }
                                    
                                    if let tags = wishListData[i]["tags"] as? String
                                    {
                                        self.tagsArray.append(tags)
                                        
                                    }
                                    if let duration = wishListData[i]["duration"] as? String
                                    {
                                        self.durationArray.append(duration)
                                    }
                                    if let price = wishListData[i]["price"] as? String
                                    {
                                        self.priceArray.append(price)
                                        
                                    }
                                    if let offer_price = wishListData[i]["offer_price"] as? String
                                    {
                                        self.offer_priceArray.append(offer_price)
                                    }
                                    
                                    if let thumbnail = wishListData[i]["thumbnail"] as? String
                                    {
                                        self.thumbnailArray.append(base_path+thumbnail)
                                    }
                                    if let currency = wishListData[i]["currency"] as? String
                                    {
                                        self.wishListCurrencyType.append(currency)
                                    }
                                    
                                }
                                DispatchQueue.main.async {
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    self.tableViewList.reloadData()
                                    
                                }
                                if wishListData.count == 0
                                {
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    
                                    self.showToastForAlert(message:languageChangeString(a_str:"No Courses are there") ?? "", style: style1)
                                }
                                
                                
                            }
                            
                        }
                    }
                    else{
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
    
    //enrolled service call
    
    func enrolledCourses()
    {
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let coursesData = "\(base_path)services/my_courses?"
            
            //https://volive.in/mrhow_dev/services/my_courses?api_key=1762019&lang=en&user_id=8
          
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang":language,"user_id":myuserID]
            
            Alamofire.request(coursesData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [String:Any]
                        {
                            
                                if(self.course_idArray.count > 0)||(self.course_titleArray.count > 0)||(self.cover_typeArray.count > 0)||(self.coverArray.count > 0)||(self.thumbnailArray.count > 0)||(self.priceArray.count > 0)||(self.offer_priceArray.count > 0)||(self.durationArray.count > 0)||(self.total_ratingsArray.count > 0)||(self.tagsArray.count > 0)||(self.category_nameArray.count>0)||(self.purchasedArray.count>0)||(self.wishListCurrencyType.count>0)
                                {
                                    self.course_idArray.removeAll()
                                    self.category_nameArray.removeAll()
                                    self.course_titleArray.removeAll()
                                    self.priceArray.removeAll()
                                    self.offer_priceArray.removeAll()
                                    self.cover_typeArray.removeAll()
                                    self.coverArray.removeAll()
                                    self.thumbnailArray.removeAll()
                                    self.total_ratingsArray.removeAll()
                                    self.purchasedArray.removeAll()
                                    self.tagsArray.removeAll()
                                    self.durationArray.removeAll()
                                    self.wishListCurrencyType.removeAll()
                                   
                                }
                                
                            
                            if let enrolledData = response1["enrolled_courses"] as? [[String:Any]]
                            {
                                
                                if(self.enrolledCourseidArray.count > 0)||(self.enrolledTitleArray.count > 0)||(self.enrolledCover_typeArray.count > 0)||(self.enrolledCoverArray.count > 0)||(self.enrolledThumbnailArray.count > 0)||(self.enrolledPriceArray.count > 0)||(self.enrolledOffer_priceArray.count > 0)||(self.enrolledDurationArray.count > 0)||(self.enrolledTotal_ratingsArray.count > 0)||(self.enrolledTagsArray.count > 0)||(self.enrolledNameArray.count>0)||(self.enrolledPurchasedArray.count>0)||(self.enrolledCompletionArray.count>0)||(self.downloadedStatus.count>0)||(self.downloadableOrNot.count>0)||(self.enrolledCurrencyType.count>0)||self.enrolledAuthorName.count>0
                                {
                                    self.enrolledCourseidArray.removeAll()
                                    self.enrolledTitleArray.removeAll()
                                    self.enrolledCover_typeArray.removeAll()
                                    self.enrolledCoverArray.removeAll()
                                    self.enrolledThumbnailArray.removeAll()
                                    self.enrolledPriceArray.removeAll()
                                    self.enrolledOffer_priceArray.removeAll()
                                    self.enrolledDurationArray.removeAll()
                                    self.enrolledTotal_ratingsArray.removeAll()
                                    self.enrolledTagsArray.removeAll()
                                    self.enrolledNameArray.removeAll()
                                    self.enrolledPurchasedArray.removeAll()
                                    self.enrolledCompletionArray.removeAll()
                                    self.enrolledCurrencyType.removeAll()
                                    self.downloadedStatus.removeAll()
                                    self.downloadableOrNot.removeAll()
                                    self.enrolledAuthorName.removeAll()
                                    
                                }
                                
                                
                                for i in 0..<enrolledData.count
                                {
                                    if let cover = enrolledData[i]["cover"] as? String
                                    {
                                        self.enrolledCoverArray.append(base_path+cover)
                                        
                                    }
                                    if let course_id = enrolledData[i]["course_id"] as? String
                                    {
                                        self.enrolledCourseidArray.append(course_id)
                                    }
                                    if let course_title = enrolledData[i]["course_title"] as? String
                                    {
                                        self.enrolledTitleArray.append(course_title)
                                        
                                    }
                                    if let cover_type = enrolledData[i]["cover_type"] as? String
                                    {
                                        self.enrolledCover_typeArray.append(cover_type)
                                    }
                                    if let category_name = enrolledData[i]["category_name"] as? String
                                    {
                                        self.enrolledNameArray.append(category_name)
                                    }
                                    
                                    if let total_ratings = enrolledData[i]["total_ratings"] as? String
                                    {
                                    self.enrolledTotal_ratingsArray.append(total_ratings)
                                        
                                    }
                                    if let purchased = enrolledData[i]["purchased"] as? String
                                    {
                                        self.enrolledPurchasedArray.append(purchased)
                                    }
                                    
                                    if let tags = enrolledData[i]["tags"] as? String
                                    {
                                        self.enrolledTagsArray.append(tags)
                                        
                                    }
                                    if let duration = enrolledData[i]["duration"] as? String
                                    {
                                        self.enrolledDurationArray.append(duration)
                                    }
                                    if let price = enrolledData[i]["price"] as? String
                                    {
                                        self.enrolledPriceArray.append(price)
                                        
                                    }
                                    if let offer_price = enrolledData[i]["offer_price"] as? String
                                    {
                                        self.enrolledOffer_priceArray.append(offer_price)
                                    }
                                    
                                    if let thumbnail = enrolledData[i]["thumbnail"] as? String
                                    {
                                        self.enrolledThumbnailArray.append(base_path+thumbnail)
                                    }
                                    if let course_completion = enrolledData[i]["course_completion"] as? String
                                    {
                                        self.enrolledCompletionArray.append(course_completion)
                                    }
                                    if let downloadable = enrolledData[i]["downloadable"] as? String
                                    {
                                        self.downloadableOrNot.append(downloadable)
                                    }
                                    if let download_status = enrolledData[i]["download_status"] as? String
                                    {
                                        self.downloadedStatus.append(download_status)
                                    }
                                    if let currency = enrolledData[i]["currency"] as? String
                                    {
                                        self.enrolledCurrencyType.append(currency)
                                    }
                                    if let name = enrolledData[i]["name"] as? String
                                    {
                                        self.enrolledAuthorName.append(name)
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                DispatchQueue.main.async {
                                    print(self.enrolledCourseidArray)
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    self.tableViewList.reloadData()
                                    
                                }
                                
                                if enrolledData.count == 0
                                {
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    self.showToastForAlert(message:languageChangeString(a_str: "No Courses are there") ?? "", style: style1)
                                }
                                
                            }
                            
                        }
                    }
                    else{
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
    

    //MARK: MULTIPLE IMAGE PICKING
    func multipleImagePicking(id:String){
        
        if self.myArray.count > 0
        {
            self.myArray.removeAll()
        }
       
        if mediaTypeString == "photos" {
            print("From Photos")
            self.upload = true
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 1
            self.bs_presentImagePickerController(vc, animated: true,
                                                 select: { (asset: PHAsset) -> Void in DispatchQueue.main.async {
                                                    let photoAsset = asset
                                                    let manager = PHImageManager.default()
                                                    var options: PHImageRequestOptions?
                                                    options = PHImageRequestOptions()
                                                    options?.resizeMode = .exact
                                                    options?.isSynchronous = true
                                                    manager.requestImage(for: photoAsset,
                                                                         targetSize: PHImageManagerMaximumSize,contentMode:.aspectFit,
                                                                         options: options) { [weak self] result, _ in
                                                                            self?.myArray.append(result!)
                                                                            print(self?.myArray as Any)
                                                                            self?.multiImagesArr.append(result!)
                                                    }
                                                    print("MultiImage Array is:",self.multiImagesArr)
                                                    }
                                                    
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                print("Finish: \(assets)")
                self.uploadProject(courseId:id)
                DispatchQueue.main.async {
                    
                }
                
            }, completion: nil)
            
        }
        
            else if mediaTypeString == "videos"{
            
            print("From Videos")
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .video
            config.screens = [.library]
            config.video.libraryTimeLimit = 10000.0
            config.library.maxNumberOfItems = 1
            config.video.compression = AVAssetExportPresetMediumQuality
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, cancelled in
                for item in items {
                    switch item {
                    case .photo(let photo):
                        print(photo)
                    case .video(let video):
                        print("Selected Video URLS:\(video.url)")
                        self.myArray.append(video.url)
                    }
                }
                print("Selected URL Array Is:\(self.myArray)")
                self.uploadProject(courseId:id)
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }else{
            
        }
        
    }
    
    
    // upload service call
    func uploadProject(courseId:String)
    {
        //        https://volive.in/mrhow_dev/services/upload_projects
        //        Upload project(POST method)
        //
        //        Params:
        //        api_key:1762019
        //        lang:en
        //        user_id:
        //        course_id:
        //        project_file:
        
        
        if Reachability.isConnectedToNetwork()
        {
           MobileFixServices.sharedInstance.loader(view: self.view)
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        
        let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang":language, "user_id" : myuserID,"course_id":courseId]
        
        print("upload project",parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            if self.mediaTypeString == "photos"{
                for i in 0..<self.myArray.count {
                   
                    if let imageData1 = self.myArray[i] as? UIImage
                    {
                        if let imagePng = imageData1.pngData()
                        {
                            //let imageData = (self.myArray[i] as! UIImage).pngData()
                            
                            multipartFormData.append(imagePng , withName: "project_file", fileName: "file.jpg", mimeType: "image/jpeg")
                            
                            print(imagePng)
                        }
                    }
                }
            }else if self.mediaTypeString == "videos"{
                print("Video Uploading")
                for i in 0..<self.myArray.count {
                    do {
                        let videoData = try Data(contentsOf: self.myArray[i] as! URL, options: .mappedIfSafe)
                        print(print("Video Data:\(videoData as Any)"))
                        multipartFormData.append(videoData, withName: "project_file",fileName: "video.mov", mimeType: "video/mp4")
                        //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
                    } catch  {
                    }
                }
                
            }else{
                
            }
            print(parameters)
            
        },
         to:"\(base_path)services/upload_projects")
        { (result) in
            
            print(result)
            
            switch result {
            case .success(let upload, _, _):
                
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    
                })
                
                upload.responseJSON { response in
                    
                    print(response.result.value ?? "")
                    
                    guard let responseData = response.result.value as? Dictionary<String, Any> else
                    {
                        return
                    }
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                       MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                        
                    }
                }
                
            case .failure(let encodingError):
                MobileFixServices.sharedInstance.dissMissLoader()
                print(encodingError)
                
            }
        }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
        }
    
    }

}



