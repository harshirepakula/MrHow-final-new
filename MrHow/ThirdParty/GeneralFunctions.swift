//
//  GeneralFunctions.swift
//  Glirishas_Swift
//
//  Created by Girishas on 05/09/17.
//  Copyright © 2017 Girishas. All rights reserved.
//

import UIKit

class GeneralFunctions: NSObject {
    
    /* ===== ===== ==== === === ==== ==== === === === === === = ==== ==== ==== */
    
    
//    Poppins
//    == Poppins-Light
//    == Poppins-Medium
//    == Poppins-SemiBold
//    == Poppins-Regular
    
//    29LTBukra-Regular
//    == 29LTBukra-Bold
   
    
    static func labelCustom_RTBold(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "29LTBukra-Bold", size: fontSize)
    }
    static   func labelCustom_RTReg(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "29LTBukra-Regular", size: fontSize)
    }
    
    static   func buttonCustom_RTBold(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "29LTBukra-Bold", size: fontSize)
    }
    static   func buttonCustom_RTReg(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "29LTBukra-Regular", size: fontSize)
    }
    
    
    
    
   //FOR ENGLISH
    
    static func labelCustom_LTBold(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "Poppins-SemiBold", size: fontSize)
    }
    static func labelCustom_LTMedium(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "Poppins-Medium", size: fontSize)
    }
    static   func labelCustom_LTLight(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "Poppins-Light", size: fontSize)
    }
    static   func labelCustom_LTReg(labelName: UILabel, fontSize: CGFloat)
    {
        labelName.font = UIFont(name: "Poppins-Regular", size: fontSize)
    }
    
    static   func buttonCustom_LTBold(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: fontSize)
    }
    static   func buttonCustom_LTMedium(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "Poppins-Medium", size: fontSize)
    }
    static   func buttonCustom_LTLight(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "Poppins-Light", size: fontSize)
    }
    static   func buttonCustom_LTReg(buttonName: UIButton, fontSize: CGFloat)
    {
        buttonName.titleLabel?.font = UIFont(name: "Poppins-Regular", size: fontSize)
    }
    

    static func textPlaceholderText_LTLight(textFieldName: UITextField ,strPlaceHolderName: String)
    {
        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 12.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray] as! [NSAttributedString.Key: Any])
    }
    
    static func textPlaceholderText_RTLight(textFieldName: UITextField ,strPlaceHolderName: String)
    {
        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "29LTBukra-Regular", size: 12.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray] as! [NSAttributedString.Key: Any])
    }
//
//
//    static   func labelCustom_SubHeadNeueLTArabicStyle(labelName: UILabel, fontSize: CGFloat)
//    {
//       // labelName.font = UIFont(name: "HelveticaNeueLTCom-Th", size: fontSize)
//         labelName.font = UIFont(name: "HelveticaNeueLTArabic-Roman", size: fontSize)
//
//
//    }
//
//    static   func labelCustom_NeueLTArabicStyle(labelName: UILabel, fontSize: CGFloat)
//    {
//        labelName.font = UIFont(name: "HelveticaNeueLTArabic-Roman", size: fontSize)
//       // labelName.font = UIFont(name: "HelveticaNeueLTCom-Th", size: fontSize)
//        //HelveticaNeueLT-BlackCond
//        //HelveticaNeueLT-Thin ---> 1
//        // HelveticaNeueLT-UltraLigCond
//
//
//    }
//
//    //HARISH ADDED new bold font for BuyModelDeatails
//
//    static   func labelCustom_Nenu75BoldStyleArabicStyle(labelName: UILabel, fontSize: CGFloat)
//    {
//        labelName.font = UIFont(name: "HelveticaNeueLTArabic-Roman", size: fontSize)
//
//    }
//    //LOGIN
//    static   func labelCustom_NenuBoldStyleArabicStyleLogin(labelName: UILabel, fontSize: CGFloat)
//    {
//        labelName.font = UIFont(name: "HelveticaNeueLTW1G-Bd", size: fontSize)
//
//    }
//    static   func labelCustom_NenuBoldStyleArabicStyle(labelName: UILabel, fontSize: CGFloat)
//    {
//        labelName.font = UIFont(name: "HelveticaNeueLTArabic-Roman", size: fontSize)
//
//    }
//    static   func buttonCustom_NeueBoldStyle(buttonName: UIButton, fontSize: CGFloat)
//    {
//        buttonName.titleLabel?.font = UIFont(name: "HelveticaNeueLTW1G-Bd", size: fontSize)
//    }
//    static   func buttonCustom_NeueLTArabicStyle(buttonName: UIButton, fontSize: CGFloat)
//    {
//        buttonName.titleLabel?.font = UIFont(name: "HelveticaNeueLTArabic-Roman", size: fontSize)
//    }
//
//
//    static func textPlaceholderText_NeueLTArabicFont(textFieldName: UITextField ,strPlaceHolderName: String)
//    {
//        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "HelveticaNeueLTArabic-Roman", size: 14.0)!,NSAttributedString.Key.foregroundColor: UIColor.lightGray] as! [NSAttributedString.Key: Any])
//    }
//
//    static func textPlaceholderText_EnglishSystemFont(textFieldName: UITextField ,strPlaceHolderName: String)
//    {
//        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:
//            UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor: UIColor.lightGray] as! [NSAttributedString.Key: Any])
//    }
//
//
//
//    static func textPlaceholderText_NeueLTArabicFont2(textFieldName: UITextField ,strPlaceHolderName: String)
//    {
//        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "HelveticaNeueLTArabic-Roman", size: 15.0)!,NSAttributedString.Key.foregroundColor: UIColor.red] as [NSAttributedString.Key: Any])
//    }
//
//
//    static func textPlaceholderText_NeueLTArabicFontLoginPage(textFieldName: UITextField ,strPlaceHolderName: String)
//    {
//        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "HelveticaNeueLTArabic-Roman", size: 16.0)!,NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any])
//    }
//    static func textPlaceholderText_NeueLTArabicFontBiddingPage(textFieldName: UITextField ,strPlaceHolderName: String)
//    {
//        textFieldName.attributedPlaceholder = NSAttributedString(string: strPlaceHolderName, attributes:[NSAttributedString.Key.font:UIFont(name: "HelveticaNeueLTArabic-Roman", size: 12.0)!,NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any])
//    }

}
