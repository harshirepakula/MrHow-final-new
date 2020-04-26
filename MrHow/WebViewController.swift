//
//  WebViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 6/27/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,UIWebViewDelegate,WKNavigationDelegate{

     var navigationChecking = String()
     var title1 = String()
    
    @IBOutlet weak var webPageView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        


        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if title1 == "Material"
        {
            navigationItem.hidesBackButton = true
            navigationItem.title = ""
            //navigationController?.navigationItem
        }
        
        if title1 == "Lessons"
        {
            navigationItem.hidesBackButton = true
            navigationItem.title = ""
            //navigationController?.navigationItem
        }
        if title1 == "downloads"
        {
            navigationItem.hidesBackButton = true
            navigationItem.title = ""
            //navigationController?.navigationItem
        }
        
        if title1 == "Trainer"
        {
            navigationItem.hidesBackButton = true
            navigationItem.title = ""
            
            //navigationController?.navigationItem
        }
        if title1 == "redirectPage"
        {
            navigationItem.hidesBackButton = true
            navigationItem.title = ""
            
            //navigationController?.navigationItem
        }
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        let myURLString = navigationChecking
        let url = NSURL(string: myURLString)
        let request = NSURLRequest(url: url! as URL)
        webPageView.navigationDelegate = self
        webPageView.load(request as URLRequest)

        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
     @IBAction func backBarBtnTap(_ sender: Any)
     {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    private func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    private func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("finish to load")
    }

   
}
