//
//  FilterVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class FilterVC: UIViewController,VPRangeSliderDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var ratingSt: UILabel!
    
    @IBOutlet weak var maxSt: UILabel!
    @IBOutlet weak var minSt: UILabel!
    @IBOutlet weak var applyFilterSt: UIButton!
    @IBOutlet weak var preiceLowSt: UILabel!
    @IBOutlet weak var priceHighSt: UILabel!
    @IBOutlet weak var popularitySt: UILabel!
    @IBOutlet weak var sortSt: UILabel!
    @IBOutlet weak var st1Star: UILabel!
    @IBOutlet weak var st2Star: UILabel!
    @IBOutlet weak var st3Star: UILabel!
    @IBOutlet weak var st4star: UILabel!
    @IBOutlet weak var star5St: UILabel!
    @IBOutlet weak var priceRangeSt: UILabel!
    @IBOutlet weak var subcatgeorySt: UILabel!
    @IBOutlet weak var catageorySt: UILabel!
    @IBOutlet weak var catageoriesTF: UITextField!
    @IBOutlet weak var subCatageoriesTF: UITextField!
    
    @IBOutlet weak var reset: UIBarButtonItem!
    @IBOutlet weak var languageTF: UITextField!
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var textfieldCheckValue : Int!
    
    
    //price
    var price_max = ""
    var price_min = ""
    
    //price
    var strMini         = String()
    var strMax          = String()
    
    var minRangeText:String!
    var maxRangeText:String!
    
    var maxLabelVal = CGFloat()
    var minLabelVal = CGFloat()
    
    var calCulatedMinLabelVal = CGFloat()
    var calCulatedMaxLabelVal = CGFloat()
     var myIntValue1 = CGFloat()
    var myValue2 = CGFloat()
    
    //instance for singleton
    let singleTonClass  = Singleton.shared
    
    @IBOutlet weak var vrRangeSlider: VPRangeSlider!
    
    var maxPrice:Int!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var popularity: UIButton!
    @IBOutlet weak var lowToHigh: UIButton!
    @IBOutlet weak var highToLow: UIButton!
    
    var category_idArray = [String]()
    var categoryNameArray = [String]()
    var catIconArray = [String]()
    var catString : String! = ""
    var catIdString : String! = ""
    
    
    
    var subCategory_idArray = [String]()
    var subCategoryNameArray = [String]()
    var subCatString : String! = ""
    var subCatIdString : String! = ""
    
    // for button selections
    var selectedStarRating = ""
    var sortBy = ""
    
    var languageArray = [String]()
    var selectedLanguage : String = ""
 
    var fontStyle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "Filters")
            print("font changed")
            
        }
        
        languageArray = ["English","Arabic"]
        catageoriesTF.delegate = self
        subCatageoriesTF.delegate = self
        //languageTF.delegate = self
        
        strMax = ""
        strMini = ""
        

        self.catageorySt.text = languageChangeString(a_str: "Category")
        self.subcatgeorySt.text = languageChangeString(a_str: "Subcategories")
        self.priceRangeSt.text = languageChangeString(a_str: "Price Range")
        self.minSt.text = languageChangeString(a_str: "Min")
        self.maxSt.text = languageChangeString(a_str: "Max")
        self.ratingSt.text = languageChangeString(a_str: "Ratings")
        self.sortSt.text = languageChangeString(a_str: "Sort By")
        self.popularitySt.text = languageChangeString(a_str: "Popularity")
        self.priceHighSt.text = languageChangeString(a_str: "Price from high to low")
        self.preiceLowSt.text = languageChangeString(a_str: "Price from low to high")
        self.star5St.text = languageChangeString(a_str: "5 Rating")
        self.st4star.text = languageChangeString(a_str: "4 & UP")
        self.st3Star.text = languageChangeString(a_str: "3 & UP")
        self.st2Star.text = languageChangeString(a_str: "2 & UP")
        self.st1Star.text = languageChangeString(a_str: "1 & UP")
        self.reset.title = languageChangeString(a_str: "Reset")
        
        self.applyFilterSt.setTitle(languageChangeString(a_str: "Apply Filter"), for: UIControl.State.normal)
        
        
        
       
       if language == "ar"{
            self.catageoriesTF.textAlignment = .right
            self.subCatageoriesTF.textAlignment = .right
        
        GeneralFunctions.labelCustom_RTReg(labelName: catageorySt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName: subcatgeorySt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName: priceRangeSt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName: star5St, fontSize: 11)
        GeneralFunctions.labelCustom_RTReg(labelName:st4star, fontSize: 11)
        GeneralFunctions.labelCustom_RTReg(labelName: st3Star, fontSize: 11)
        GeneralFunctions.labelCustom_RTReg(labelName:st2Star, fontSize: 11)
        GeneralFunctions.labelCustom_RTReg(labelName: st1Star, fontSize: 11)
        GeneralFunctions.labelCustom_RTReg(labelName:sortSt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName:popularitySt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName:priceHighSt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName:preiceLowSt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName:minSt, fontSize: 14)
        GeneralFunctions.labelCustom_RTReg(labelName:maxSt, fontSize: 14)
        GeneralFunctions.buttonCustom_RTReg(buttonName: applyFilterSt, fontSize: 19)
        reset.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "29LTBukra-Regular", size: 16) ?? 10], for: UIControl.State.normal)
       
       }
        else if language == "en"{
            self.catageoriesTF.textAlignment = .left
            self.subCatageoriesTF.textAlignment = .left
        
        GeneralFunctions.labelCustom_LTReg(labelName: catageorySt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName: subcatgeorySt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName: priceRangeSt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName: star5St, fontSize: 11)
        GeneralFunctions.labelCustom_LTReg(labelName:st4star, fontSize: 11)
        GeneralFunctions.labelCustom_LTReg(labelName: st3Star, fontSize: 11)
        GeneralFunctions.labelCustom_LTReg(labelName:st2Star, fontSize: 11)
        GeneralFunctions.labelCustom_LTReg(labelName: st1Star, fontSize: 11)
        GeneralFunctions.labelCustom_LTReg(labelName:sortSt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName:popularitySt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName:priceHighSt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName:preiceLowSt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName:minSt, fontSize: 14)
        GeneralFunctions.labelCustom_LTReg(labelName:maxSt, fontSize: 14)
        GeneralFunctions.buttonCustom_LTMedium(buttonName: applyFilterSt, fontSize: 19)
        
        reset.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16) ?? 10], for: UIControl.State.normal)
        }
        
    
        
        // Do any additional setup after loading the view.
   
    }
    
    
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
         priceRangeData()

//
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    // catageories service call
    
    
   func catageoriesData()
   {
        if Reachability.isConnectedToNetwork()
       {
                MobileFixServices.sharedInstance.loader(view: self.view)
            // languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
    
            let catageories = "\(base_path)services/categories_list?"
    
          //https://volive.in/mrhow_dev/services/categories_list?api_key=1762019&lang=en
 
          let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language ]
    
          Alamofire.request(catageories, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
    
              if let responseData = response.result.value as? Dictionary<String, Any>
              {
                   //print(responseData)
                   let status = responseData["status"] as? Int
                   let message = responseData["message"] as? String
                   if status == 1
                   {
                       if let response1 = responseData["data"] as? [[String:Any]]
                      {
                             if (self.categoryNameArray.count > 0) ||
                                (self.catIconArray.count > 0) ||
                                (self.category_idArray.count > 0)
                              {
                                  self.categoryNameArray.removeAll()
                                  self.category_idArray.removeAll()
                                  self.catIconArray.removeAll()
                            }
            
                           //MobileFixServices.sharedInstance.dissMissLoader()
                             for i in 0..<response1.count
                            {
                               if let imgCover = response1[i]["icon"] as? String
                                {
                                    self.catIconArray.append(base_path+imgCover)
                    
                                  }
                               if let name = response1[i]["category_name"] as? String
                               {
                                     self.categoryNameArray.append(name)
                                }
                             if let cat_id = response1[i]["category_id"] as? String
                             {
                                    self.category_idArray.append(cat_id)
                    
                              }
               
                            }
                      DispatchQueue.main.async {
                
                           MobileFixServices.sharedInstance.dissMissLoader()
                          self.pickerView?.reloadAllComponents()
                          self.pickerView?.reloadInputViews()
                
                          }
                      }
               }
              else{
                        DispatchQueue.main.async
                        {
                           MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message ?? "",style: style1)
        
                  }
               }
           }
         }
     }
      else{
        MobileFixServices.sharedInstance.dissMissLoader()
        showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
        
    }
}
    
    
    // subCatageories service call
    func subCatageoriesData()
    {
        
        if Reachability.isConnectedToNetwork()
        {
        MobileFixServices.sharedInstance.loader(view: self.view)
        // languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
        
        let sub_catageories = "\(base_path)services/sub_categories_list?"
        print(catIdString)
        //https://volive.in/mrhow_dev/services/sub_categories_list?api_key=1762019&lang=en&category_id=1
      
            
        let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language,"category_id":catIdString! ]
        
        Alamofire.request(sub_catageories, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            if let responseData = response.result.value as? Dictionary<String, Any>{
                print(responseData)
               // MobileFixServices.sharedInstance.dissMissLoader()
                let status = responseData["status"] as! Int
                let message = responseData["message"] as! String
                if status == 1
                {
                    if let response1 = responseData["data"] as? [[String:Any]]
                    {
                        if (self.subCategory_idArray.count > 0) ||
                            (self.subCategoryNameArray.count > 0)

                        {
                            self.subCategory_idArray.removeAll()
                            self.subCategoryNameArray.removeAll()

                        }
                        for i in 0..<response1.count
                        {
                            
                            if let name = response1[i]["sub_category_name_en"] as? String
                            {
                                self.subCategoryNameArray.append(name)
                            }
                            if let subCat_id = response1[i]["sub_category_id"] as? String
                            {
                                self.subCategory_idArray.append(subCat_id)
                                
                            }
                            
                           
                            
                        }
                        DispatchQueue.main.async {
                             print(self.subCategoryNameArray)
                            MobileFixServices.sharedInstance.dissMissLoader()
                            if self.subCategoryNameArray.count > 0
                            {
                            
                            self.pickerView?.reloadAllComponents()
                            self.pickerView?.reloadInputViews()
                                
                            }
                           
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                       MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                        
                    }
                }
            }
         }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
           showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            
        }
    
    }
    
    
    // price range service call
    
    func priceRangeData(){
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            // languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let price = "\(base_path)services/price_range?"
            
            //https://volive.in/mrhow_dev/services/price_range?api_key=1762019&lang=en
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language]
            
            Alamofire.request(price, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        if let response1 = responseData["data"] as? [String:Any]
                        {
                             if let max = response1["max"] as? String
                                {
                                    self.price_max = max
                                }
                                if let min = response1["min"] as? String
                                {
                                    self.price_min = min
                                }
                            DispatchQueue.main.async
                            {
                               

                                self.vrRangeSlider.delegate = self
                                
                                self.vrRangeSlider.layoutSubviews()
                                self.vrRangeSlider.layoutIfNeeded()
                            
                            }
                           
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message, style: style1)
                            
                        }
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.singleTonClass.isFilterApplied = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func restBarBtnTap(_ sender: Any)
    {
        //filter = true
        singleTonClass.isFilterApplied = false

    
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterBtnTap(_ sender: Any)
    {
        
         myfilterPostMethod()
        
    }
    
    @IBAction func button1Acton(_ sender: Any)
    {
    
        star1.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "1"
    }
    
    @IBAction func button2Acton(_ sender: Any)
    {
        star2.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "2"
    }
    
    @IBAction func button3(_ sender: Any) {
        
        star3.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
         selectedStarRating = "3"
    }

    @IBAction func button4(_ sender: Any) {
        
        star4.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star5.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "4"
    }
    
    
    @IBAction func button5(_ sender: Any) {
        
        star5.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        star1.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star2.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star3.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        star4.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        selectedStarRating = "5"
    }
    
    @IBAction func popularityBtnTap(_ sender: Any) {
        
        popularity.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        highToLow.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        lowToHigh.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "1"
        
    }
    
    
    @IBAction func lowToHighBtnTap(_ sender: Any) {
        lowToHigh.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        highToLow.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        popularity.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "2"
        
    }
    
    @IBAction func highToLowBtnTap(_ sender: Any) {
        
        highToLow.setImage(UIImage(named: "radio checked"), for: UIControl.State.normal)
        popularity.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        lowToHigh.setImage(UIImage(named: "radio"), for: UIControl.State.normal)
        sortBy = "3"
        
    }
    

    func sliderScrolling(_ slider: VPRangeSlider!, withMinPercent minPercent: CGFloat, andMaxPercent maxPercent: CGFloat)
    {
       // print("delegate call")
        
        //print(maxRangeText)
        
        let sliderMin = Int(price_min)
        let sliderMax = Int(price_max)
       
          maxLabelVal = CGFloat(sliderMax ?? 0)
          minLabelVal = CGFloat(sliderMin ?? 0)
       
       // print(maxPercent)
        
        myIntValue1 = minPercent
        myValue2 = maxPercent
        
        
         calCulatedMinLabelVal = (myIntValue1/100) * (maxLabelVal-minLabelVal) + minLabelVal
        print(minPercent)
        calCulatedMaxLabelVal = (myValue2/100) * (maxLabelVal-minLabelVal) + minLabelVal
        
        if (String(format: "%.0f", calCulatedMinLabelVal) == "0.0") {
            
            vrRangeSlider.minRangeText = price_min
             self.strMini = vrRangeSlider.minRangeText
            print(self.strMini)
            
        } else {
            
            vrRangeSlider.minRangeText = String(format: "%.0f", calCulatedMinLabelVal)
            
            self.strMini = vrRangeSlider.minRangeText
            print(self.strMini)
            print("slider minimum \(String(describing: vrRangeSlider.minRangeText))")
            
        }
        
        vrRangeSlider.maxRangeText = String(format: "%.0f", calCulatedMaxLabelVal)
        
        self.strMax = vrRangeSlider.maxRangeText
        print(self.strMax)
        print("slider maximum \(String(describing: vrRangeSlider.maxRangeText))")
        
       
    
        

    }
    
    
    // filter post method to send data
    
    func myfilterPostMethod()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let filter = "\(base_path)services/courses_list"
            
            //"https://volive.in/mrhow_dev/services/courses_list"
            // let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            print(catIdString!)
            print(subCatIdString!)
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let parameters: Dictionary<String, Any> = ["category_id" : catIdString ?? "",
                                                        "sub_category_id" : subCatIdString ?? "" ,
                                                        "lang" : language,
                                                        "api_key":APIKEY,
                                                        "price_from":self.strMini,
                                                        "price_to":self.strMax,
                                                        "ratings":selectedStarRating,
                                                        "sort_by":sortBy
                                                        ]
            
            print(parameters)
            
            Alamofire.request(filter, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {

                        
                        self.singleTonClass.isFilterApplied = true
                        if let myfilter = responseData["data"] as? [[String:Any]]{
                            self.singleTonClass.myfilterData = myfilter
                        }
                        
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                    
                        self.showToastForAlert(message: message, style: style1)
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
        }
        
    }
    
    
    //   MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str:"Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func donePickerView(){
        
        print(textfieldCheckValue)
        if textfieldCheckValue == 1{
          
            self.catString = categoryNameArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
            self.catageoriesTF.text = self.catString
            
            catIdString = category_idArray[(pickerView?.selectedRow(inComponent: 0)) ?? 0]
            if catString.count > 0{
                self.catageoriesTF.text = self.catString ?? ""
            }else{
                self.catageoriesTF.text = categoryNameArray[0]
            }
            
            
            self.view.endEditing(true)
            catageoriesTF.resignFirstResponder()
            
        }

            
        else if textfieldCheckValue == 3{

            if subCategoryNameArray.count > 0
            {
            self.subCatString = subCategoryNameArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
            self.subCatageoriesTF.text = self.subCatString

            subCatIdString = subCategory_idArray[(pickerView?.selectedRow(inComponent: 0) ?? 0)]
            if subCatString.count > 0{
                self.subCatageoriesTF.text = self.subCatString ?? ""
            }else{
                self.subCatageoriesTF.text = subCategoryNameArray[0]
            }
            self.view.endEditing(true)
            subCatageoriesTF.resignFirstResponder()
            print("subcatageory done")
            }
        }
    }
    
    @objc func cancelPickerView(){
        
        if textfieldCheckValue == 1{
            if (catageoriesTF.text?.count)! > 0 {
                self.view.endEditing(true)
                catageoriesTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                catageoriesTF.text = ""
                catageoriesTF.resignFirstResponder()
            }
            catageoriesTF.resignFirstResponder()
        }
            

            
            
        else{

            if (subCatageoriesTF.text?.count)! > 0 {
                self.view.endEditing(true)
                subCatageoriesTF.resignFirstResponder()
            }else{
                self.view.endEditing(true)
                subCatageoriesTF.text = ""
                subCatageoriesTF.resignFirstResponder()
            }
            subCatageoriesTF.resignFirstResponder()

            print("subcatageory cancel")
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == self.catageoriesTF)
        {
            textfieldCheckValue = 1
            catageoriesData()
            self.subCatageoriesTF.text = ""
            self.pickUp(self.catageoriesTF)
        }
        else if (textField == subCatageoriesTF) {
           textfieldCheckValue = 3
            if catIdString == ""{
                showToastForAlert (message: languageChangeString(a_str: "Please Select Category")!, style: style1)
                //self.showToastForAlert(message:"Select Catageory")
                self.subCatageoriesTF.resignFirstResponder()
            }
            else{
                subCatageoriesData()
             self.pickUp(self.subCatageoriesTF)
                
            }


        }

        
        
    }
    
}
extension FilterVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
       
        
        if (textfieldCheckValue == 1) {
            
            return categoryNameArray.count
        }
        if (textfieldCheckValue == 2) {
            
            return languageArray.count
        }
            
        else {

            return subCategoryNameArray.count
        }
     
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        
        
        if (textfieldCheckValue == 1)
        {
            
            return categoryNameArray[row]
        }
        if (textfieldCheckValue == 2)
        {
            
            return languageArray[row]
        }
            
        else
        {
            return subCategoryNameArray[row]
        }
        
     
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (textfieldCheckValue == 1)
        {
            
            self.catageoriesTF.text =  categoryNameArray[row]
            self.catString = categoryNameArray[row]
            catIdString = category_idArray[row]
            
            
        }

        
        if textfieldCheckValue == 3
        {
            subCatageoriesTF.text =  subCategoryNameArray[row]
            self.subCatString = subCategoryNameArray[row]
            subCatIdString = subCategory_idArray[row]

        }
    }
}
