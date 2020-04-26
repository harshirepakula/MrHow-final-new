//
//  AboutUsVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class AboutUsVC: UIViewController {
    
    @IBOutlet weak var aboutUsTV: UITextView!
    
 
    
    var aboutUsData : String!
    var facebook : String!
    var google : String!
    var instagram : String!
    var twitter : String!

    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }

        if let aSize = UIFont(name: fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "About Us")
            print("font changed")
            
        }
       
        // Do any additional setup after loading the view.
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
         aboutUs()
        
        
    }
    
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fbBtnTap(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
         vc.navigationChecking = self.facebook
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @IBAction func googleBtnTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.navigationChecking = self.google
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func instaBtnTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.navigationChecking = self.instagram
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func twitterBtnTap(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.navigationChecking = self.twitter
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
  
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // AboutUs service call
    
    func aboutUs()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            //languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let about = "\(base_path)services/about_us?"
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            //https://volive.in/mrhow_dev/services/about_us?api_key=1762019&lang=en
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language]
            
            Alamofire.request(about, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    //print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if let responceData1 = responseData["data"] as? [String:AnyObject]
                        {
                            self.aboutUsData = responceData1["text"] as? String
                            self.facebook = responceData1["facebook"] as? String
                            self.instagram = responceData1["instagram"] as? String
                            self.twitter = responceData1["twitter"] as? String
                            self.google = responceData1["google"] as? String
                            
                        }
                        DispatchQueue.main.async {
                          
                            //print(self.aboutUsData.htmlToAttributedString)
                            self.aboutUsTV.attributedText = self.aboutUsData.htmlToAttributedString
                            if language == "ar"
                            {
                                self.aboutUsTV.font = UIFont(name: "29LTBukra-Regular", size: 18)
                            }
                            else if language == "en"
                            {
                                self.aboutUsTV.font = UIFont(name: "Poppins-Regular", size: 18)
                            }
                            self.aboutUsTV.resizeForHeight()
                            self.view.layoutIfNeeded()
                          
                        }
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message,style: style1)
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
        }
        
    }
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextView {
    func resizeForHeight(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
