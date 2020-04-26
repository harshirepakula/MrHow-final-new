//
//  expandViewController.swift
//  MrHow
//
//  Created by Kartheek Repakula on 07/04/20.
//  Copyright © 2020 volivesolutions. All rights reserved.
//

import UIKit

class expandViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var faqTV: UITableView!
    
   var isFirstTimeClicked = false
      var openOrCloseArray = [Int]()
    
    var sectionTitles = [String]()
    var sectionInsideData = [[String]]()
    var hidden:[Bool] = [Bool]()
   
    var fontStyle = ""

    var tableData = [cellData1]()
    
   

    override func viewDidLoad()
    {
        
         let questionData = cellData1(open: false, labelData: ["label3"], header: "cellOpen", imageName: "Faq_1-1")
            
        
        self.tableData.append(questionData)
        
        let questionData2 = cellData1(open: false, labelData: ["label2"], header: "cellOpen2", imageName: "Faq_1-1")
                   
               
               self.tableData.append(questionData2)
        
    }
    
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        
       // frequentlyAskedQuestions()
        
        faqTV.sectionHeaderHeight = UITableView.automaticDimension
        faqTV.estimatedSectionHeaderHeight = 60;
        
        self.faqTV.rowHeight = UITableView.automaticDimension
        self.faqTV.estimatedRowHeight = 90
        
    }
    
    
    
// FAQ service call
    
//func frequentlyAskedQuestions()
//{
//
//    if Reachability.isConnectedToNetwork()
//    {
//
//    MobileFixServices.sharedInstance.loader(view: self.view)
//    //languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
//
//    let FAQ = "\(base_path)services/faqs?"
//
//     //https://volive.in/mrhow_dev/services/faqs?api_key=1762019&lang=en
//
//    let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": language]
//
//    Alamofire.request(FAQ, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
//
//    if let responseData = response.result.value as? Dictionary<String, Any>{
//    //print(responseData)
//
//    let status = responseData["status"] as! Int
//    let message = responseData["message"] as! String
//    if status == 1
//    {
//        MobileFixServices.sharedInstance.dissMissLoader()
//
//        if let responceData1 = responseData["data"] as? [Dictionary<String,Any>]
//        {
//
//
//
//                if responceData1.count > 0
//                {
//                self.tableData.removeAll()
//
//                for i in responceData1
//               {
//
//                let questionData = cellData(open: false, labelData: ([i["text"] as! String]), header: (i["title"]as! String), imageName: "Faq_1-1")
//
//
//
//                self.tableData.append(questionData)
//                }
//
//           }
//
//
//
//        }
//
//        DispatchQueue.main.async {
//
//        self.faqTV.reloadData()
//            self.faqTV.delegate = self
//            self.faqTV.dataSource = self
//        }
//     }
//    else
//    {
//        MobileFixServices.sharedInstance.dissMissLoader()
//        self.showToastForAlert(message: message,style: style1)
//      }
//    }
//   }
//  }
//        else{
//              MobileFixServices.sharedInstance.dissMissLoader()
//            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
//        }
//
//}
    
    // MARK: - Back Button
    
   
 
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
       return tableData.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableData[section].opened == false
        {
            return 0
        }
            
        else
        {
            return tableData[section].sectionData.count
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label: UILabel = {
            let lb = UILabel()
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.text = tableData[section].title
            lb.textColor = .black

            lb.numberOfLines = 0
            return lb
        }()

         let close = UIButton(type: UIButton.ButtonType.custom)
        close.frame = CGRect(x: 10, y: 15, width: 20, height: 50)
        if(openOrCloseArray.contains(section)){
            close.setImage(UIImage(named: "Faq_1-1"), for: UIControl.State.normal)
        }else{
            if(isFirstTimeClicked == true){
                close.setImage(UIImage(named: "Faq_1"), for: UIControl.State.normal)
            }else{
                close.setImage(UIImage(named: "Faq_1-1"), for: UIControl.State.normal)
            }
            
        }
       close.tag = section
        close.addTarget(self, action: #selector(buttonOnTap(close:)), for: UIControl.Event.touchUpInside)


        let header: UIView = {
            let hd = UIView()

            hd.addSubview(label)
            hd.addSubview(close)

            label.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 50).isActive = true
            label.topAnchor.constraint(equalTo:close.topAnchor, constant: 15).isActive = true
            label.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: -8).isActive = true
            label.bottomAnchor.constraint(equalTo: hd.bottomAnchor, constant: -5).isActive = true


            return hd
        }()




       return header
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let line = UILabel()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.lightGray
        let header: UIView = {
            let hd = UIView()
            hd.addSubview(line)
            line.leadingAnchor.constraint(equalTo: hd.leadingAnchor, constant: 0).isActive = true
            line.topAnchor.constraint(equalTo: hd.topAnchor, constant: 8).isActive = true
            line.trailingAnchor.constraint(equalTo: hd.trailingAnchor, constant: 0).isActive = true
            
            line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            return hd
        }()
        
        return header
        

    }
    

    @objc func buttonOnTap(close:UIButton)
    {
        isFirstTimeClicked = true
        var indexpathArray = [IndexPath]()

        for i in tableData[close.tag].sectionData.indices

        {

            let ip = IndexPath(row: i, section: close.tag)
            indexpathArray.append(ip)

        }
        if tableData[close.tag].opened == true
        {
            tableData[close.tag].opened = false
            openOrCloseArray.append(close.tag)
            close.setImage(UIImage(named: "Faq_1-1"), for: UIControl.State.normal)
          faqTV.deleteRows(at: indexpathArray, with: .none)
        }
        else
        {
            tableData[close.tag].opened = true
            if( openOrCloseArray.contains(close.tag)){
                
                let pets = openOrCloseArray.filter { $0 != close.tag }
                
                openOrCloseArray = pets
            }
            close.setImage(UIImage(named: "Faq_1"), for: UIControl.State.normal)
            faqTV.insertRows(at: indexpathArray, with: .none)
        }
       
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as! ContentTableViewCell
       
      
       
             cell.contentTextLbl.textAlignment = .left
           
        
        cell.contentTextLbl.text = tableData[indexPath.section].sectionData[indexPath.row]
        
        cell.contentTextLbl.font = UIFont(name: "Poppins", size: 16.0)
        cell.contentLbl.isHidden = true

      
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.contentLbl, fontSize: 17)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.contentTextLbl, fontSize: 17)
            
        
        
        
        
        return cell
    }



    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return UITableView.automaticDimension
    }
    

}

struct cellData1{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
    var imgName = String()
    
    init(open:Bool,labelData:[String],header:String,imageName:String) {
        self.opened = open
        self.title = header
        self.sectionData = labelData
        self.imgName = imageName
       
        
    }
    

}








