//
//  PaymentSuccessVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class PaymentSuccessVC: UIViewController {
    
    var amountPayed = ""
    var currencytype = ""
    
    @IBOutlet weak var paymentSuccessMsg: UILabel!
    
    @IBOutlet weak var viewCourseBtn: UIButton!
    
    @IBOutlet weak var weAreSendingSt: UILabel!
    @IBOutlet weak var thankUOrderSt: UILabel!
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.thankUOrderSt.text = languageChangeString(a_str: "Thank you for your order!")
      //  self.paymentSuccessMsg.text = languageChangeString(a_str: "or Login with")
      
        self.weAreSendingSt.text = languageChangeString(a_str: "We are sending a copy of all important order information to your email address.")
           self.viewCourseBtn.setTitle(languageChangeString(a_str: "View Courses"), for: UIControl.State.normal)
        
        
        
        if language == "ar"{
            
            GeneralFunctions.labelCustom_RTReg(labelName: thankUOrderSt, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: weAreSendingSt, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: paymentSuccessMsg, fontSize: 18)
            
            GeneralFunctions.buttonCustom_RTReg(buttonName: viewCourseBtn, fontSize: 16)
            
        }
        else if language == "en"{
            
            GeneralFunctions.labelCustom_LTReg(labelName: thankUOrderSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: weAreSendingSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: paymentSuccessMsg, fontSize: 18)
            
            GeneralFunctions.buttonCustom_LTReg(buttonName: viewCourseBtn, fontSize: 16)
            
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func viewCourceBtnTap(_ sender: Any)
    {
        
        navigationItem.hidesBackButton = true
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = stb.instantiateViewController(withIdentifier: "tabbar") as! TabBarControllerVC
        
        let nav = tabBar.viewControllers?[1] as! UINavigationController
        let studioVC = stb.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
        
        tabBar.selectedIndex = 1
        self.present(tabBar, animated: true) {
            nav.pushViewController(studioVC, animated: false)
        }
      
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.paymentSuccessMsg.text = String(format: "%@%@%@%@",languageChangeString(a_str: "You have been purchased") ?? ""," ", (self.amountPayed),(self.currencytype))
        
       //"You have been charged \(self.amountPayed) today"
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
