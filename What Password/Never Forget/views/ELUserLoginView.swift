//
//  ELUserLoginView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/22.
//

import UIKit
import SVProgressHUD

class ELUserLoginView: UIView, UITextFieldDelegate {

    var user:UserModel!
    lazy var bgView:UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor("00000011")
        v.addTarget(self, action: #selector(hide), for: .touchUpInside)
        v.frame = bounds
        return v
    }()
    lazy var conView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurEffect)
        v.frame = kContainFrame
        v.y = kScreenHeight - 300 - kSafeAreaHeight
        v.setRadius(radius: 16)
        addSubview(v)
        
        tentView.frame = v.bounds
        v.contentView.addSubview(tentView)
        
        conBgView.frame = v.bounds
        tentView.addSubview(conBgView)

        tentView.addSubview(titleLbl)
        
        passFld.y = titleLbl.by + 5
        tentView.addSubview(passFld)
        
        saveBtn.y = passFld.by + 30
        tentView.addSubview(saveBtn)
        
        cancelBtn.y = passFld.by + 30
        tentView.addSubview(cancelBtn)
        
        if user.prompts.count > 0 {
            forgetBtn.y = cancelBtn.by + 5
            tentView.addSubview(forgetBtn)
        }
        
        
        return v
    }()
    
    @objc func endEdit() {
        conView.endEditing(true)
    }
    
    lazy var conBgView:UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.addTarget(self, action: #selector(endEdit), for: .touchUpInside)
        return v
    }()
    
    lazy var titleLbl:UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.frame = CGRect(x: 0, y: 30, width: width, height: 60)
        v.text = "\(user.username) Sign In"
        return v
    }()
    
    lazy var passFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.isSecureTextEntry = true
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter user password:"
        return v
    }()
    lazy var saveBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = kBtnColor
        v.size = CGSize(width: (width - 90)/2, height: 44)
        v.x = 35
        v.setRadius(radius: v.height/2)
        v.setTitle("Sign in", for: .normal)
        v.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return v
    }()
    lazy var cancelBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = kBtnColor
        v.size = CGSize(width: (width - 90)/2, height: 44)
        v.rx = width - 35
        v.setRadius(radius: v.height/2)
        v.setTitle("Cancel", for: .normal)
        v.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return v
    }()
    lazy var forgetBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.size = CGSize(width: (width)/2, height: 44)
        v.midx = width/2
        let attDic = [NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue), NSAttributedString.Key.foregroundColor : UIColor("54a9f3"), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]
        let attStr = NSMutableAttributedString(string: "Forget Password >>", attributes: attDic)
        v.setAttributedTitle(attStr, for: .normal)
        v.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
        return v
    }()
    
    lazy var tentView:UIView = {
        let v = UIView()
        return v
    }()
    
    func show() {
        frame = kKeyWin.bounds
        backgroundColor = .clear
        kKeyWin.addSubview(self)
        addSubview(bgView)
        
        
        addSubview(conView)
        
        conView.transform.ty = height - conView.y
        bgView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.conView.transform = .identity
            self.bgView.alpha = 1
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyFrameWillChanged(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hide), name: NSNotification.Name("PromptAnswerLogined"), object: nil)
    }
    @objc func keyFrameWillChanged(noti:Notification) {
        let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.cgRectValue
        let h = kScreenHeight - rect.origin.y
        conView.transform.ty = -h
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func hide() {
        let h = height - conView.y
        UIView.animate(withDuration: 0.3, animations: {
            self.conView.transform.ty = h
            self.bgView.alpha = 0
        }) { (f) in
            if f {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func signIn() {
//        guard let pass = passFld.text else {
//            SVProgressHUD.showError(withStatus: "enter user password please.")
//            return
//        }
//        if pass.count == 0 {
//            SVProgressHUD.showError(withStatus: "enter user password please.")
//            return
//        }
        let pass = passFld.text ?? ""
        ELDatabase.instance.getUserList {[unowned self] (ums) in
            var userExist = false
            for um in ums {
                if um.username == self.user.username {
                    userExist = true
                    if um.password == pass {
                        curUserName = um.username
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLogined"), object: nil)
                        SVProgressHUD.showSuccess(withStatus: "User sign in success!")
                        self.hide()
                        UserDefaults.standard.setValue(curUserName, forKey: "CurrentUsername")
                        UserDefaults.standard.synchronize()
                        return
                    }
                }
            }
            if userExist {
                SVProgressHUD.showSuccess(withStatus: "User password incorrect!")
            } else {
                SVProgressHUD.showSuccess(withStatus: "User not Exist!")
            }
            
        }
    }
    
    @objc func forgetPassword() {
        UIView.animate(withDuration: 0.3) {
            self.tentView.transform.tx = -self.width
        }
        let frm = conView.bounds
        let editView = ELForgetPassView(frame: frm, user:user) {
            UIView.animate(withDuration: 0.3) {
                self.tentView.transform = .identity
            }
        }
        editView.user = user
        editView.show(at: conView)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passFld {
            passFld.resignFirstResponder()
        }
        return true
    }
}
