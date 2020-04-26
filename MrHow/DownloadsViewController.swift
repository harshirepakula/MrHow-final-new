//
//  DownloadsViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 8/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVKit


class DownloadsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    var arrSectionData: NSArray = []
    
    var downloadCourseData:[downloadsData] = []
    
    @IBOutlet weak var downloadTV: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        if let aSize = UIFont(name: "Poppins-SemiBold", size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeBtn(_:)), name: NSNotification.Name(rawValue: "removed"), object: nil)
       
        downloadCoursesList()
        self.downloadTV.estimatedRowHeight = 130
        self.downloadTV.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
   
    @IBAction func backBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @objc func removeBtn(_ notification: Notification)
    {
        self.downloadCoursesList()
        
    }
    
    
    
    
    //service call for downloads
    
    func downloadCoursesList()
    {
        if Reachability.isConnectedToNetwork()
        {
            //MobileFixServices.sharedInstance.loader(view: self.view)
            
            let downloadData = "\(base_path)index.php/services/downloads?"
            
            
            //https://www.volive.in/mrhow_dev/index.php/services/downloads?api_key=1762019&lang=en&user_id=8
            
            
            
             let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": "en","user_id":myuserID]
            
            Alamofire.request(downloadData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {

                        let nonExsittingProductArry = responseData["data"] as! [Dictionary<String,Any>]
                        
                        self.arrSectionData = nonExsittingProductArry as NSArray
                        
                        
                        if (nonExsittingProductArry.count)>0{
                            
                            self.downloadCourseData.removeAll()
                            
                            
                            for i in nonExsittingProductArry{
                                let newNonexisttingData = downloadsData(courseId: ((i["course_id"] as? String)!), title: ((i["course_title"] as? String)!))
                                
                                self.downloadCourseData.append(newNonexisttingData)
                                
                            }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                
                               // self.heightConstraint.constant = 0
                                
                            }
                            
                        }
                        DispatchQueue.main.async
                        {
                            self.downloadTV.reloadData()
                            self.downloadTV.delegate = self
                            self.downloadTV.dataSource = self
                        
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrSectionData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let tempDic: NSDictionary = arrSectionData.object(at: section) as! NSDictionary
        let TempDataArr: NSArray  = tempDic.object(forKey: "mydownloads") as! NSArray
        print("sections are\(section),\(TempDataArr.count)")
        return TempDataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadsTableViewCell", for: indexPath) as! DownloadsTableViewCell
       
        cell.materialName.text = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["file_name"] as? String
        if let type = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["file_type"] as? String
        {
            if type == "video"
            {
                if let thumbnail = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["thumbnail"] as? String
                {
                    let img = base_path+thumbnail
                    cell.materialImg.sd_setImage(with: URL (string:img))
                }
            }
            else if type == "image"
            {
                if let thumbnail = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["file"] as? String
                {
                    let img = base_path+thumbnail
                    cell.materialImg.sd_setImage(with: URL (string:img))
                }
            }
                
            else if type == "xlsx"
            {
                 cell.materialImg.image = UIImage(named: "xl")
               
            }
            else if type == "ppt" || type == "pptx"
            {
                 cell.materialImg.image = UIImage(named: "ppt")
            }
            else if type == "doc" || type == "docx"
            {
                cell.materialImg.image = UIImage(named: "doc")
            }
            else if type == "pdf"
            {
                cell.materialImg.image = UIImage(named: "pdf")
            }
            else if type == "pdf"
            {
                cell.materialImg.image = UIImage(named: "pdf")
            }
            
        }
        
        cell.removeBtn.tag = indexPath.row
        let name = ((arrSectionData[indexPath.section] as! NSDictionary)["course_id"] as! String)
        print(name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let name = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["file"] as? String
        {
           let urlOfMaterial = base_path+name
            
            if let type = (((arrSectionData[indexPath.section] as! NSDictionary)["mydownloads"] as! NSArray)[indexPath.row] as! NSDictionary)["file_type"] as? String
            {
                if type == "video"
                {
                    guard let url = URL(string: urlOfMaterial) else {
                        return
                    }
                    
                    player = AVPlayer(url: url)
                    
                    
                    playerViewcontroller.player = player
                    playerViewcontroller.showsPlaybackControls = true
                    
                    
                    present(playerViewcontroller, animated: true) {
                        player.play()
                    }
                    
                }
                else{
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    vc.navigationChecking = urlOfMaterial
                    vc.title1 = "downloads"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    
    
    
    // delete course service call
    
     @objc func courseRemove(sender:UIButton)
    {
        let indexpath = sender.tag
        
        let tempDic: NSDictionary = arrSectionData.object(at: sender.tag) as! NSDictionary
       
        let TempDataArr: String  = tempDic.object(forKey: "course_id") as! String
        
        
       
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let myDownloadCourses = "\(base_path)services/remove_downloads"
            
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            let parameters: Dictionary<String, Any> = [
                "lang" : "en",
                "api_key":APIKEY,"user_id":myuserID,"course_id":TempDataArr
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
                        
                        self.showToastForAlert(message: message, style: style1)
                         NotificationCenter.default.post(name: NSNotification.Name("removed"), object: nil)
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

struct downloadsData {
    
    var course_id:String!
    var course_title:String!
   
    init(courseId:String,title:String) {
        
        self.course_id = courseId
        self.course_title = title
        }
    
}

