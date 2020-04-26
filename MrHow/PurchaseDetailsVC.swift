//
//  PurchaseDetailsVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
import SafariServices
import IQKeyboardManagerSwift

//let asyncPaymentCompletedNotificationKey = "AsyncPaymentCompletedNotificationKey"


class PurchaseDetailsVC: UIViewController,OPPCheckoutProviderDelegate {
    
    var courseIdToBuy = ""
    var priceofTheCourse = ""
    var courseToBuy = ""
    var discountGivenPerc = "0"
    var discount = 0
    var promoCode = ""
    var total = 0
    var currency = ""
    
    @IBOutlet weak var purchaseCourseSt: UILabel!
    @IBOutlet weak var promoCodeTF: UITextField!
    @IBOutlet weak var purchaseCorseNameLbl: UILabel!
    @IBOutlet weak var subTotalAmountLbl: UILabel!
    @IBOutlet weak var coursePriceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    @IBOutlet weak var proceedTopayBtn: UIButton!
    @IBOutlet weak var totalSt: UILabel!
    @IBOutlet weak var discountSt: UILabel!
    @IBOutlet weak var addPromoSt: UILabel!
    @IBOutlet weak var subtotalSt: UILabel!
    
    @IBOutlet weak var purchaseSummarySt: UILabel!
    @IBOutlet weak var applyCodeBtn: UIButton!
    
    var fontStyle = ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
     var paymentMethod = "visa"
    var checkoutProvider: OPPCheckoutProvider?
    let checkoutPaymentBrands = ["VISA", "MASTER"]
    
    var checkoutId = ""
    var transaction: OPPTransaction?
    var transactionID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

         IQKeyboardManager.shared.enable = false
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "Purchase Details")
            print("font changed")
            
        }

        
        
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK:- PROCESS TO PAY BTN
    @IBAction func processToPayBtnTap(_ sender: Any)
    {
        
        
        checkoutIdServiceCall()

    }
    
    
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        
        let provider = OPPPaymentProvider.init(mode:.live)
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
                  ["lang":language,"api_key":APIKEY,"user_id":myuserID,"course_id":courseIdToBuy,"price":self.priceofTheCourse,"amount_paid":String(total),"payment_method":"card","currency_type":currency,"transaction_id":self.transactionID,"coupon_code":self.promoCode]
            
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
                            vc.amountPayed = String(self.total)
                            vc.currencytype = self.currency
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
    
    
    func showResult(presenter: UIViewController, success: Bool, message: String?) {
        let title = success ? "Success" : "Failure"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        presenter.present(alert, animated: true, completion: nil)
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
                ["lang":language,"api_key":APIKEY,"user_id":myuserID,"course_id":courseIdToBuy,"amount":String(total),"currency_type":currency,"user_email":email,"shopper_url":"com.volive.mrhowApp://test"]
            
            print("payment checkout params",parameters)
            
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
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        //listOfPromoCodes()
        
        self.tabBarController?.tabBar.isHidden = true
      
            
            if language == "ar"{
                self.promoCodeTF.textAlignment = .right
                self.promoCodeTF.setPadding(left: -10, right: -10)
                GeneralFunctions.labelCustom_RTReg(labelName: purchaseCourseSt, fontSize: 17)
                GeneralFunctions.labelCustom_RTReg(labelName: addPromoSt, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: purchaseSummarySt, fontSize: 17)
                GeneralFunctions.labelCustom_RTReg(labelName: subtotalSt, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName:discountSt, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: totalSt, fontSize: 17)
               GeneralFunctions.buttonCustom_RTBold(buttonName: proceedTopayBtn, fontSize: 16)
               GeneralFunctions.buttonCustom_RTReg(buttonName: applyCodeBtn, fontSize: 12)
                GeneralFunctions.labelCustom_RTReg(labelName: coursePriceLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: purchaseCorseNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: discountLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: subTotalAmountLbl, fontSize: 14)
                GeneralFunctions.labelCustom_RTReg(labelName: subTotalAmountLbl, fontSize: 14)
                self.promoCodeTF.font = UIFont(name: "29LTBukra-Regular", size: 12)
                 GeneralFunctions.textPlaceholderText_RTLight(textFieldName: promoCodeTF, strPlaceHolderName: languageChangeString(a_str: "Enter your discount code") ?? "")
                
            }
            else if language == "en"{
                self.promoCodeTF.textAlignment = .left
                self.promoCodeTF.setPadding(left: 10, right: 10)
                GeneralFunctions.labelCustom_LTReg(labelName: purchaseCourseSt, fontSize: 17)
                GeneralFunctions.labelCustom_LTReg(labelName: addPromoSt, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: purchaseSummarySt, fontSize: 17)
                GeneralFunctions.labelCustom_LTReg(labelName: subtotalSt, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName:discountSt, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: totalSt, fontSize: 17)
                GeneralFunctions.buttonCustom_LTBold(buttonName: proceedTopayBtn, fontSize: 16)
                GeneralFunctions.buttonCustom_LTReg(buttonName: applyCodeBtn, fontSize: 12)
                GeneralFunctions.labelCustom_LTReg(labelName: coursePriceLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: purchaseCorseNameLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: discountLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: subTotalAmountLbl, fontSize: 14)
                GeneralFunctions.labelCustom_LTReg(labelName: subTotalAmountLbl, fontSize: 14)
                self.promoCodeTF.font = UIFont(name: "Poppins-Regular", size: 12)
                GeneralFunctions.textPlaceholderText_LTLight(textFieldName: promoCodeTF, strPlaceHolderName: languageChangeString(a_str: "Enter your discount code") ?? "")
                
            }
            
      
        self.purchaseCourseSt.text = languageChangeString(a_str: "Purchase Courses")
        self.addPromoSt.text = languageChangeString(a_str: "Add Promotional Code")
        self.purchaseSummarySt.text = languageChangeString(a_str: "Purchase Summary")
        self.subtotalSt.text = languageChangeString(a_str: "Subtotal")
        self.discountSt.text = languageChangeString(a_str: "Discount")
        self.totalSt.text = languageChangeString(a_str: "Total")
         self.proceedTopayBtn.setTitle(languageChangeString(a_str: "PROCEED TO PAY"), for: UIControl.State.normal)
         self.applyCodeBtn.setTitle(languageChangeString(a_str: "Apply code"), for: UIControl.State.normal)
         //self.promoCodeTF.placeholder = languageChangeString(a_str: "Enter your discount code")
        
        self.coursePriceLbl.text = priceofTheCourse + " " + currency
        self.purchaseCorseNameLbl.text = courseToBuy
        
        self.subTotalAmountLbl.text = priceofTheCourse + " " + currency
       
        if let offer = Int(self.discountGivenPerc)
        {
            if let actualPrice = Int(self.priceofTheCourse)
            {
                if offer != 0
                {
                self.discount = (actualPrice*offer)/100
                }
                self.total = actualPrice-self.discount
            }
            self.discountLbl.text = String(self.discount) + " " + currency
        }
        
        
        
         self.totalAmountLbl.text = String(total) + " " + currency
        
    }
    
    
    @IBAction func applyCodeBtnTap(_ sender: Any) {
        
        applyPromoCode()
        
        
    }
    
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func listOfPromoCodes()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let promoCodes = "\(base_path)services/promocodes?"
            
            //https://www.volive.in/mrhow_dev/services/validpromocode
            
            
            
            
            let parameters: Dictionary<String, Any> = [
                                                       "lang" : language,
                                                       "api_key":APIKEY
                
            ]
            print(parameters)
            Alamofire.request(promoCodes, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        if let responceData1 = responseData["data"] as? [[String:AnyObject]]
                        {
                            
                           for i in 0..<responceData1.count
                           {
                            if let promocode = responceData1[i]["promocode"] as? String
                            {
                                self.promoCode = promocode
                            }
                        }
                            
                            
                        print(self.promoCode)
                            DispatchQueue.main.async {
                           self.promoCodeTF.text = self.promoCode
                               
                            }
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        
                        
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert(message:"Please ensure you have proper internet connection",style: style1)
            
        }
        
    }
        
    
    func applyPromoCode()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let videoData = "\(base_path)services/validpromocode"
            
            //https://www.volive.in/mrhow_dev/services/validpromocode
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
          
            
            let parameters: Dictionary<String, Any> = ["promocode" :self.promoCodeTF.text ?? "",
                                                       "lang" : language,
                                                       "api_key":APIKEY
                                                       
                                                       ]
            print(parameters)
            Alamofire.request(videoData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as? String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        if let responceData1 = responseData["data"] as? [String:AnyObject]
                        {
                           
                            if let discount = responceData1["discount"] as? String
                            {
                                self.discountGivenPerc = discount
                            }
                            if let promocode = responceData1["promocode"] as? String
                            {
                                self.promoCode = promocode
                            }
                            
                        
                            if let offer = Int(self.discountGivenPerc)
                            {
                                if let actualPrice = Int(self.priceofTheCourse)
                                {
                                    
                                    self.discount = (actualPrice*offer)/100
                                    self.total = actualPrice-self.discount
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.discountLbl.text = String(self.discount)
                                self.totalAmountLbl.text = String(self.total) + " " + self.currency
                            }
                          }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message ?? "", style: style1)
                        self.discountGivenPerc = "0"
                        if let offer = Int(self.discountGivenPerc)
                        {
                            if let actualPrice = Int(self.priceofTheCourse)
                            {
                                if offer != 0 
                                {
                                self.discount = (actualPrice*offer)/100
                                }
                                self.total = actualPrice-self.discount
                            }
                        }
                        DispatchQueue.main.async {
                            self.discountLbl.text = String(self.discount)
                            self.totalAmountLbl.text = String(self.total) + " " + self.currency
                        }
                       
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
