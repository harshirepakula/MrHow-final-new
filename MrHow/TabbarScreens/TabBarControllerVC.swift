//
//  TabBarControllerVC.swift
//  Zido
//
//  Created by volivesolutions on 30/10/18.
//  Copyright © 2018 volivesolutions. All rights reserved.
//

import UIKit


class TabBarControllerVC: UITabBarController,UITabBarControllerDelegate {
    
    var customTabBar:UITabBarItem!
   let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
    

     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        
        let selectedColor   = #colorLiteral(red: 0.05098039216, green: 0.8039215686, blue: 0.4705882353, alpha: 1)
        let unselectedColor = #colorLiteral(red: 0.3450980392, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:selectedColor], for: .selected)
       if language == "en"
       {
         UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 10)!], for: .normal)
        
        }else if language == "ar"
       {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "29LTBukra-Regular", size: 10)!], for: .normal)
        }
    
 
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        if item == (tabBar.items)![0] {
            
            print("index1")
        }
        else if item == (tabBar.items)![1] {
            print("index2")
        }
        else  if item == (tabBar.items)![2] {
            print("index2")
        }
        else if item == (tabBar.items)![3] {
            print("index3")
           
        }
        else  if item == (tabBar.items)![4] {
            print("index4")
        
            //https://volive.in/mrhow_dev/uploads/52378eb2f08c7cb59eb9e518dcbd7bca.jpg
            
        }
        
        
        print("Hello Tabbar Item Taped")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension UIImage {
    
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
