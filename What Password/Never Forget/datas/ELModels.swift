//
//  ELModels.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit

class AccountModel: NSObject {

    var id:String = String(Date().timeIntervalSince1970)
    var username:String = ""
    var accounticon:String = ""
    var accountname:String = ""
    var accountpass:String = ""
    var desc:String = ""
    var time:Date = Date()
    var md5Pass:String! {
        get {
            return accountpass.md5()
        }
    }
    var showPass:Bool = false
    convenience init(_ acc:Account) {
        self.init()
        id = acc.id ?? ""
        accounticon = acc.accounticon ?? ""
        username = acc.username ?? ""
        accountname = acc.accountname ?? ""
        accountpass = acc.accountpass ?? ""
        desc = acc.desc ?? ""
        time = acc.time ?? Date()
    }

}

class UserModel: NSObject {
    
    var id:String = String(Date().timeIntervalSince1970)
    var username:String = ""
    var password:String = ""
    var prompts:String = ""
    var answer:String = ""
    
    convenience init(_ user:User) {
        self.init()
        id = user.id ?? ""
        username = user.username ?? ""
        password = user.password ?? ""
        prompts = user.prompts ?? ""
        answer = user.answer ?? ""
    }
    
}
