//
//  PaymentVC.swift
//  MrHow
//
//  Created by volivesolutions on 17/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import IQKeyboardManagerSwift


 

class PaymentVC: UIViewController,OPPCheckoutProviderDelegate {
    
    
   var promoCode = ""
    var courseIdToPay = ""
    var priceToPay = ""
    var paymentMethod = "visa"
    var currencyType = ""
    var checkoutProvider: OPPCheckoutProvider?
     var afterDiscount = ""
    var originalPrice = ""
    
    @IBOutlet weak var priceOfTheCourse: UILabel!
    
    
    
    @IBOutlet weak var payNowSt: UIButton!
    @IBOutlet weak var applePaySt: UILabel!
    @IBOutlet weak var paypalSt: UILabel!
    @IBOutlet weak var visaSt: UILabel!
    @IBOutlet weak var totalpayableSt: UILabel!
    @IBOutlet weak var applePay: UIButton!
    @IBOutlet weak var paypalBtn: UIButton!
    @IBOutlet weak var visaBtn: UIButton!
    
    var fontStyle = ""
    var checkoutId = ""
    
    let checkoutPaymentBrands = ["VISA", "MASTER"]
   
   
    var transaction: OPPTransaction?
    var transactionID = ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = false
        
        
         print("language in ",language)
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
    
        if let aSize = UIFont(name:fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "Payment")
            print("font changed")
            
        }
        
        
      self.visaSt.text = languageChangeString(a_str: "Online Payment")
      self.paypalSt.text = languageChangeString(a_str: "Cash On Delivery")
      self.totalpayableSt.text = languageChangeString(a_str:"Total Payable Amount")
      self.payNowSt.setTitle(languageChangeString(a_str: "PAY NOW"), for: UIControl.State.normal)
        
        if language == "ar"{
            
            GeneralFunctions.labelCustom_RTReg(labelName: visaSt, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: paypalSt, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: priceOfTheCourse, fontSize: 18)
            GeneralFunctions.labelCustom_RTReg(labelName: totalpayableSt, fontSize: 17)
            GeneralFunctions.buttonCustom_RTBold(buttonName: payNowSt, fontSize: 16)
            
        }
        else if language == "en"{
           
            GeneralFunctions.labelCustom_LTReg(labelName: visaSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: paypalSt, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: priceOfTheCourse, fontSize: 18)
            GeneralFunctions.labelCustom_LTReg(labelName: totalpayableSt, fontSize: 17)
            GeneralFunctions.buttonCustom_LTBold(buttonName: payNowSt, fontSize: 16)
          
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        
        let provider = OPPPaymentProvider.init(mode: .test)
        let checkoutSettings = configureCheckoutSettings()
        
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
        
    }
    
    
     func configureCheckoutSettings() -> OPPCheckoutSettings {
        
        let checkoutSettings = OPPCheckoutSettings()
        checkoutSettings.paymentBrands = checkoutPaymentBrands
        checkoutSettings.schemeURL = "com.volive.mrhowApp"
        //"https://volive.in/mrhow_dev"
       
        checkoutSettings.theme.navigationBarBackgroundColor = ThemeColor
        checkoutSettings.theme.confirmationButtonColor = ThemeColor
        checkoutSettings.theme.accentColor = ThemeColor
        checkoutSettings.theme.cellHighlightedBackgroundColor = ThemeColor
        checkoutSettings.theme.sectionBackgroundColor = ThemeColor
    
        //Rami
//        let lang = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
//        print("language in setting",lang)
    
        checkoutSettings.language = language
        
        return checkoutSettings
    }
    

    
    // MARK: - Payment helpers
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        
        guard let transaction = transaction else {
            showResult(presenter: self, success: false, message: error?.localizedDescription)
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            // If a transaction is synchronous, just request the payment status
            
            self.payNow()
            
           // self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            // If a transaction is asynchronous, SDK opens transaction.redirectUrl in a browser
            // Subscribe to notifications to request the payment status when a shopper comes back to the app
            NotificationCenter.default.addObserver(self, selector: #selector(redirect(_:)), name: Notification.Name(rawValue: "paymentVC"), object: nil)
 
            
        } else {
            print(error)
              showResult(presenter: self, success: false, message: "Invalid transaction")
        }
    }
    
    
    
    @objc func redirect(_ notification: Notification)
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"paymentVC"), object: nil)
        
 
               checkoutProvider?.dismissCheckout(animated: true) {
                  
                    DispatchQueue.main.async {
        
                        self.payNow()
                    }
                }
       
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    


    func showResult(presenter: UIViewController, success: Bool, message: String?) {
        let title = success ? "Success" : "Failure"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- PAYMENT NOW BTN
    
    @IBAction func payNowBtnTap(_ sender: Any)
    {
        checkoutIdServiceCall()
        
        
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.priceOfTheCourse.text = "\(self.priceToPay) \(currencyType)"
        

        
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    

    
    // buynow post service call
    
    func payNow()
    {
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let payNowService = "\(base_path)services/make_payment"
            
            //    https://volive.in/mrhow_dev/services/make_payment
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> =

                ["lang":language,"api_key":APIKEY,"user_id":myuserID,"course_id":courseIdToPay,"price":originalPrice,"amount_paid":priceToPay,"payment_method":"card","currency_type":currencyType,"transaction_id":self.transactionID,"coupon_code":self.promoCode]
            
            print("make payment service ",parameters)
            
            Alamofire.request(payNowService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print("after success full payment ",responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    if status == 1
                    {
                         self.showToastForAlert(message: message,style: style1)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1)
                        {
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentSuccessVC") as! PaymentSuccessVC
                        vc.amountPayed = self.priceToPay
                        vc.currencytype = self.currencyType
                        self.present(vc, animated: true, completion: nil)
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
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
           showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            
        }
        
    }

    
    func checkoutIdServiceCall()
    {
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let payNowService = "\(base_path)services/prepare_checkout"
            
          
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
             let email = UserDefaults.standard.object(forKey: "userEmail") as? String ?? ""
            
            let parameters: Dictionary<String, Any> =
                //com.qawafeltech.FoodStar.payments://test
                
          // com.volive.mrhowApp
                ["lang":language,"api_key":APIKEY,"user_id":myuserID,"course_id":courseIdToPay,"amount":priceToPay,"currency_type":currencyType,"user_email":email,"shopper_url":"com.volive.mrhowApp://test"]
            
            print(parameters)
            
            Alamofire.request(payNowService, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    
                    print("After success of payment in hyper pay response",responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        if let response2 = responseData["payment_data"] as? Dictionary<String, AnyObject>
                        {
                            if let transaction_id = response2["transaction_id"] as? String
                            {
                                self.transactionID = transaction_id
                            }
                        }
                        
                        
                        if let response1 = responseData["checkout_data"] as? Dictionary<String, AnyObject>
                        {
                            if let checkout_Id = response1["id"] as? String
                            {
                                self.checkoutId = checkout_Id
                            }
                            
                  print("after success payment redirect it to our app")
                            
                            self.checkoutProvider = self.configureCheckoutProvider(checkoutID: self.checkoutId)
                             self.checkoutProvider?.delegate = self
                            
                        self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
                                DispatchQueue.main.async {
                                    self.handleTransactionSubmission(transaction: transaction, error: error)
                                }
                            }, cancelHandler: nil)

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
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            
        }
        
    }
    
    

    
    @IBAction func visaBtnTap(_ sender: Any)
    {
        visaBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        paypalBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        applePay.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        paymentMethod = "visa"
    
    }
    
    
    
    @IBAction func paypalBtnTap(_ sender: Any) {
        visaBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        paypalBtn.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        applePay.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
         paymentMethod = "payPal"
    }
    
    
    @IBAction func applePayBtnTap(_ sender: Any)
    {
        visaBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        paypalBtn.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        applePay.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
         paymentMethod = "applePay"
    }
    
    
}
