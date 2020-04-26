//
//  OnBoardViewController.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 6/19/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class OnBoardViewController: UIViewController {
    
    @IBOutlet var pageCollectionView: UICollectionView!
    @IBOutlet var nextBtn: UIButton!
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var pageController: UIPageControl!
    //let Base_Path = "https://volive.in/mrhow_dev/"
    //"https://volive.in/mrhow_dev/"
    var myInt: Int = 0
    var myStr: String = ""
    var myFloat: Float = 1.22
    var myBols : Bool = true
    var imageView = UIImageView()
    var indexCell: Int = 0
    
    var idArray = [String]()
    var imagesArray = [String]()
    var headersArray = [String]()
    var textArray = [String]()
    var pagesData : [[String : AnyObject]]!
    
    var languageString : String! = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? ""
        
        if strLang == ""{
            
             UserDefaults.standard.set("ar", forKey: "currentLanguage")
        }
        print("strLang: \(strLang)")

      
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         skippingPagesServiceCall()
        self.navigationController?.isNavigationBarHidden = true
        self.skipBtn.setTitle(languageChangeString(a_str: "Skip"), for: UIControl.State.normal)
        self.nextBtn.setTitle(languageChangeString(a_str: "Next"), for: UIControl.State.normal)
        
        let strLang = UserDefaults.standard.object(forKey: "currentLanguage") as? String  ?? "ar"
        if strLang == "en"
        {
            print("English Version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            GeneralFunctions.buttonCustom_LTReg(buttonName: skipBtn, fontSize: 15)
            GeneralFunctions.buttonCustom_LTReg(buttonName: nextBtn, fontSize: 15)
        }
        else if strLang == "ar"
        {    print("Arabic version")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            GeneralFunctions.buttonCustom_RTReg(buttonName: skipBtn, fontSize: 15)
            GeneralFunctions.buttonCustom_RTReg(buttonName: nextBtn, fontSize: 15)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func imageSlideShow() {
        self.pageCollectionView.reloadData()
        self.pageController.numberOfPages = imagesArray.count
        self.startTimer()
    }
    
    func startTimer() {
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell(){
        
        let contentOffset = pageCollectionView.contentOffset;
        let cellSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        self.pageCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated : true)
        //self.pageController.currentPage = imagesArray.count
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        self.pageController.currentPage = page
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page: Int = lround(Double(fractionalPage))
        pageController.currentPage = page
        
        if page == self.textArray.count - 1{
           
            self.skipBtn.isHidden = true
           // self.nextBtn.setTitle("GET STARTED", for: .normal)
            self.nextBtn.setTitle(languageChangeString(a_str: "GET STARTED"), for: UIControl.State.normal)
            
            //self.pageController.isHidden = true
            
        }else{
           
            self.skipBtn.isHidden = false
             //self.nextBtn.setTitle("NEXT", for: .normal)
             self.nextBtn.setTitle(languageChangeString(a_str: "Next"), for: UIControl.State.normal)
            //self.pageController.isHidden = false
        }
        
        
    }
    
    @IBAction func startBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
        self.navigationController?.pushViewController(login!, animated: true)
    }
    
    //MARK:SKIPPING PAGES SERVICE CALL
    
    
    func skippingPagesServiceCall(){
       
        MobileFixServices.sharedInstance.loader(view: self.view)
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
        let skipping_pages = "\(base_path)services/home_screens?"
        
        //"https://volive.in/mrhow_dev/services/home_screens?api_key=1762019&lang=en"
         MobileFixServices.sharedInstance.dissMissLoader()
        let parameters: Dictionary<String, Any> = ["api_key" :APIKEY , "lang":language]
        
    Alamofire.request(skipping_pages, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
        
            if let responseData = response.result.value as? Dictionary<String, Any>{
              //print(responseData)
                
                let status = responseData["status"] as! Int
                MobileFixServices.sharedInstance.dissMissLoader()
                if status == 1
                {
                    self.idArray = [String]()
                    self.imagesArray = [String]()
                    self.headersArray = [String]()
                    self.textArray = [String]()
                    self.pagesData = responseData["data"] as? [[String:AnyObject]]
                    
                    for each in self.pagesData
                    {
                        
                        let image = String(format: "%@%@", base_path,each["image"] as! String)
                        let title = each["title"] as? String
                        let description = each["text"] as? String
                        
                        //self.idArray.append(id!)
                        self.imagesArray.append(image)
                        self.headersArray.append(title!)
                        self.textArray.append(description!)
                    }
                    DispatchQueue.main.async {
                        //self .imageSlideShow()
                        self.pageCollectionView.reloadData()
                        self.pageController.numberOfPages = self.imagesArray.count
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                       MobileFixServices.sharedInstance.dissMissLoader()
                        
                    }
                }
            }
        }
    }
    
    //MARK:- SKIP BTN ACTION
    @IBAction func skipBtnAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let login = storyBoard.instantiateViewController(withIdentifier: "LanuchVideoVC") as? LanuchVideoVC
        self.navigationController?.pushViewController(login!, animated: true)
    }
    
    //MARK:- NEXT BTN ACTION
    @IBAction func NextBtnAction(_ sender: Any) {
        let indexOfScrolledCell : NSInteger!
        
        indexOfScrolledCell = indexCell
        
        if indexCell < self.textArray.count - 1 {
            var path = IndexPath(row: indexOfScrolledCell + 1, section: 0)
            pageCollectionView.scrollToItem(at: path, at: .right, animated: true)
            pageController.currentPage = path.row
            
        }
        else
        {
            DispatchQueue.main.async {
           
        //self.nextBtn.setTitle("Get started", for: .normal)
                               // self.startTimer()
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanuchVideoVC") as! LanuchVideoVC
                
         self.navigationController?.pushViewController(vc, animated: true)
               
            }
        }
    }
}

extension OnBoardViewController:  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //page collection view delgates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pageCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? onBoardCollectionViewCell
        cell?.headerImageView.sd_setImage(with: URL (string:imagesArray[indexPath.row])) 
        cell?.headerLabel.text = self.headersArray[indexPath.row]
        cell?.subTitleLabel.text = self.textArray[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        print(self.pageCollectionView.frame.size.width)
        
        return CGSize(width: self.pageCollectionView.frame.size.width,height:  self.pageCollectionView.frame.size.height)
        
       
    }
   
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        indexCell = indexPath.index(after: indexPath.item - 1)
    }
    
}



