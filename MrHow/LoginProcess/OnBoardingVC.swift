//
//  OnBoardingVC.swift
//  MrHow
//
//  Created by volivesolutions on 20/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire


class OnBoardingVC: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var collectionViewList: UICollectionView!
    @IBOutlet var btn_next: UIButton!
    @IBOutlet var btn_skip: UIButton!
    @IBOutlet var pageController: UIPageControl!
    let Base_Path = "https://volive.in/mrhow_dev/"
    

    var idArray = [String]()
    var imagesArray = [String]()
    var headersArray = [String]()
    var textArray = [String]()
    var pagesData : [[String : String]]!
    
    
    var myInt: Int = 0
    var myStr: String = ""
    var myFloat: Float = 1.22
    var myBols : Bool = true
    var imageView = UIImageView()
    var indexCell: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
       // self.imageSlideShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        skippingPagesServiceCall()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    func imageSlideShow() {
        
        self.collectionViewList.reloadData()
       
        self.pageController.numberOfPages = imagesArray.count
        //self.startTimer()
        
        
    }
    func startTimer() {
        
        
        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        
        
    }
    func skippingPagesServiceCall(){
        
       // languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        MobileFixServices.sharedInstance.loader(view: self.view)
        //SingletonClass.sharedInstance.loader(view: self.view)
        let skipping_pages = "https://volive.in/mrhow_dev/services/home_screens?api_key=1762019&lang=en"
        
      //  let parameters: Dictionary<String, Any> = [ "API-KEY" :APIKEY , "lang": languageString! ]
        
//        print(parameters)
        
        Alamofire.request(skipping_pages, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                //print(responseData)
                
                let status = responseData["status"] as! Int
                //let message = responseData["message"] as! String
                if status == 1
                {
                    self.idArray = [String]()
                    self.imagesArray = [String]()
                    self.headersArray = [String]()
                    self.textArray = [String]()
                    
                     MobileFixServices.sharedInstance.dissMissLoader()
                    self.pagesData = responseData["data"] as? [[String:String]]
                    
                    for each in self.pagesData
                    {
                       // let id = each["id"] as? String
                        let image = String(format: "%@%@", self.Base_Path,each["image"]!)
                        
                        let title = each["title"]
                        let description = each["text"]
                        
                        //self.idArray.append(id!)
                        self.imagesArray.append(image)
                        self.headersArray.append(title!)
                        self.textArray.append(description!)
                    }
                    print(self.imagesArray)
                    DispatchQueue.main.async {
                       
                        self.collectionViewList.reloadData()
                        self.pageController.numberOfPages = self.imagesArray.count
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        
                          MobileFixServices.sharedInstance.dissMissLoader()
                        //SingletonClass.sharedInstance.dissMissLoader()
                    }
                }
            }
        }
    }
    
    
    
    
    @objc func scrollToNextCell(){
        
        let contentOffset = collectionViewList.contentOffset;
        let cellSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        self.collectionViewList.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated : true)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        self.pageController.currentPage = page
        
    }
    
     //MARK:- SKIP BTN ACTION
    @IBAction func skipBtnTap(_ sender: UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanuchVideoVC") as! LanuchVideoVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page: Int = lround(Double(fractionalPage))
        pageController.currentPage = page
    
    }
    
    //MARK:- NEXT BTN ACTION
    @IBAction func NextBtnAction(_ sender: UIButton) {
        let indexOfScrolledCell : NSInteger!
        
        indexOfScrolledCell = indexCell
        
        print(indexCell)
        
        if indexCell < 3 {
            var path = IndexPath(row: indexOfScrolledCell + 1, section: 0)
            collectionViewList.scrollToItem(at: path, at: .right, animated: true)
            pageController.currentPage = path.row
            
        }else
        {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    
     // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewList.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? onBoardCollectionViewCell
        
        cell?.headerImageView.sd_setImage(with: URL(string:imagesArray[indexPath.row]))
                                          
        //,placeholderImage: UIImage(named: "Group1"))
    
        cell?.headerImageView.image = UIImage.init(named: imagesArray[indexPath.row])
        cell?.headerLabel.text = self.headersArray[indexPath.row]
        cell?.subTitleLabel.text = self.textArray[indexPath.row]
        
       
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width: self.collectionViewList.frame.size.width,height:  self.collectionViewList.frame.size.height)
        
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        indexCell = indexPath.index(after: indexPath.item - 1)
        
        
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
