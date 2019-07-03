//
//  ELForgetPassView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/23.
//

import UIKit
import SVProgressHUD

class ELForgetPassView: UIView, UITextFieldDelegate {
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
        
        promptLbl.y = oldNameLbl.by + 5
        addSubview(promptLbl)
        
        answerFld.y = promptLbl.by + 5
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
        v.text = "Enter User Prompts"
        return v
    }()
    
    lazy var oldNameLbl:UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.frame = CGRect(x: 30, y: 30, width: width - 60, height: 40)
        v.text = "User Name : \(user.username)"
        return v
    }()
    
    lazy var promptLbl:UILabel = {
        let v = UILabel()
        v.textAlignment = .left
        v.frame = CGRect(x: 30, y: 30, width: width - 60, height: 40)
        v.text = user.prompts.count > 0 ? user.prompts : "No prompt"
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
    
    @objc func signIn() {
        guard let answer = answerFld.text else {
            SVProgressHUD.showError(withStatus: "enter answer please.")
            return
        }
        if answer.count == 0 {
            SVProgressHUD.showError(withStatus: "enter answer please.")
            return
        }
        ELDatabase.instance.getUserList {[unowned self] (ums) in
            for um in ums {
                if um.username == self.user.username {
                    if um.answer == answer {
                        curUserName = um.username
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLogined"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PromptAnswerLogined"), object: nil)
                        SVProgressHUD.showSuccess(withStatus: "User sign in success!")
                        UserDefaults.standard.setValue(curUserName, forKey: "CurrentUsername")
                        UserDefaults.standard.synchronize()
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "prompt answer incorrect!")
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == answerFld {
            answerFld.resignFirstResponder()
        }
        return true
    }
}
