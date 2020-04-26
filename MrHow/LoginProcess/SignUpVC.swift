//
//  SignUpVC.swift
//  MrHow
//
//  Created by volivesolutions on 20/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH
import MapKit
import CoreLocation
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import GoogleSignIn


class SignUpVC: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate,GIDSignInDelegate , GIDSignInUIDelegate{
    
    @IBOutlet var btn_signinNow: UIButton!
    @IBOutlet var btn_termsAndConditions: UIButton!
    @IBOutlet var btn_termsCheckBox: CheckBox!
    
    var checkTerms = false
    var checkTermStr : String = ""
    var currentCity = ""
    var currentCountry = ""
    var gender = ""
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var genderArray = [String]()
    
    var uuid = ""
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet var txt_fullName: UITextField!
    @IBOutlet var txt_email: UITextField!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var txt_confirmPassword: UITextField!
    @IBOutlet var btn_passwordShow: UIButton!
    @IBOutlet var btn_confirmPasswordShow: UIButton!
    @IBOutlet weak var signUpstatic: UILabel!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var iagreeToSt: UILabel!
    @IBOutlet weak var alreadyHaveAccountSt: UILabel!
    
    var style = ""
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

      uuid = getUUID() ?? "01234"
        
        self.signupBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        self.btn_termsAndConditions.setTitle(languageChangeString(a_str: "Terms and Conditions"), for: UIControl.State.normal)
        self.btn_signinNow.setTitle(languageChangeString(a_str: "Sign in Now!"), for: UIControl.State.normal)
        
        self.iagreeToSt.text = languageChangeString(a_str: "I agree to the")
        self.alreadyHaveAccountSt.text = languageChangeString(a_str: "Already have an account?")
       self.signUpstatic.text = languageChangeString(a_str: "Sign up")

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    
    }
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.currentCity = city
            self.currentCountry = country
            
            print(city + ", " + country)
        }
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
       // btn_signinNow.addBorder(side: .Bottom, color: #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1), width: 1.0)
       // btn_termsAndConditions.addBorder(side: .Bottom, color: #colorLiteral(red: 0.9254901961, green: 0.3215686275, blue: 0.3215686275, alpha: 1), width: 1.0)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

        let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? "ar"
        if strLang == "en"
        {
            print("English Version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else if strLang == "ar"
        {    print("Arabic version")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        
        genderArray = [languageChangeString(a_str: "Male"),languageChangeString(a_str: "Female")] as? [String] ?? [""]
        
        genderTF.delegate = self
        
        if language == "ar"
        {
        
            self.txt_email.textAlignment = .right
            self.txt_password.textAlignment = .right
            self.txt_confirmPassword.textAlignment = .right
            self.txt_fullName.textAlignment = .right
            self.genderTF.textAlignment = .right
            self.phoneTF.textAlignment = .right
            self.txt_email.setPadding(left: -10, right: -10)
            self.txt_password.setPadding(left: -10, right: -10)
            self.txt_confirmPassword.setPadding(left: -10, right: -10)
            self.txt_fullName.setPadding(left: -10, right: -10)
            self.genderTF.setPadding(left: -10, right: -10)
             self.phoneTF.setPadding(left: -10, right: -10)
            self.txt_fullName.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.txt_email.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.txt_password.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.txt_confirmPassword.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.genderTF.font = UIFont(name: "29LTBukra-Regular", size: 12)
            self.phoneTF.font = UIFont(name: "29LTBukra-Regular", size: 12)
        
            GeneralFunctions.labelCustom_RTReg(labelName: iagreeToSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: alreadyHaveAccountSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: signUpstatic, fontSize: 13)
            GeneralFunctions.buttonCustom_RTBold(buttonName: signupBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_termsAndConditions, fontSize: 14)
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_signinNow, fontSize: 14)
       
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_password, strPlaceHolderName: languageChangeString(a_str: "Password*") ?? "")
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_email, strPlaceHolderName: languageChangeString(a_str: "E-mail Address*") ?? "")
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_fullName, strPlaceHolderName: languageChangeString(a_str: "Full Name(as in your certificate)*") ?? "")
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_confirmPassword, strPlaceHolderName: languageChangeString(a_str: "Confirm Password*") ?? "")
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: genderTF, strPlaceHolderName: languageChangeString(a_str: "Gender*") ?? "")
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName: phoneTF, strPlaceHolderName: languageChangeString(a_str: "Phone Number") ?? "")
             style = "29LTBukra-Regular"

           
            
        }
        else if language == "en"
        {
            self.txt_fullName.textAlignment = .left
            self.txt_password.textAlignment = .left
            self.txt_email.textAlignment = .left
            self.txt_confirmPassword.textAlignment = .left
            self.genderTF.textAlignment = .left
            self.phoneTF.textAlignment = .left
            self.phoneTF.setPadding(left: 10, right: 10)
            self.txt_email.setPadding(left: 10, right: 10)
            self.txt_password.setPadding(left: 10, right: 10)
            self.txt_confirmPassword.setPadding(left: 10, right: 10)
            self.txt_fullName.setPadding(left: 10, right: 10)
            self.genderTF.setPadding(left: 10, right: 10)
            self.txt_fullName.font = UIFont(name: "Poppins-Regular", size: 12)
            self.txt_email.font = UIFont(name: "Poppins-Regular", size: 12)
            self.txt_password.font = UIFont(name: "Poppins-Regular", size: 12)
            self.txt_confirmPassword.font = UIFont(name: "Poppins-Regular", size: 12)
            self.genderTF.font = UIFont(name: "Poppins-Regular", size: 12)
            self.phoneTF.font = UIFont(name: "Poppins-Regular", size: 12)
            
            GeneralFunctions.labelCustom_LTReg(labelName: iagreeToSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: alreadyHaveAccountSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: signUpstatic, fontSize: 13)
            GeneralFunctions.buttonCustom_LTBold(buttonName: signupBtn, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_termsAndConditions, fontSize: 14)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_signinNow, fontSize: 14)
            
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_password, strPlaceHolderName: languageChangeString(a_str: "Password*") ?? "")
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_email, strPlaceHolderName: languageChangeString(a_str: "E-mail Address*") ?? "")
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_fullName, strPlaceHolderName: languageChangeString(a_str: "Full Name(as in your certificate)*") ?? "")
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_confirmPassword, strPlaceHolderName: languageChangeString(a_str: "Confirm Password*") ?? "")
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName: genderTF, strPlaceHolderName: languageChangeString(a_str: "Gender*") ?? "")
              GeneralFunctions.textPlaceholderText_LTLight(textFieldName: phoneTF, strPlaceHolderName: languageChangeString(a_str: "Phone Number") ?? "")
             style = "Poppins-Regular"
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if textField == genderTF
        {
            self.pickUp(genderTF)
        }
        
        
    }
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Back Button
    
    @IBAction func backBtnTap(_ sender: UIButton)
    {
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsAndConditionsBtnTap(_ sender: UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func signUpBtnTap(_ sender: UIButton)
    {
        if self.txt_fullName?.text == nil || self.txt_fullName?.text! == "" || self.txt_confirmPassword?.text == nil || self.txt_confirmPassword?.text! == "" ||
            self.txt_confirmPassword?.text == nil || self.txt_confirmPassword?.text! == "" ||
            self.txt_email?.text == nil || self.txt_email?.text! == "" || self.genderTF.text == nil || self.genderTF.text == ""
        {
            
            showToastForAlert(message:languageChangeString(a_str:"Please Enter All Fields") ?? "", style: style2)
            
            return
        }
 
    
        
        if txt_password.text != txt_confirmPassword.text
        {
        
            showToastForAlert(message:languageChangeString(a_str:"Password and confirm password don't match") ?? "", style: style2)
            return
        }
        
      
        if checkTermStr == "0" || checkTermStr == ""
        {
            
            showToastForAlert(message:languageChangeString(a_str:"Please Agree Terms And Conditions") ?? "", style: style2)
            return
        }
        
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
       

            let signup = "\(base_path)services/registration"

       
       
            let parameters: Dictionary<String, Any> = [ "name" : self.txt_fullName.text ?? "", "email":self.txt_email.text ?? "" ,"password" : self.txt_password.text ?? "" , "agree_tc" :checkTermStr , "device_name" : DEVICETYPE , "device_token" : DEVICE_TOKEN , "lang" : language,"api_key":APIKEY,"country":currentCountry,"city":currentCity,"gender":gender,"imei":uuid,"phone":self.phoneTF.text ?? ""]
        
        print(parameters)
            
        Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
                
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
               
                if status == 1
                {
                     MobileFixServices.sharedInstance.dissMissLoader()
                    
                    DispatchQueue.main.async {
                        
                         self.showToastForAlert(message: message, style: self.style)
                        
                       DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                   

                    
                }
                else
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    self.showToastForAlert(message: message,style: self.style)
                    print(message)
                }
            }
         }
       
        
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style:self.style)
            
        }

 }
        
    
    @IBAction func signInNowBtnTap(_ sender: UIButton)
    {
        //self.navigationController?.popViewController(animated: true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    @IBAction func termsCheckBoxBtnTapped(_ sender: UIButton) {
        
        if btn_termsCheckBox.isChecked == true{
            
                    checkTerms = false
                    checkTermStr = "0"
                    print(checkTermStr)
        }
        else
        {
            checkTerms = true
            checkTermStr = "1"
            print(checkTermStr)
            
        }
        
 }
    
    
    @IBAction func passwordShowBtnTap(_sender:UIButton)
    {
        self.view .endEditing(true)
        
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected {
            txt_password.isSecureTextEntry = false // show the password
            btn_passwordShow .setImage(UIImage.init(named: "Glook"), for: .normal)
            
        }
        else {
            txt_password.isSecureTextEntry = true
            btn_passwordShow .setImage(UIImage.init(named: "Group 2681"), for: .normal)
        }
        
    }
    
    @IBAction func confirmPasswordShowBtnTap(_sender:UIButton)
    {
        self.view.endEditing(true)
        
        _sender.isSelected = !_sender.isSelected
        
        if _sender.isSelected {
            txt_confirmPassword.isSecureTextEntry = false // show
            btn_confirmPasswordShow .setImage(UIImage.init(named: "Glook"), for: .normal)
            
        }
        else {
            txt_confirmPassword.isSecureTextEntry = true
            btn_confirmPasswordShow .setImage(UIImage.init(named: "cancle"), for: .normal)
        }
        
    }
    
    //validate email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //   MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title:languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func donePickerView(){
        
        self.genderTF.resignFirstResponder()
        self.genderTF.text = genderArray[(pickerView?.selectedRow(inComponent: 0))!]
        
        if self.genderTF.text == languageChangeString(a_str: "Female")
        {
            self.gender = "2"
            
        }else
        {
            self.gender = "1"
        }
        
    }
    
    
    @objc func cancelPickerView(){
        
        self.genderTF.resignFirstResponder()
        
    }
    
    
    //here gmail sign up action
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print("failed of gmail")
        }else
        {
            print(user.profile.hasImage)
            print("successssss")
            print(user.profile.email!)
            print(user.profile.name!)
            print(user.userID!)
            if user.profile.hasImage
            {
                let pic = user.profile.imageURL(withDimension: 100)
                //print(pic)
            }
            
            // do ur service call here
            if let myname = user.profile.name{
                if let myEmail = user.profile.email{
                    if let myuserId = user.userID{
                        
                         UserDefaults.standard.set(0 as Any, forKey: "remeberValue")
                        
                        self.socialSignup(name: myname, email: myEmail, unique_id: myuserId,login_type : "google")
                    }
                }
                
            }
            
        }
        
    }
    
   
    @IBAction func facebookBtn(_ sender: Any) {
    
        let loginManager = LoginManager()
        loginManager.loginBehavior = .browser
        
        loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    if let info = result as? [String : AnyObject]
                    {
                        
                        print(info)
                        print(info["name"] as! String)
                        
                        // do ur service call here
                        if let myname = info["name"] as? String{
                            if let myEmail = info["email"] as? String{
                                if let myuserId = info["id"] as? String{
                                   
                                    UserDefaults.standard.set(0 as Any, forKey: "remeberValue")
                                    
                                    self.socialSignup(name: myname, email: myEmail, unique_id: myuserId,login_type : "facebook" )
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                }
                Connection.start()
                
            default:
                print("??")
            }
        }
        
        
    }
    
    
    func socialSignup(name: String , email : String , unique_id : String , login_type : String )  {
        print(name,email,unique_id)
        
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let signup = "\(base_path)services/social_login"
            //"https://volive.in/mrhow_dev/services/social_login"
            
           // "\(base_path)services/registration"
            // let deviceToken = UserDefaults.standard.object(forKey: "deviceToken") as! String
            
            //let deviceToken = "12345"
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let parameters: Dictionary<String, Any> = [
                "name" : name
                ,"email":email
                ,"login_type" : login_type
                ,"device_name" : DEVICETYPE
                ,"device_token" : DEVICE_TOKEN
                ,"lang" :language,"api_key":APIKEY
                ,"unique_id" : unique_id
            ]
            
            print("these are my params",parameters)
            
            Alamofire.request(signup, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    if status == 1
                    {
                        print(responseData)
                        if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                            
                            let userName = userDetailsData["name"] as? String?
                            let userEmail = userDetailsData["email"] as? String?
                            //let userImg = userDetailsData["profile_pic"] as? String?
                            var image = ""
                            if let userImg = userDetailsData["profile_pic"] as? String
                            {
                                image = base_path+userImg
                            }
                            
                            let userId = userDetailsData["user_id"] as? String?
                            let thumbUserImg = userDetailsData["pic_thumb"] as? String?
                            
                            //   let userImage = String(format: "%@%@",base_path,userImg!!)
                            
                            UserDefaults.standard.set(userName as Any, forKey: "userName")
                            UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
                            UserDefaults.standard.set(userId as Any, forKey: USER_ID)
                            UserDefaults.standard.set(image as Any, forKey: "userImage")
                            UserDefaults.standard.set(login_type as Any, forKey: "loginType")
                            
                            
                            if let thumbImg = thumbUserImg as? String
                            {
                                if let base_imag_url = responseData["base_url"] as? String
                                {
                                    
                                    if let theProfileImageUrl = URL(string: base_imag_url + thumbImg) {
                                        do {
                                            let imageData = try Data(contentsOf: theProfileImageUrl as URL)
                                            
                                            UserDefaults.standard.set(imageData, forKey: "myimage")
                                            
                                            
                                        } catch {
                                            print("Unable to load data: \(error)")
                                        }
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                        DispatchQueue.main.async {
                            
                            MobileFixServices.sharedInstance.dissMissLoader()
                            
                            self.navigationItem.hidesBackButton = true
                            let stb = UIStoryboard(name: "Main", bundle: nil)
                            let tabBar = stb.instantiateViewController(withIdentifier: "tabbar") as! TabBarControllerVC
                            
                            let nav = tabBar.viewControllers?[1] as! UINavigationController
                            let studioVC = stb.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
                            tabBar.selectedIndex = 1
                            self.present(tabBar, animated: true) {
                                nav.pushViewController(studioVC, animated: false)
                            }
                            
                            //self.showToastForAlert(message: message)
                            
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: self.style)
                    }
                }
            }
            
            
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style)
            
        }
        
        
    }
    
    
    
    @IBAction func googleBtn(_ sender: Any) {
    
        
        if Reachability.isConnectedToNetwork() == true {
            
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
        else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style)
          
        }
    }
    
}

extension SignUpVC : UIPickerViewDataSource,UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.genderArray.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.genderTF.text = self.genderArray[row]
        
    }
    
}
