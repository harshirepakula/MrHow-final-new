//
//  VerificationVC.swift
//  MrHow
//
//  Created by volivesolutions on 20/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class VerificationVC: UIViewController {
    
    
    @IBOutlet var txt_otp1: UITextField!
    @IBOutlet var txt_otp2: UITextField!
    @IBOutlet var txt_otp3: UITextField!
    @IBOutlet var txt_otp4: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        txt_otp1.setBottomLineBorder()
         txt_otp2.setBottomLineBorder()
         txt_otp3.setBottomLineBorder()
         txt_otp4.setBottomLineBorder()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Back Button
    
    @IBAction func backBtnTap(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func verfiyBtnTap(_ sender: UIButton)
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
    
    
    @IBAction func skipNowBtnTap(_ sender: UIButton)
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
    

}
