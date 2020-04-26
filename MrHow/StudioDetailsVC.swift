//
//  StudioDetailsVC.swift
//  MrHow
//
//  Created by volivesolutions on 21/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class StudioDetailsVC: UIViewController{
    
    @IBOutlet var studioTV: UITableView!
    @IBOutlet var txt_userName: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txt_userName.setBottomLineBorder()
        
        self.navigationController?.navigationBar.barTintColor = UIColor (red: 13.0/255.0, green: 205.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        if let aSize = UIFont(name: "Poppins-SemiBold", size: 16) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            print("font changed")
            
        }
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
       self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func postCommentBtnTap(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                try audioSession.setCategory(.playback, mode: .moviePlayback)
            } else {
                // Fallback on earlier versions
            }
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
    
    
    @IBAction func playVideo(_ sender: UIButton) {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        
        let vc = AVPlayerViewController()
        vc.player = player
        // Modally present the player and call the player's play() method when complete.
        present(vc, animated: true) {
            vc.player?.play()
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
