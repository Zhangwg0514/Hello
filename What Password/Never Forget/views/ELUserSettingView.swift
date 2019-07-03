//
//  ELUserSettingView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/23.
//

import UIKit

class ELUserSettingView: UIView {

    var table:UITableView!
    var titleLbl:UILabel!
    var user:UserModel!
    convenience init(user:UserModel) {
        self.init()
        self.user = user
        frame = kScreenBounds
        backgroundColor = .clear
        conView.frame = CGRect(x: 0, y: kScreenHeight - 280 - kSafeAreaHeight, width: kScreenWidth, height: 280 + kSafeAreaHeight)
        tentView.frame = conView.bounds
        conView.contentView.addSubview(tentView)
        
        titleLbl = UILabel()
        titleLbl.text = "Edit \(user.username) Infos"
        titleLbl.textAlignment = .center
        titleLbl.size = CGSize(width: kScreenWidth, height: 30)
        titleLbl.y = 25
        tentView.addSubview(titleLbl)
        table = UITableView()
        table.frame = CGRect(x: 10, y: 80, width: kScreenWidth - 20, height: 180)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.tableFooterView = UIView()
        tentView.addSubview(table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserLogined"), object: nil)
    }
    deinit {
        print("user setting deinit")
    }
    
    lazy var bgView:UIButton = {
        let v = UIButton()
        v.frame = bounds
        v.backgroundColor = UIColor("00000011")
        v.addTarget(self, action: #selector(hide), for: .touchUpInside)
        v.frame = bounds
        insertSubview(v, at: 0)
        return v
    }()
    
    lazy var tentView:UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var conView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let v = UIVisualEffectView(effect: blurEffect)
        v.setRadius(radius: 4)
        addSubview(v)
        return v
    }()
    
    @objc func refreshData() {
        table.reloadData()
    }
    
    func show() {
        kKeyWin.addSubview(self)
        conView.transform.ty = height - conView.y
        bgView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.conView.transform = .identity
            self.bgView.alpha = 1
        }
        
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
}

extension ELUserSettingView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(row: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            UIView.animate(withDuration: 0.3) {
                self.tentView.transform.tx = -self.width
            }
            let frm = conView.bounds
            let editView = ELEditNameView(frame: frm, user:user) {
                UIView.animate(withDuration: 0.3) {
                    self.tentView.transform = .identity
                }
            }
            editView.user = user
            editView.show(at: conView)
            return
        }
        if indexPath.row == 1 {
            UIView.animate(withDuration: 0.3) {
                self.tentView.transform.tx = -self.width
            }
            let frm = conView.bounds
            let editView = ELEditPassView(frame: frm, user:user) {
                UIView.animate(withDuration: 0.3) {
                    self.tentView.transform = .identity
                }
            }
            editView.user = user
            editView.show(at: conView)
            return
        }
        if indexPath.row == 2 {
            UIView.animate(withDuration: 0.3) {
                self.tentView.transform.tx = -self.width
            }
            let frm = conView.bounds
            let editView = ELEditPromptView(frame: frm, user:user) {
                UIView.animate(withDuration: 0.3) {
                    self.tentView.transform = .identity
                }
            }
            editView.user = user
            editView.show(at: conView)
            return
        }
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "Prompt", message: "Are you sure?", preferredStyle: .alert)
            let act = UIAlertAction(title: "yes", style: .default) {[unowned self] (act) in
                ELDatabase.instance.deleteUser(self.user) {(b, msg) in
                    
                }
            }
            let cancel = UIAlertAction(title: "no", style: .default, handler: nil)
            alert.addAction(act)
            alert.addAction(cancel)
            kKeyWin.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func getCell(row:Int) -> UITableViewCell {
        if row == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.textLabel?.text = "Edit Name"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if row == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.textLabel?.text = "Edit Password"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if row == 2 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.textLabel?.text = "Edit Prompts"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        cell.textLabel?.text = "Delete"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
