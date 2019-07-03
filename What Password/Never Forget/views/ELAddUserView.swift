//
//  ELAddUserView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/22.
//

import UIKit
import SVProgressHUD

class ELAddUserView: UIView, UITextFieldDelegate {

    var users = [UserModel]()
    lazy var bgView:UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor("00000011")
        v.addTarget(self, action: #selector(hide), for: .touchUpInside)
        v.frame = bounds
        return v
    }()
    lazy var conView:UIView = {
        let blurEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurEffect)
        v.frame = kContainFrame
        v.y = kScreenHeight - 450 - kSafeAreaHeight
        v.setRadius(radius: 16)
        addSubview(v)
        
        conBgView.frame = v.bounds
        v.contentView.addSubview(conBgView)
        
        v.contentView.addSubview(titleLbl)
        
        nameFld.y = titleLbl.by + 5
        v.contentView.addSubview(nameFld)
        
        passFld.y = nameFld.by + 15
        v.contentView.addSubview(passFld)
        
        promptFld.y = passFld.by + 15
        v.contentView.addSubview(promptFld)
        
        answerFld.y = promptFld.by + 15
        v.contentView.addSubview(answerFld)
        
        saveBtn.y = answerFld.by + 20
        v.contentView.addSubview(saveBtn)
        
        cancelBtn.y = answerFld.by + 20
        v.contentView.addSubview(cancelBtn)
        
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
        v.text = "Add User"
        return v
    }()
    
    lazy var nameFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter user name:"
        return v
    }()
    
    lazy var passFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter user password:"
        return v
    }()
    
    lazy var promptFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter password prompt question:"
        return v
    }()
    
    lazy var answerFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter prompt question answer:"
        return v
    }()
    
    
    
    lazy var saveBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = kBtnColor
        v.size = CGSize(width: (width - 90)/2, height: 44)
        v.x = 35
        v.setRadius(radius: v.height/2)
        v.setTitle("Add", for: .normal)
        v.addTarget(self, action: #selector(save), for: .touchUpInside)
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
    
    func show() {
        ELDatabase.instance.getUserList(callback: { (us) in
            self.users = us
        })
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
    
    @objc func save() {
        guard let name = nameFld.text else {
            SVProgressHUD.showError(withStatus: "enter user name please.")
            return
        }
        if name.count == 0 {
            SVProgressHUD.showError(withStatus: "enter user name please.")
            return
        }
        guard let pass = passFld.text else {
            SVProgressHUD.showError(withStatus: "enter user password please.")
            return
        }
        if pass.count == 0 {
            SVProgressHUD.showError(withStatus: "enter user password please.")
            return
        }
        for um in users {
            if name == um.username {
                SVProgressHUD.showError(withStatus: "user name have exist.")
                return
            }
        }
        
        let user = UserModel()
        user.username = name
        user.password = pass
        user.prompts = promptFld.text ?? ""
        user.answer = answerFld.text ?? ""
        ELDatabase.instance.saveUser(user) {[unowned self] (b, msg) in
            if b {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserAdded"), object: nil)
                self.hide()
            }
            SVProgressHUD.showInfo(withStatus: msg)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameFld {
            passFld.becomeFirstResponder()
        } else if textField == passFld {
            promptFld.becomeFirstResponder()
        } else if textField == promptFld {
            answerFld.becomeFirstResponder()
        } else {
            answerFld.resignFirstResponder()
        }
        return true
    }
}
