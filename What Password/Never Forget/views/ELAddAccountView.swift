//
//  ELAddAccountView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit
import SVProgressHUD

class ELAddAccountView: UIView, UITextFieldDelegate, UITextViewDelegate {

    var accountIcon:String = "cateIcon0"
    
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
        nameFld.width = v.width - 125
        v.contentView.addSubview(nameFld)
        
        cateBtn.y = titleLbl.by + 9
        cateBtn.x = nameFld.rx
        v.contentView.addSubview(cateBtn)
        
        passFld.y = nameFld.by + 15
        v.contentView.addSubview(passFld)
        
        descFld.y = passFld.by + 15
        v.contentView.addSubview(descFld)
        
        saveBtn.y = descFld.by + 20
        v.contentView.addSubview(saveBtn)
        
        cancelBtn.y = descFld.by + 20
        v.contentView.addSubview(cancelBtn)
        
        return v
    }()
    @objc func endEdit() {
        conView.endEditing(true)
    }
    
    @objc func showCatePicView() {
        let catePick = ELCatePickView { [unowned self](cate) in
            self.accountIcon = cate
            self.cateImgv.image = UIImage(named: cate)
        }
        catePick.show()
    }
    
    lazy var conBgView:UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.addTarget(self, action: #selector(endEdit), for: .touchUpInside)
        return v
    }()
    
    lazy var cateBtn:UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(showCatePicView), for: .touchUpInside)
        v.frame = CGRect(x: 20, y: 43, width: 70, height: 40)
        v.addSubview(cateImgv)
        cateImgv.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        cateImgv.setRadius(radius: 20)
        let arrow = UIImageView()
        arrow.image = UIImage(named: "downIcon")
        v.addSubview(arrow)
        arrow.frame = CGRect(x: 54, y: 17, width: 12, height: 8)
        return v
    }()
    
    lazy var cateImgv:UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: accountIcon)
        return v
    }()
    
    lazy var titleLbl:UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.frame = CGRect(x: 0, y: 30, width: width, height: 60)
        v.text = "Add Account For \(curUserName)"
        return v
    }()
    
    lazy var nameFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter account name:"
        return v
    }()
    
    lazy var passFld:UITextField = {
        let v = UITextField()
        v.borderStyle = UITextField.BorderStyle.roundedRect
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 50)
        v.midx = width/2
        v.delegate = self
        v.placeholder = "Enter account password:"
        return v
    }()
    
    lazy var descFld:UITextView = {
        let v = UITextView()
        v.setRadius(radius: 8)
        v.backgroundColor = .white
        v.size = CGSize(width: width - 60, height: 120)
        v.midx = width/2
        v.font = .systemFont(ofSize:15)
        v.delegate = self
        v.addSubview(placehold)
        return v
    }()
    
    lazy var placehold:UILabel = {
        let v = UILabel()
        v.textColor = UIColor("999999")
        v.frame = CGRect(x: 10, y: 10, width: width - 80, height: 30)
        v.text = "Enter account description:"
        v.font = .systemFont(ofSize:15)
        return v
    }()
    
    lazy var saveBtn:UIButton = {
        let v = UIButton()
        v.backgroundColor = kBtnColor
        v.size = CGSize(width: (width - 90)/2, height: 44)
        v.x = 35
        v.setRadius(radius: v.height/2)
        v.setTitle("Save", for: .normal)
        v.addTarget(self, action: #selector(saveAccount), for: .touchUpInside)
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
    
    @objc func saveAccount() {
        guard let name = nameFld.text else {
            SVProgressHUD.showError(withStatus: "enter account name please.")
            return
        }
        if name.count == 0 {
            SVProgressHUD.showError(withStatus: "enter account name please.")
            return
        }
        guard let pass = passFld.text else {
            SVProgressHUD.showError(withStatus: "enter account password please.")
            return
        }
        if pass.count == 0 {
            SVProgressHUD.showError(withStatus: "enter account password please.")
            return
        }
        let acc = AccountModel()
        acc.username = curUserName
        acc.accounticon = accountIcon
        acc.accountname = name
        acc.accountpass = pass
        acc.desc = descFld.text ?? ""
        ELDatabase.instance.saveAccount(acc) {[unowned self] (b, msg) in
            if b {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AccountSaved"), object: nil)
                self.hide()
            }
            SVProgressHUD.showInfo(withStatus: msg)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameFld {
            passFld.becomeFirstResponder()
        } else if textField == passFld {
            descFld.becomeFirstResponder()
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placehold.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let txt = textView.text ?? ""
        placehold.isHidden = txt.count > 0
    }
    
    
}
