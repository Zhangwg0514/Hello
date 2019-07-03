//
//  ELEditPromptView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/23.
//

import UIKit
import SVProgressHUD

class ELEditPromptView: UIView, UITextFieldDelegate {
    var user:UserModel!
    var callBack:(()->())!
    weak var contentView:UIView?
    convenience init(frame: CGRect, user:UserModel, callback:@escaping (()->())) {
        self.init(frame: frame)
        self.user = user
        callBack = callback
        conBgView.frame = bounds
        addSubview(conBgView)
        
        addSubview(titleLbl)
        
        oldNameLbl.y = titleLbl.by + 5
        addSubview(oldNameLbl)
        
        promptFld.y = oldNameLbl.by + 5
        addSubview(promptFld)
        
        answerFld.y = promptFld.by + 5
        addSubview(answerFld)
        
        saveBtn.y = answerFld.by + 15
        addSubview(saveBtn)
        cancelBtn.y = answerFld.by + 15
        addSubview(cancelBtn)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyFrameWillChanged(noti:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyFrameWillChanged(noti:Notification) {
        let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let rect = value.cgRectValue
        let h = kScreenHeight - rect.origin.y
        contentView?.transform.ty = -h
    }
    @objc func endEdit() {
        promptFld.resignFirstResponder()
        answerFld.resignFirstResponder()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        v.frame = CGRect(x: 0, y: 10, width: width, height: 40)
        v.text = "Edit User Prompts"
        return v
    }()
    
    lazy var oldNameLbl:UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.frame = CGRect(x: 30, y: 30, width: width - 60, height: 40)
        v.text = "User Name : \(user.username)"
        return v
    }()
    
    lazy var promptFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter new prompt:"
        return v
    }()
    
    lazy var answerFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter new answer:"
        return v
    }()
    
    lazy var saveBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = kBtnColor
        v.size = CGSize(width: (width - 90)/2, height: 44)
        v.x = 35
        v.setRadius(radius: v.height/2)
        v.setTitle("Save", for: .normal)
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
    
    func show(at:UIVisualEffectView) {
        at.contentView.addSubview(self)
        contentView = at
        self.transform.tx = width
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    @objc func hide() {
        callBack()
        UIView.animate(withDuration: 0.3, animations: {
            self.transform.tx = self.width
        }) { (f) in
            if f {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func save() {
        guard let prompt = promptFld.text else {
            SVProgressHUD.showError(withStatus: "enter new prompt please.")
            return
        }
        if prompt.count == 0 {
            SVProgressHUD.showError(withStatus: "enter new prompt please.")
            return
        }
        guard let answer = answerFld.text else {
            SVProgressHUD.showError(withStatus: "enter new answer please.")
            return
        }
        if answer.count == 0 {
            SVProgressHUD.showError(withStatus: "enter new answer please.")
            return
        }
        
        let newUser = UserModel()
        newUser.username = user.username
        newUser.id = user.id
        newUser.password = user.password
        newUser.prompts = prompt
        newUser.answer = answer
        ELDatabase.instance.editUser(oldUser:user, newUser:newUser) {[unowned self] (b, msg) in
            if b {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserEdited"), object: nil)
                self.hide()
            }
            SVProgressHUD.showInfo(withStatus: msg)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == promptFld {
            answerFld.becomeFirstResponder()
        } else if textField == answerFld {
            answerFld.resignFirstResponder()
        }
        return true
    }
}
