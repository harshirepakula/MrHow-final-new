//
//  LanuchVideoVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AVKit
import MOLH

var style2 = ""

class LanuchVideoVC: UIViewController {
    
   
    @IBOutlet weak var changeLang: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var playerImg: UIImageView!
    
    var urlOfVideo = String()
    var imageOrVideo = String()
    
   // var playerItem:AVPlayerItem?
    var player : AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
      
        
        if let aSize = UIFont(name: "Poppins-SemiBold", size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            print("font changed")
            
        }
        
        //playingVideo()
     
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)

        //https://stackoverflow.com/questions/25932570/how-to-play-video-with-avplayerviewcontroller-avkit-in-swift
        
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
       playingVideo()
        
        let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? "ar"
      
        if strLang == "en"
        {
            print("English Version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            GeneralFunctions.buttonCustom_LTBold(buttonName: signInBtn, fontSize: 15)
            GeneralFunctions.buttonCustom_LTBold(buttonName: signUpBtn, fontSize: 15)
            style2 = "Poppins-Regular"
        }
        else if strLang == "ar"
        {    print("Arabic version")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            GeneralFunctions.buttonCustom_RTBold(buttonName: signInBtn, fontSize: 15)
            GeneralFunctions.buttonCustom_RTBold(buttonName: signUpBtn, fontSize: 15)
            style2 = "29LTBukra-Regular"
        }

      
        
        
        //player.play()
        self.navigationController?.navigationBar.isHidden = true
        
        self.signInBtn.setTitle(languageChangeString(a_str: "SIGN IN"), for: UIControl.State.normal)
        self.signUpBtn.setTitle(languageChangeString(a_str: "SIGN UP"), for: UIControl.State.normal)
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        //        player?.pause()
        //        player?.replaceCurrentItem(with: nil)
        //        player = nil
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func videoDisplaying(url_path:String)
    {
        let path = base_path+url_path

        if let url : URL = URL(string:path)
        {
         player = AVPlayer(url: url)
         let playerLayer = AVPlayerLayer(player: player)
         playerLayer.frame = self.view.bounds
         self.playerImg.layer.addSublayer(playerLayer)
            player?.play()
        }
       
    }
    
    @IBAction func changeLangBtnTap(_ sender: Any) {
        
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           let englishAction: UIAlertAction = UIAlertAction(title: "English", style: .default) { action -> Void in

            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
                //MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "en" : "en")
                MOLH.reset(transition: .transitionCrossDissolve)
            
            UserDefaults.standard.set(ENGLISH_LANGUAGE, forKey: "currentLanguage")
            self.viewWillAppear(true)
            self.view.layoutIfNeeded()
            
           // self.navigationController?.popViewController(animated: true)
            }

            let arabicAction: UIAlertAction = UIAlertAction(title: "العربية", style: .default) { action -> Void in

                 MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
                //MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "ar" ? "ar" : "ar")
               MOLH.reset(transition: .transitionCrossDissolve)
              
               UserDefaults.standard.set(ARABIC_LANGUAGE, forKey: "currentLanguage")
                self.viewWillAppear(true)
                 self.view.layoutIfNeeded()
                

            }
            let cancelAction: UIAlertAction = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { action -> Void in }

            actionSheetController.addAction(englishAction)
            actionSheetController.addAction(arabicAction)
            actionSheetController.addAction(cancelAction)
            // present an actionSheet...


            present(actionSheetController, animated: true, completion: nil)
       

//
      }
    
    
    
    
    
    
    func playingVideo()
    {
        if Reachability.isConnectedToNetwork()
        {
        let playVideo = "\(base_path)services/welcome_video?"
       // "https://volive.in/mrhow_dev/services/welcome_video?api_key=1762019&lang=en"
        
        MobileFixServices.sharedInstance.loader(view: self.view)
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
        let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language]
        
        Alamofire.request(playVideo, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
              
                
                let status = responseData["status"] as! Int
                //let message = responseData["message"] as! String
                if status == 1
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                   if let videoLink = responseData["data"] as? [String:String]
                   {
                    if let url = videoLink["video"]
                    {
                         self.urlOfVideo = url
                    }
                    self.imageOrVideo = videoLink["type"] ?? ""
                   
                    if self.imageOrVideo == "video"
                    {
                     self.videoDisplaying(url_path:self.urlOfVideo)
                     
                    }
                   
                    if self.imageOrVideo == "image"
                    {
                        DispatchQueue.main.async {
                            self.urlOfVideo = base_path+self.urlOfVideo
                              self.playerImg.sd_setImage(with: URL (string:self.urlOfVideo))
                        }
                       
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
        else{
            
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style2)
        }
}
    
   

    
    
    @IBAction func signInTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}

extension String{
    func strikeThrough()->NSAttributedString{
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
extension UILabel{
    
    func makeOutLine(oulineColor: UIColor, foregroundColor: UIColor){
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : oulineColor,
            NSAttributedString.Key.foregroundColor : foregroundColor,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : self.font
            ] as [NSAttributedString.Key : Any]
        self.attributedText = NSMutableAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
    }
    
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString);   attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
