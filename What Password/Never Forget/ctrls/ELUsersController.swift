//
//  ELUsersController.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit

class ELUsersController: ELBaseController {

    var userTable:UICollectionView!
    var datas:[UserModel] = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Users"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserLogined"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserEdited"), object: nil)
        genUserTable()
        refreshData()
        genAddBtn()
    }
    
    @objc func refreshData() {
        ELDatabase.instance.getUserList { (users) in
            self.datas = users
            self.userTable.reloadData()
        }
    }
    func genUserTable() {
        let frm = CGRect(x: 10, y: kTopBarHeight + 10, width: kScreenWidth - 20, height: kScreenHeight - kTopBarHeight - kTabBarHeight - 20)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frm.width/2, height: 50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        userTable = UICollectionView(frame: frm, collectionViewLayout: layout)
        userTable.delegate = self
        userTable.dataSource = self
        userTable.backgroundColor = .clear
        userTable.register(UserCell.self, forCellWithReuseIdentifier: "UserCellId")
        view.addSubview(userTable)
    }
    func genAddBtn() {
        let btn = UIButton()
        btn.size = CGSize(width: 60, height: 40)
        btn.midx = view.width/2
        btn.by = kScreenHeight - kTabBarHeight
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        let img = UIImage(named: "addAccountBtnIcon")
        let imgv = UIImageView()
        imgv.image = img
        imgv.frame = btn.bounds.insetBy(dx: 15, dy: 8)
        btn.addSubview(imgv)
    }
    
    @objc func addUser() {
        let addView = ELAddUserView()
        addView.show()
    }

}

extension ELUsersController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCellId", for: indexPath) as! UserCell
        cell.user = datas[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = datas[indexPath.row]
        if user.username == curUserName {
            let v = ELUserSettingView(user: user)
            v.show()
            return
        }
        let addView = ELUserLoginView()
        addView.user = user
        addView.show()
    }
}

class UserCell : UICollectionViewCell {
    var user:UserModel! {
        didSet {
            name.text = user.username
            currentIcon.isHidden = user.username != curUserName
        }
    }
    lazy var bgView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.setRadius(radius: 10)
        addSubview(v)
        return v
    }()
    
    lazy var name:UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        bgView.addSubview(v)
        return v
    }()
    
    lazy var currentIcon:UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "currentIcon")?.withRenderingMode(.alwaysTemplate)
        v.tintColor = kKeyColor
        bgView.addSubview(v)
        return v
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 10, y: 5, width: width - 20, height: height - 10)
        name.frame = CGRect(x: 10, y: 0, width: bgView.width - 40, height: bgView.height)
        currentIcon.frame = CGRect(x: name.rx, y: (bgView.height - 20)/2, width: 20, height: 20)
        
    }
    
}
