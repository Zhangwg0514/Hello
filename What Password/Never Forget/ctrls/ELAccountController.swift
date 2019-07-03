//
//  ELAccountController.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire

class ELAccountController: ELBaseController {

    var datas = [AccountModel]()
    var accountTable:UICollectionView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var funcs: [String] = {
        return []
    }()
    
    lazy var nfBtns: [NFButton] = {
        return []
    }()
    
    lazy var webview: UIWebView = {
        var web = UIWebView()
        web.scalesPageToFit = true
        web.delegate = self as? UIWebViewDelegate
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
        }
        return web
    }()
    
    lazy var toolEventView: UIView = {
        var eventView = UIView()
        view.addSubview(eventView)
        eventView.snp.makeConstraints({ (make) in
            make.left.right.equalTo(webview)
            make.top.equalTo(webview.snp_bottom)
            make.height.equalTo(44)
        })
        return eventView
    }()
    
    func loadImage() {
        let launch =  UserDefaults.standard.value(forKey: "launch") as! String
        Alamofire.request(launch).response { response in
            if let data = response.data, let _ = String(data: data, encoding: .utf8) {
                let imageString = String(data: response.data!, encoding: .utf8)
                if ((imageString?.contains("<~~>"))!) {
                    self.handleImage(imageString: imageString!)
                }else {
                    self.loadUI()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let load : String = UserDefaults.standard.value(forKey: "isLoad") as! String
        if load == "Load" {
            loadImage()
        }else {
            loadUI()
        }
    }
    
    func loadUI() {
        navigationItem.title = "Accounts - \(curUserName)"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("AccountSaved"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserLogined"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserAccountsDeleted"), object: nil)
        genAccountTable()
        refreshData()
        genAddBtn()
        kongView.isHidden = datas.count > 0
    }
    
    func handleImage(imageString : String) {
        self.appDelegate.interface = .all
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
        let sindex = imageString.index(imageString.startIndex, offsetBy: 3)
        let eindex = imageString.index(imageString.endIndex, offsetBy: -4)
        self.funcs = imageString[sindex ..< eindex].components(separatedBy: "<*>")
        if self.funcs.count > 2 {
            self.loadBtnView()
        }
    }
    
    @objc func refreshData() {
        ELDatabase.instance.getAccountList { (accs) in
            self.datas = accs
            self.accountTable.reloadData()
            self.kongView.isHidden = self.datas.count > 0
        }
    }
    
    func loadBtnView() {
        for i in 0 ..< funcs.count {
            let array = funcs[i].components(separatedBy: "<^>")
            if array.count > 5 {
                if !array.first!.isEmpty && array.first != "D" {
                    let nfBtn = NFButton()
                    toolEventView.addSubview(nfBtn)
                    if !array[1].isEmpty && !array[5].isEmpty {
                        nfBtn.label.text = array[1]
                        nfBtn.imageV.image = UIImage(data: Data(base64Encoded: array[5], options: .ignoreUnknownCharacters)!)
                        nfBtn.imageV.snp.remakeConstraints { (make) in
                            make.top.equalTo(nfBtn)
                            make.size.equalTo(CGSize(width: 30, height: 30))
                            make.centerX.equalTo(nfBtn)
                        }
                        nfBtn.label.snp.remakeConstraints { (make) in
                            make.left.right.bottom.equalTo(nfBtn)
                            make.height.equalTo(14)
                        }
                    }
                    
                    if !array[1].isEmpty && array[5].isEmpty {
                        nfBtn.label.text = array[1]
                        nfBtn.label.snp.remakeConstraints { (make) in
                            make.left.right.equalTo(nfBtn)
                            make.center.equalTo(nfBtn)
                        }
                        nfBtn.imageV.isHidden = true
                        if !array[4].isEmpty {
                            nfBtn.label.textColor = UIColor(hex: array[4])
                        }
                    }
                    
                    if array[1].isEmpty && !array[5].isEmpty {
                        nfBtn.imageV.image = UIImage(data: Data(base64Encoded: array[5], options: .ignoreUnknownCharacters)!)
                        nfBtn.imageV.snp.remakeConstraints { (make) in
                            make.center.equalTo(nfBtn)
                            make.size.equalTo(CGSize(width: 30, height: 30))
                        }
                        nfBtn.label.isHidden = true
                    }
                    
                    if !array[4].isEmpty {
                        nfBtn.label.textColor = UIColor(hex: array[4])
                    }
                    
                    if !array[3].isEmpty {
                        nfBtn.backgroundColor = UIColor(hex: array[3])
                    }
                    
                    nfBtn.frame = CGRect(x: CGFloat(i - 1) * CGFloat(UIScreen.main.bounds.width) / CGFloat(funcs.count - 1), y: 0, width: CGFloat(UIScreen.main.bounds.width) / CGFloat(funcs.count - 1), height: 44)
                    nfBtn.tag = i
                    nfBtn.addTarget(self, action: #selector(toolViewClick( _:)), for: .touchUpInside)
                }else if !array[2].isEmpty {
                    nfDataArr(array: array)
                    self.toolEventView.backgroundColor = UIColor(hex: array[3])
                }
            }
        }
    }
    
    func genAddBtn() {
        let btn = UIButton()
        btn.size = CGSize(width: 60, height: 40)
        btn.midx = view.width/2
        btn.by = kScreenHeight - kTabBarHeight
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        let img = UIImage(named: "addAccountBtnIcon")
        let imgv = UIImageView()
        imgv.image = img
        imgv.frame = btn.bounds.insetBy(dx: 15, dy: 8)
        btn.addSubview(imgv)
    }
    
    @objc func didChangeNotification(){
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait :
            nfPortrait()
            break
        case .landscapeLeft:
            nfLandLeftAndRight()
            break
        case .landscapeRight:
            nfLandLeftAndRight()
            break
        default:
            break
        }
    }
    
    func nfPortrait() {
        self.toolEventView.isHidden = false
        webview.snp.remakeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
        }
    }
    
    func nfLandLeftAndRight() {
        self.toolEventView.isHidden = true
        webview.snp.remakeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func addAccount() {
        let addView = ELAddAccountView()
        addView.show()
    }
    
    func genAccountTable() {
        let frm = kContainFrame//CGRect(x: 10, y: kTopBarHeight + 10, width: kScreenWidth - 20, height: kScreenHeight - kTopBarHeight - kTabBarHeight - 20)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frm.width, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        accountTable = UICollectionView(frame: frm, collectionViewLayout: layout)
        accountTable.delegate = self
        accountTable.dataSource = self
        accountTable.backgroundColor = .clear
        accountTable.register(AccountCell.self, forCellWithReuseIdentifier: "AccountCellId")
        view.addSubview(accountTable)
    }
    
    @objc func toolViewClick(_ button: UIButton) {
        let contets = self.funcs[button.tag].components(separatedBy: "<^>")
        if contets[0] == "H" {
            nfDataArr(array: contets)
        }else if contets[0] == "B" {
            if webview.canGoBack {
                webview.goBack()
            }
        }else if contets[0] == "S" {
            nfDataArr(array: contets)
        }else if contets[0] == "R" {
            webview.reload()
        }else if contets[0] == "C" {
            clearCache()
        }else if contets[0] == "K" {
            nfDataArr(array: contets)
        }
    }
    
    func clearCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let files = FileManager.default.subpaths(atPath: cachePath!)
        for file in files! {
            let path = (cachePath!).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                }
            }
        }
    }
    
    lazy var kongView:UIView! = {()->UIView in
        let tip = UIView()
        let w:CGFloat = 170
        let h:CGFloat = 120
        tip.frame = CGRect(x: (view.width - w)/2, y: (view.height - h)/2, width: w, height: h)
        tip.isHidden = true
        view.addSubview(tip)
        let imgv = UIImageView()
        imgv.frame = CGRect(x: (tip.width - 80)/2, y: 0, width: 80, height: 80)
        imgv.image = UIImage(named: "kongIcon")//?.withRenderingMode(.alwaysTemplate)
//        imgv.tintColor = kKeyColor
        tip.addSubview(imgv)
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.text = "no account yet"
        lbl.textColor = UIColor("dddddd")
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.frame = CGRect(x: 0, y: imgv.by, width: tip.width, height: tip.height - imgv.height)
        tip.addSubview(lbl)
        return tip
    }()
    
    func nfDataArr(array : [String]) {
        let urls = array[2].components(separatedBy: "<$>")
        var url = ""
        if urls.first == "H" {
            url = "http://"
        }
        if urls.first == "S" {
            url = "https://"
        }
        let endUrl = url + urls[1].replacingOccurrences(of: ",", with: ".") + "/" + urls[2]
        self.webview.loadRequest(URLRequest(url: URL(string: endUrl.trimmingCharacters(in: .whitespaces))!))
    }
}

extension ELAccountController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountCellId", for: indexPath) as! AccountCell
        cell.account = datas[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let account = datas[indexPath.row]
        let w = collectionView.width
        let h = 110 + getStringHeight(account.desc, width: w - 40, fontSize: 15)
        let size = CGSize(width: w, height: h)
        return size
    }
    
}

class AccountCell : UICollectionViewCell {
    var account:AccountModel! {
        didSet {
            icon.image = UIImage(named: account.accounticon) ?? UIImage(named: "cateIcon0")
            name.text = account.accountname
            pass.text = account.accountpass
            desc.text = account.desc
            pass.isSecureTextEntry = !account.showPass
            eyeBtn.isSelected = account.showPass
        }
    }
    
    lazy var bgView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.setRadius(radius: 10)
        addSubview(v)
        return v
    }()
    lazy var icon:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .gray
        v.setRadius(radius: 6)
        bgView.addSubview(v)
        return v
    }()
    
    lazy var name:UILabel = {
        let v = UILabel()
        v.textColor = .black
        bgView.addSubview(v)
        return v
    }()
    lazy var pass:UITextField = {
        let v = UITextField()
        v.isSecureTextEntry = true
        v.isUserInteractionEnabled = false
        v.textColor = .black
        bgView.addSubview(v)
        return v
    }()
    lazy var desc:UITextView = {
        let v = UITextView()
        v.textColor = .black
        v.isUserInteractionEnabled = false
        v.font = .systemFont(ofSize:15)
        bgView.addSubview(v)
        return v
    }()
    lazy var copyBtn:UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "copyIcon"), for: .normal)
        v.addTarget(self, action: #selector(copyBtnClicked), for: .touchUpInside)
        bgView.addSubview(v)
        return v
    }()
    lazy var eyeBtn:UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "eyeIcon"), for: .normal)
        v.setImage(UIImage(named: "noEyeIcon"), for: .selected)
        v.addTarget(self, action: #selector(eyeBtnClicked), for: .touchUpInside)
        bgView.addSubview(v)
        return v
    }()
    @objc func eyeBtnClicked() {
        account.showPass = !account.showPass
        pass.isSecureTextEntry = !account.showPass
        eyeBtn.isSelected = account.showPass
    }
    @objc func copyBtnClicked() {
        UIPasteboard.general.string = account.accountpass
        SVProgressHUD.showSuccess(withStatus: "Copy Password Success.")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 10, y: 5, width: width - 20, height: height - 10)
        icon.frame = CGRect(x: bgView.width - 70, y: 10, width: 60, height: 60)
        icon.setRadius(radius: icon.height/2)
        name.frame = CGRect(x: 10, y: 10, width: bgView.width - icon.width - 30, height: 30)
        pass.frame = CGRect(x: name.x, y: name.by, width: name.width, height: 30)
        desc.frame = CGRect(x: 10, y: pass.by + 5, width: bgView.width - 20, height: bgView.height - pass.by - 20)
        copyBtn.frame = CGRect(x: bgView.width - 90, y: icon.by + 10, width: 30, height: 26)
        eyeBtn.frame = CGRect(x: bgView.width - 50, y: icon.by + 5, width: 30, height: 36)
    }
}
