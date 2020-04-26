//
//  RatingViewController.swift
//  MrHow
//
//  Created by harshitha on 12/09/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class RatingViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var txtView_comment: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    var topic_Id = ""
    var appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtView_comment.delegate = self
        
     
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
      
        
        txtView_comment.text = languageChangeString(a_str:"Please Write Your Comment")
        self.sendBtn.setTitle(languageChangeString(a_str: "Send"), for: UIControl.State.normal)
        self.cancelBtn.setTitle(languageChangeString(a_str: "Cancel"), for: UIControl.State.normal)
        
        
        
        if language == "ar"
        {
            self.txtView_comment.textAlignment = .right
            GeneralFunctions.buttonCustom_RTReg(buttonName: sendBtn, fontSize: 18)
            GeneralFunctions.buttonCustom_RTReg(buttonName: cancelBtn, fontSize: 18)
            txtView_comment.font = UIFont(name: "29LTBukra-Regular", size: 12)
            
            
        }
        else if language == "en"{
            
            self.txtView_comment.textAlignment = .left
            GeneralFunctions.buttonCustom_LTReg(buttonName: sendBtn, fontSize: 18)
            GeneralFunctions.buttonCustom_LTReg(buttonName: cancelBtn, fontSize: 18)
            txtView_comment.font = UIFont(name: "Poppins-Regular", size: 12)
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    // Dismiss View
    @objc fileprivate func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if txtView_comment.text == languageChangeString(a_str:"Please Write Your Comment")
        {
            txtView_comment.text = ""
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        
        
        if txtView_comment.text == ""{
            
            txtView_comment.text = languageChangeString(a_str:"Please Write Your Comment")
        }
        
        return true
    }
    
    
    @IBAction func btn_Submit_Click(_ sender: UIButton) {
        
        print(topic_Id)
   

        if (!(txtView_comment.text == "") && !(txtView_comment.text == languageChangeString(a_str:"Please Write Your Comment"))){
            
            // reply comment service call
            //let comment_txt = txtView_comment.text
            
            replyComment()
            txtView_comment.text = ""
            
        }else{
            
            self.showToastForAlert(message: languageChangeString(a_str:"Please Write Your Comment")!,style: style1)
            
        }
        
        
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                self.dismiss(animated: true, completion: nil)
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    //reply post service call
    
    func replyComment(){
        
        let bool = Reachability.isConnectedToNetwork()
        
        if (bool == false) {
            
            print("NO InterNet")
            
            DispatchQueue.main.async(execute: {
                
                self.showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
             
                
            })
            
        }else{
            
            MobileFixServices.sharedInstance.loader(view: self.view)
             let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = [
                "lang" : language,
                "api_key":APIKEY,
                "user_id":myuserID,
                "course_id":topic_Id,
                "comment":txtView_comment.text ?? ""
               
            ]
            
           // https://www.volive.in/mrhow_dev/services/submit_course_enquiry
            let url = "\(base_path)services/submit_course_enquiry"
            //"https://www.volive.in/mrhow_dev/services/submit_course_enquiry"
            print(url)
            print(parameters)
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                guard let responseData = response.result.value as? Dictionary<String, Any>else{
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    self.showToastForAlert(message: languageChangeString(a_str:"server is busy,please try again")!, style: style1)
                    
                    return
                }
                
                
                // MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                print("Response Data is :\(responseData)")
                
                let status = responseData["status"] as? Int?
                
                if(status == 1)
                {
                    MobileFixServices.sharedInstance.dissMissLoader()
                    
                    
                    let strServerMessage =  responseData["message"] as! String
                    
                    self.showToastForAlert(message: strServerMessage, style: style1)
                   
                    NotificationCenter.default.post(name: NSNotification.Name("comment"), object: nil)
                    
                  self.dismiss(animated: true, completion: nil)
                    
                }
                    
                else{
                    DispatchQueue.main.async {
                        
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        self.showToastForAlert(message: responseData["message"] as? String ?? "", style: style1)
                        
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func cancelBtnTap(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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


    

