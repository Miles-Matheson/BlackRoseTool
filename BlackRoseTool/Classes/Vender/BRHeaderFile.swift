//
//  BRHeaderFile.swift
//  blackrose
//
//  Created by MAC on 2022/4/11.
//

import Foundation
import UIKit
import SnapKit

// 高度比列
public func FitHeight(_ h: CGFloat)->CGFloat {
    return SCREEN_HEIGHT/667*h
}

// 宽度比
public func FitWith(_ w: CGFloat)->CGFloat {
    return SCREEN_WIDTH/375*w
}

let SCREEN_WIDTH = UIScreen.main.bounds.width;

let SCREEN_HEIGHT = UIScreen.main.bounds.height;

let NAVI_HEIGHT = nav_statusBarH() + 44;

let TABAR_HEIGHT = tab_statusBarH() + 49;

let Height_StatusBar = nav_statusBarH();

let mainColor = #colorLiteral(red: 0.2941176471, green: 0.5058823529, blue: 0.9490196078, alpha: 1)
let TABAR_StateHEIGHT = (isiPhoneX() ? 34 : 0);

func tab_statusBarH() ->CGFloat {
    if #available(iOS 11.0, *) {
        let isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
        return isPhoneX
    }
    return 0
}

func isiPhoneX() ->Bool {
    if #available(iOS 11.0, *) {
        let isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
        return isPhoneX > 0.0 ? true : false
    } else {
        // Fallback on earlier versions
    }
    
    return false
}


func tab_bottomBarH() ->CGFloat {
    if #available(iOS 11.0, *) {
        let isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
        return isPhoneX
    }
    return 20
}

func nav_statusBarH() ->CGFloat {
    if #available(iOS 11.0, *) {
        let isPhoneX = (UIApplication.shared.delegate?.window??.safeAreaInsets.top)!
        return isPhoneX
    }
    return 20
}

func UIImageName(_ named:String)->UIImage{
    let img = UIImage.init(named: named)
    if img == nil {
        return UIImage.init()
    }
    return img!
}

func Font(_ font:CGFloat)->UIFont{
    return UIFont.systemFont(ofSize: font)
}

let mainFont = UIFont.systemFont(ofSize: 13)
let font11 = UIFont.systemFont(ofSize: 11)
let font12 = UIFont.systemFont(ofSize: 12)
let font13 = UIFont.systemFont(ofSize: 13)
let font14 = UIFont.systemFont(ofSize: 14)
let font16 = UIFont.systemFont(ofSize: 16)
let fontBold18 = UIFont.boldSystemFont(ofSize: 18)

let  colorA3 = UIColor.init(hex: 0xA3A3A3)
let  colortextbg = UIColor.init(hex: 0x373636)
let  maincolor = UIColor.init(hex: 0x221E1E)
let  color333 = UIColor.init(hex: 0x333333)
let  color666 = UIColor.init(hex: 0x666666)
let  color999 = UIColor.init(hex: 0x999999)
let  coloraaa = UIColor.init(hex: 0xaaaaaa)
let  coloreee = UIColor.init(hex: 0xeeeeee)
let  colorfa = UIColor.init(hex: 0xfafafa)
let  colorf9 = UIColor.init(hex: 0xf9f9f9)
let  colorf0 = UIColor.init(hex: 0xf0f0f0)
let  colorf123 = UIColor.init(hex: 0xf1f2f3)
let  colorWhiter = UIColor.init(hex: 0xffffff)
let  forgotpasscolor = UIColor.init(hex: 0x9E9D9D)

