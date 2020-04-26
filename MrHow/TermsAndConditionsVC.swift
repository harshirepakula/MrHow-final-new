//
//  TermsAndConditionsVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class TermsAndConditionsVC: UIViewController {
    
    @IBOutlet weak var tems_conditionsTV: UITextView!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var termsConditions : String!
    
    
     var fontStyle = ""
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
            
           self.navigationItem.title = languageChangeString(a_str: "Terms and Conditions")
            print("font changed")
            
        }
        
        
        
        
        let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? "ar"
        if strLang == "en"
        {
            print("English Version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
           
        }
        else if strLang == "ar"
        {    print("Arabic version")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
            
            
        }
        
        
         termsAndConditions()
        // Do any additional setup after loading the view.
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        
    
       
    }

    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // terms and conditions
    
    func termsAndConditions()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            //languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            let terms_conditions = "\(base_path)services/terms_conditions?"
            
           //https://volive.in/mrhow_dev/services/terms_conditions?api_key=1762019&lang=en
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language ]
            
            Alamofire.request(terms_conditions, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    //print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if let responceData1 = responseData["data"] as? [String:AnyObject]
                        {
                            self.termsConditions = responceData1["text"] as? String
                            
                        }
                        DispatchQueue.main.async {
                            
                        //self.tems_conditionsTV.text = self.termsConditions
                         self.tems_conditionsTV.attributedText = self.termsConditions.htmlToAttributedString
                            self.tems_conditionsTV.font = UIFont(name: "poppins", size: 18)
                           
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
