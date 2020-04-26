//
//  AppDelegate.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AVFoundation
import Photos
import AVKit
import UserNotifications
import MOLH


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {

    var window: UIWindow?
  
    var check = ""
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            let email = user.profile.email
            print("user id:",userId ?? "no user id came")
            print("idToken :",idToken!)
            print("fullName :",fullName!)
            print("givenName :",givenName!)
            print("email id:",email!)
            
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("gmail sign in error came",error)
    }

    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
       
        if url.scheme?.localizedCaseInsensitiveCompare("com.volive.mrhowApp") == .orderedSame {
            // Send notification to handle result in the view controller.
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "paymentVC"), object: nil)
            
             return true
            }
        
    let appId: String = Settings.appID
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
        
        let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        if isGoogleOpenUrl { return true }
        
        
        return false
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let googleSignIn = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return  googleSignIn
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       
        
        if #available(iOS 10, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
                
                if (granted)
                {
                    DispatchQueue.main.sync(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }else{
                    //Do stuff if unsuccessful...
                }
            }
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        
        GIDSignIn.sharedInstance().clientID = "249067079329-2osrt6umc0q7dj9okjpm83enbdp2uuls.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.shared.enable = true
        
       // MOLHLanguage.setDefaultLanguage("ar")
      //  MOLH.shared.activate(true)
        
        let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? "ar"
        if strLang == "en"
        {
             style2 = "Poppins-Regular"
            print("English Version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else if strLang == "ar"
        {    print("Arabic version")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            style2 = "29LTBukra-Regular"
        }
        
        
        Thread.sleep(forTimeInterval: 2.0)

        loginChecking()
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    
    
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
    
    
    //this method is for checking login
    func loginChecking() {

        if (UserDefaults.standard.object(forKey: USER_ID) as? String) != nil{
            //if user log in
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = stb.instantiateViewController(withIdentifier: "tabbar") as! TabBarControllerVC
            //let nav = tabBar.viewControllers?[1] as! UINavigationController
           // let studioVC = stb.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
            tabBar.selectedIndex = 1

            self.window?.rootViewController = tabBar
            self.window?.makeKeyAndVisible()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if continueInBackGround == "1"
        {
            playerViewcontroller.player = nil
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        if continueInBackGround == "1"
        {
        playerViewcontroller.player = player
        }
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
         UIApplication.shared.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
        //photoLibraryAvailabilityCheck()

    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceToken is:",deviceTokenString)
        DEVICE_TOKEN = deviceTokenString
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
    }
}

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate{
   
    @available(iOS 10.0, *)
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
        let userInfo = notification.request.content.userInfo as! Dictionary <String,Any>
        
         let aps = userInfo["aps"] as! Dictionary<String,Any>
          let badge = aps["badge"] as! Int
        
         print("will present data:",userInfo)
        

        
        
        //UIApplication.shared.applicationIconBadgeNumber = badge
        
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue)|UInt8(UNNotificationPresentationOptions.sound.rawValue))))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
    }
    
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
       
        let aps = userInfo["aps"] as! Dictionary<String,Any>
         let info = aps["info"] as! Dictionary<String,Any>
        let dicNotificationData = info as NSDictionary
        let badge = aps["badge"] as! Int
        
         UIApplication.shared.applicationIconBadgeNumber = badge
        
        if let type = dicNotificationData["type"] as? String
        {
 
        print(type)
        
        if type == "1"
        {

            
           
            //self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier:"tabbar") as! TabBarControllerVC
            let nav = initialViewController.viewControllers?[1] as! UINavigationController
            let studioVC = storyboard.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
           // let navigationController = UINavigationController(rootViewController: studioVC)
            nav.navigationBar.barTintColor = ThemeColor
            nav.navigationItem.titleView = UIImageView.init(image: UIImage.init(named: "HomeLogo"))
            initialViewController.selectedIndex = 1
            
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.window?.rootViewController = initialViewController
            
            self.window?.makeKeyAndVisible()
            
        }
        
        if type == "2"
        {
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier:"tabbar") as! TabBarControllerVC
            let nav = initialViewController.viewControllers?[1] as! UINavigationController
            
            nav.navigationBar.barTintColor = ThemeColor
            nav.navigationItem.titleView = UIImageView.init(image: UIImage.init(named: "HomeLogo"))
            initialViewController.selectedIndex = 1
           
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.window?.rootViewController = initialViewController
            
            self.window?.makeKeyAndVisible()
            
        }
        
        

        
        if type == "3"
        {
           let courseId = dicNotificationData["course_id"] as? String
    
            let storyboard = UIStoryboard(name:"Main", bundle: nil)
            let chatvc = storyboard.instantiateViewController(withIdentifier:"ViewDetailsVC") as! ViewDetailsVC
             chatvc.detailsCourseId = courseId ?? ""
             navigation1 = "home"
            let nav = UINavigationController.init(rootViewController: chatvc)
            
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
             completionHandler()

        }
            
            
        
        }
        
        
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSent"), object: nil)
        
    }
    
    
   
    
    
}
