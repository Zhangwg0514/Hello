//
//  ELValues.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit

let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let kKeyWin = UIApplication.shared.keyWindow!
let kScreenBounds = UIScreen.main.bounds
let kKeyColorVal = "934fa7"
let kKeyColor = UIColor(kKeyColorVal)
let kStatHeight = UIApplication.shared.statusBarFrame.height
let kNavHeight:CGFloat = 44
let kTopBarHeight = kStatHeight + kNavHeight
let kSafeAreaHeight = CGFloat(kStatHeight > 20 ? 34.0 : 0)
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kContainHeight = kScreenHeight - kTopBarHeight - kSafeAreaHeight
let kContainFrame = CGRect(x: 0, y: kTopBarHeight, width: kScreenWidth, height: kContainHeight)
let kTabBarHeight = CGFloat(kSafeAreaHeight + 49)
var curUserName:String = ""

let kBtnColor = UIColor("da7528")
let kDefaultUsername = "DefaultUser"

let kMobileNumber = "(+63)9569464337"
let kEmailAddress = "tongfeihe858479@163.com"


func getStringHeight(_ str:String, width:CGFloat, fontSize:CGFloat) -> CGFloat {
    let options:NSStringDrawingOptions = .usesLineFragmentOrigin
    let boundingRect = str.boundingRect(with: CGSize(width: width, height: 0), options: options, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)], context: nil)
    return boundingRect.height
}
