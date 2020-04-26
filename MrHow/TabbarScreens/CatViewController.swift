//
//  CatViewController.swift
//  MrHow
//
//  Created by harshitha on 12/09/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class CatViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var catCollection: UICollectionView!
    
    
    var moreImageArray = NSMutableArray()
    var moreCoverTypeArray = NSMutableArray()
    var moreThumbnailArray = NSMutableArray()
    
   
    //var arrGetCourseList: NSArray!
    
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        
        self.navigationController?.navigationBar.barTintColor = ThemeColor
       
        if let aSize = UIFont(name: fontStyle, size: 18) {
            
            
             self.navigationItem.title = languageChangeString(a_str: "Traines Projects")
            
            
           
            catCollection.reloadData()
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            }
       
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
       
        self.tabBarController?.tabBar.isHidden = false
    }
   
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return moreImageArray.count
            
            //arrGetCourseList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat2", for: indexPath) as! CustomCollectionViewCell

        
        
        if moreCoverTypeArray[indexPath.row] as? String == "image"
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.moreImageArray[indexPath.row] as? String ?? ""))
            
        }
        else
        {
            cell.imageview_banner.sd_setImage(with: URL (string:self.moreThumbnailArray[indexPath.row] as? String ?? ""))
        }

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = catCollection.bounds.width/3.2
        print(yourWidth)
        print(catCollection.bounds.width/3.3)
        
        return CGSize(width: yourWidth, height: catCollection.bounds.width/3.3)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    
    
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrainesProjectsVC") as! TrainesProjectsVC
        
        if moreCoverTypeArray[indexPath.row] as? String == "image"
        {
            vc.imageToShow = self.moreImageArray[indexPath.row] as? String ?? ""
          
        }
        else
        {
            vc.imageToShow = (self.moreThumbnailArray[indexPath.row] as? String) ?? ""
            
        }
       
       
        self.navigationController?.pushViewController(vc, animated: true)
    
        }
    
 
}
