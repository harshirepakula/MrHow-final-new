//
//  SignInVC.swift
//  MrHow
//
//  Created by volivesolutions on 20/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import MOLH
import MapKit
import CoreLocation

class SignInVC: UIViewController , GIDSignInDelegate , GIDSignInUIDelegate,CLLocationManagerDelegate{
    
    @IBOutlet var txt_userName: UITextField!
    @IBOutlet var txt_password: UITextField!
    @IBOutlet var btn_signUpNow: UIButton!
    @IBOutlet var btn_passwordShow : UIButton!
    @IBOutlet var btn_signin: UIButton!
    @IBOutlet weak var btn_reminder: CheckBox!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var logInWithLbl: UILabel!
    @IBOutlet weak var signInStatic: UILabel!
    @IBOutlet weak var rememberMeLbl: UILabel!
    @IBOutlet weak var dontHaveLbl: UILabel!
   
    var remembermeBtnCheckValue : Int!
    var currentCity = ""
    var currentCountry = ""
    
     let locationManager = CLLocationManager()
    
    var style = ""
    var uuid = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uuid = getUUID() ?? "01234"
   
        
        self.btn_signin.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.btn_signUpNow.setTitle(languageChangeString(a_str: "Sign Up Now!"), for: UIControl.State.normal)
        self.forgotPasswordBtn.setTitle(languageChangeString(a_str: "Forgot Your Password?"), for: UIControl.State.normal)
        
        self.rememberMeLbl.text = languageChangeString(a_str: "Remember Me")
        self.logInWithLbl.text = languageChangeString(a_str: "or Login with")
        self.dontHaveLbl.text = languageChangeString(a_str: "Don't have an account?")
        self.signInStatic.text = languageChangeString(a_str: "Sign in")
        //self.txt_userName.placeholder = languageChangeString(a_str: "Email Address")
        //self.txt_password.placeholder = languageChangeString(a_str: "Password")
        
        if language == "ar"
        {
            GeneralFunctions.labelCustom_RTReg(labelName: rememberMeLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: logInWithLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: dontHaveLbl, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: signInStatic, fontSize: 13)
            GeneralFunctions.buttonCustom_RTBold(buttonName: btn_signin, fontSize: 16)
            GeneralFunctions.buttonCustom_RTReg(buttonName: forgotPasswordBtn, fontSize: 14)
            GeneralFunctions.buttonCustom_RTReg(buttonName: btn_signUpNow, fontSize: 14)
            
            
        }
            
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTReg(labelName: rememberMeLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: logInWithLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: dontHaveLbl, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: signInStatic, fontSize: 13)
            GeneralFunctions.buttonCustom_LTBold(buttonName: btn_signin, fontSize: 16)
            GeneralFunctions.buttonCustom_LTReg(buttonName: forgotPasswordBtn, fontSize: 14)
            GeneralFunctions.buttonCustom_LTReg(buttonName: btn_signUpNow, fontSize: 14)
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
       
        
        
      let mycheck = UserDefaults.standard.object(forKey: "remeberValue") as? Int
        if(mycheck == 1 )
        {
            self.txt_userName.text = (UserDefaults.standard.object(forKey: "userEmail") as! String)
            self.txt_password.text = (UserDefaults.standard.object(forKey: "password") as! String)
            remembermeBtnCheckValue = 1
            btn_reminder.isChecked = true
            print(remembermeBtnCheckValue)

        }
        else
        {
            remembermeBtnCheckValue = 0
        }

    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        
       if language == "ar"
       {
         UIView.appearance().semanticContentAttribute = .forceRightToLeft
            self.txt_password.textAlignment = .right
            self.txt_userName.textAlignment = .right
        GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_password, strPlaceHolderName: languageChangeString(a_str: "Password") ?? "")
        GeneralFunctions.textPlaceholderText_RTLight(textFieldName: txt_userName, strPlaceHolderName: languageChangeString(a_str: "Email Address") ?? "")
        
        self.txt_userName.setPadding(left: -10, right: -10)
        self.txt_password.setPadding(left: -10, right: -10)
        self.txt_password.font = UIFont(name: "29LTBukra-Regular", size: 12)
        self.txt_userName.font = UIFont(name: "29LTBukra-Regular", size: 12)

         style = "29LTBukra-Regular"
        }
        else if language == "en"
       {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.txt_password.textAlignment = .left
        self.txt_userName.textAlignment = .left
        self.txt_userName.setPadding(left:10, right:10)
        self.txt_password.setPadding(left:10, right:10)
        GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_password, strPlaceHolderName: languageChangeString(a_str: "Password") ?? "")
        GeneralFunctions.textPlaceholderText_LTLight(textFieldName: txt_userName, strPlaceHolderName: languageChangeString(a_str: "Email Address") ?? "")

        self.txt_password.font = UIFont(name: "Poppins-Regular", size: 12)
        self.txt_userName.font = UIFont(name: "Poppins-Regular", size: 12)
         style = "Poppins-Regular"
        
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
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
        //self.tabBarController?.tabBar.isHidden = false
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
                        self.remembermeBtnCheckValue = 0
                        UserDefaults.standard.set(self.remembermeBtnCheckValue as Any, forKey: "remeberValue")
                        
                      
                        self.txt_userName.text = ""
                        self.txt_password.text = ""
                        
                        self.socialSignup(name: myname, email: myEmail, unique_id: myuserId,login_type : "google")
                    }
                }
                
            }
            
        }
        
    }
    
    //MARK:- Back BTN ACTION
    @IBAction func backBtnTap(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LanuchVideoVC") as! LanuchVideoVC
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func rememberBtnTap(_ sender: Any) {
        if btn_reminder.isChecked == true{
            
            remembermeBtnCheckValue = 0 // selected
            print(remembermeBtnCheckValue)
        }
        else
        {
            remembermeBtnCheckValue = 1 // NotSelected
            print(remembermeBtnCheckValue)
            
        }

    }
    
    
    //MARK:- signUp BTN ACTION
    @IBAction func signUpBtnTap(_ sender: UIButton)
    {

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- signIn BTN ACTION
    @IBAction func signinBtnTap(_ sender: UIButton)
    {
        
        if self.txt_password?.text == nil || self.txt_password?.text! == "" ||
            self.txt_userName.text == nil || self.txt_userName.text  == ""
        {
           
            showToastForAlert(message:languageChangeString(a_str:"Please Enter All Fields") ?? "", style: style)
            
            return
        }
        
        if(self.isValidEmail(testStr: self.txt_userName.text!) != true)
        {
            showToastForAlert(message:languageChangeString(a_str:"Please enter valid email") ?? "", style: style)
            
            return
        }
      
    
        if Reachability.isConnectedToNetwork()
        {
                MobileFixServices.sharedInstance.loader(view: self.view)
                let signIn = "\(base_path)services/login"
                //https://mrhoww.com/services/registration
            
           
                let parameters: Dictionary<String, Any> = [ "email":self.txt_userName.text! ,"password" : self.txt_password.text!, "device_name" : DEVICETYPE , "device_token" : DEVICE_TOKEN , "lang" :language,"api_key":APIKEY,"city":currentCity,"country":currentCountry,"imei":uuid]
                
                
                print("LoginUrl: \(signIn)")
                    print(parameters)
            Alamofire.request(signIn, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>
            {
                print(responseData)
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
            if status == 1
            {
                    if let userDetailsData = responseData["data"] as? Dictionary<String, AnyObject> {
                   
                    let userEmail = userDetailsData["email"] as? String?
                   // let userImg = userDetailsData["profile_pic"] as? String?
                        var image = ""
                        if let userImg = userDetailsData["profile_pic"] as? String
                        {
                            image = base_path+userImg
                        }
                        
                    let thumbUserImg = userDetailsData["pic_thumb"] as? String?
                    let userId = userDetailsData["user_id"] as? String?
                    print(self.remembermeBtnCheckValue)
                    UserDefaults.standard.set(self.remembermeBtnCheckValue as Any, forKey: "remeberValue")
                   //let userImage = String(format: "%@%@",base_path,userImg!!)
              UserDefaults.standard.set(self.txt_password.text! as Any, forKey: "password")
              UserDefaults.standard.set(userEmail as Any, forKey: "userEmail")
              UserDefaults.standard.set(userId as Any, forKey: USER_ID)
              UserDefaults.standard.set(image as Any, forKey: "userImage")
                                    
                // let x : String = userDetailsData["user_id"] as! String
                        
//                        if let thumbImg = thumbUserImg as? String
//                        {
//                            if let base_imag_url = responseData["base_url"] as? String
//                            {
//                                
//                                if let theProfileImageUrl = URL(string: base_imag_url + thumbImg) {
//                                    do {
//                                        let imageData = try Data(contentsOf: theProfileImageUrl as URL)
//                                        
//                                        UserDefaults.standard.set(imageData, forKey: "myimage")
//                                        
//                                        } catch {
//                                            
//                                        print("Unable to load data: \(error)")
//                                    }
//                                }
//                                
//                            }
//                        }
                  }
                DispatchQueue.main.async
                {
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
    
    
    
@IBAction func facebookLogin(sender: AnyObject) {

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
                                self.remembermeBtnCheckValue = 0
                                
                                UserDefaults.standard.set(self.remembermeBtnCheckValue as Any, forKey: "remeberValue")
                                
                                self.txt_userName.text = ""
                                self.txt_password.text = ""
                                
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
    

    let logout = GraphRequest(graphPath: "/me/permissions/", httpMethod:.delete)
    
    
    @IBAction func gmailAction(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
        else
        {
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style)
            //self.view.makeToast("Check Your conncetion")
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error?) {
        
    }
    
    @IBAction func passwordShowBtnTap(_sender:UIButton)
    {
        self.view.endEditing(true)

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

    
    @IBAction func forgotBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
 
    func customButtom(backGroundColor: UIColor, textColor : UIColor , fontName: String , fontSize:CGFloat){
        
        
        btn_signin.backgroundColor = AppMainColor
        btn_signin.setTitleColor(AppMainColor, for: .normal)
        btn_signin.layer.cornerRadius =  2.0
        btn_signin.layer.masksToBounds =  true
        
        btn_signin.titleLabel?.font = UIFont.init(name:fontName, size: fontSize)
        
    }
    
    
    //validate email
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func socialSignup(name: String , email : String , unique_id : String , login_type : String )  {
        print(name,email,unique_id)
        
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
           let signup = "\(base_path)services/social_login"
            //"https://volive.in/mrhow_dev/services/social_login"
            
         
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
    
    


}



extension UITextField {

    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }

        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }

}
