//
//  CurrencySwitchVC.swift
//  MrHow
//
//  Created by harshitha on 14/10/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

 var selectedCurrency = ""

class CurrencySwitchVC: UIViewController {

    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
   
    
    @IBOutlet weak var usdSt: UILabel!
    @IBOutlet weak var sarSt: UILabel!
    @IBOutlet weak var doyouwantSt: UILabel!
    
    @IBOutlet weak var sarBtn: UIButton!
    @IBOutlet weak var usdBtn: UIButton!
   
    @IBOutlet weak var proceedBtn: UIButton!
    
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.usdSt.text = languageChangeString(a_str: "Pay With USD")
        self.sarSt.text = languageChangeString(a_str: "Pay With SAR")
        self.doyouwantSt.text = languageChangeString(a_str: "Do You Want Purchase The Course")
        self.proceedBtn.setTitle(languageChangeString(a_str: "PROCEED TO PAY"), for: UIControl.State.normal)
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: usdSt, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: sarSt, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: doyouwantSt, fontSize: 15)
           GeneralFunctions.buttonCustom_RTBold(buttonName: proceedBtn, fontSize: 15)
           
          
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: usdSt, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: sarSt, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: doyouwantSt, fontSize: 15)
             GeneralFunctions.buttonCustom_LTBold(buttonName: proceedBtn, fontSize: 15)
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    // Dismiss View
    @objc fileprivate func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func sarBtnTap(_ sender: Any) {
        
        sarBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        usdBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedCurrency = "1"
    }
    
    @IBAction func usdBtnTap(_ sender: Any) {
        
        usdBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        sarBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedCurrency = "2"
    }
    
    
    @IBAction func proceedBtnTap(_ sender: Any) {
        
        if selectedCurrency == ""
        {
            showToastForAlert(message: languageChangeString(a_str: "Please Select Payment Option")!, style: style1)
        }
        //NotificationCenter.default.post(name: NSNotification.Name("non_exsiting_product"), object: nil)
        else
        {
           self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name("currency"), object: nil)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    

    @IBAction func pangesture_Action_Click(_ sender: UIPanGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
        
    }
    

}
