//
//  CertificateCourseVC.swift
//  MrHow
//
//  Created by volivesolutions on 31/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import AssetsLibrary


class CertificateCourseVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var viewBg: UIView!
    @IBOutlet var btn_share: UIButton!
    @IBOutlet var btn_download: UIButton!
    
    @IBOutlet weak var certificateImg: UIImageView!
    
    @IBOutlet weak var pdfDownloadBtn: UIButton!
    var courseId = ""
    var showCertificate = ""
    var pdfOfCertificate = ""
    var colorBg = ""
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
  //     int x,y;
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
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            self.navigationItem.title = languageChangeString(a_str: "Certificates")
           
            
        }
        
        self.pdfDownloadBtn.setTitle(languageChangeString(a_str: "DOWNLOAD AS PDF"), for: UIControl.State.normal)
        self.btn_download.setTitle(languageChangeString(a_str: "DOWNLOAD"), for: UIControl.State.normal)
        self.btn_share.setTitle(languageChangeString(a_str: "SHARE"), for: UIControl.State.normal)
        
        if language == "ar"
        {
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_download, fontSize: 16)
             GeneralFunctions.buttonCustom_RTReg(buttonName: btn_share, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: pdfDownloadBtn, fontSize: 16)
        }
        else if language == "en"
        {
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_download, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_share, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: pdfDownloadBtn, fontSize: 16)
            
        }
        
     

    }
    

    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        certificateOfCandidate()
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - ShareButton
    
    @IBAction func shareBtnTap(_ sender: Any)
    {
        let shareVC = UIActivityViewController(activityItems: ["Google.com"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    // MARK: - Back Button
    
    @IBAction func downloadBtnTap(_ sender: Any)
    {
        checkPhotoLibraryPermission()
    }
    
    
    
    @IBAction func pdfDownloadBtnTap(_ sender: Any) {
        
        let urlToGive = pdfOfCertificate
        guard let url = URL(string: urlToGive) else { return }
        UIApplication.shared.open(url)
    }
   
    
    func checkPhotoLibraryPermission() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                print("permission already accepted")
                let imagestring = self.showCertificate
                
                MobileFixServices.sharedInstance.loader(view: self.view)
                if let url = URL(string: imagestring),
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                   self.showToastForAlert(message: languageChangeString(a_str:"Your certificate has been saved") ?? "", style: style1)
                }
                
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
                        let imagestring = self.showCertificate
                        
                        MobileFixServices.sharedInstance.loader(view: self.view)
                        if let url = URL(string: imagestring),
                            let data = try? Data(contentsOf: url),
                            let image = UIImage(data: data) {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            
                            self.showToastForAlert(message: languageChangeString(a_str:"Your certificate has been saved") ?? "", style: style1)
                        }
                        
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
            let alertController = UIAlertController(title: languageChangeString(a_str:"Error"), message: languageChangeString(a_str:"Enable photo permissions in settings"), preferredStyle: .alert)
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
    
   
   
    
   
    
    //certificate service call
    
    func certificateOfCandidate()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            // languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let sub_catageories = "\(base_path)services/course_certificate?"
            
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
            //https://volive.in/mrhow_dev/services/course_certificate?api_key=1762019&lang=en&user_id=8&course_id=3
            
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["api_key" :APIKEY ,"lang": language,"course_id":courseId,"user_id":myuserID]
            print(parameters)
            Alamofire.request(sub_catageories, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                   
                    let status = responseData["status"] as? Int
                    let message = responseData["message"] as? String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [String:Any]
                        {
                            if let certificatePdf = response1["certificate_pdf"] as? String
                            {
                                self.pdfOfCertificate = base_path+certificatePdf
                            }
                            
                            
                            if let certificate = response1["certificate"] as? String
                            {
                                
                                self.showCertificate = base_path+certificate
                               
                                DispatchQueue.main.async {
                                
                                    
                                    self.certificateImg.sd_setImage(with: URL (string:self.showCertificate))
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                }
                            }
                                
                        }
                        
                        if let color = responseData["bg_color"] as? String
                        {
                            self.colorBg = color
                            DispatchQueue.main.async
                            {
                                self.viewBg.backgroundColor =
                                    self.hexStringToUIColor(hex: self.colorBg)
                            }
                        }
                        
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message ?? "", style: style1)
                            
                        }
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    
}


